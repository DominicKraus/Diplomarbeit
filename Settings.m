//
//  Settings.m
//  Bluetoth
//
//  Created by Dominic Kraus on 06.03.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import "Settings.h"

@implementation Settings

static Settings *singelton;

-(id)init{
    self = [super init];

    /*
    if([self retreiveCoreData]){
        self.indexPath = nil;
        self.unit = @"Metric";
    }else{
     */
        self.tableData = [[NSArray alloc] initWithObjects:@"1:10",@"1:100", nil];
        self.indexPath = nil;
        self.unit = @"Metric";
        self.brightness = 1.0;
    //}
    return self;
}

+(Settings*) getInstance{
    if(!singelton){
        singelton = [[Settings alloc]init];
    }
    return singelton;
}

-(BOOL)saveCoreData{
    DDCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    for(NSString *scales in _tableData){
        NSManagedObject *newScale;
        NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
        NSEntityDescription *entityDesc = [[managedObjectModel entitiesByName] objectForKey:@"Scales"];
        newScale = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
        [newScale setValue:scales forKey:@"value"];
        [newScale setValue:_unit forKey:@"unit"];
    }
    
    NSManagedObject *newBrightness;
    newBrightness = [NSEntityDescription insertNewObjectForEntityForName:@"Brightness" inManagedObjectContext:context];
    [newBrightness setValue:[NSNumber numberWithFloat:_brightness] forKey:@"value"];
    
    NSError *error;
    [context save:&error];
    
    if(error){
        NSLog(@"Error happened! %@",[error description]);
        return false;
    }
    
    return true;
}


-(BOOL)retreiveCoreData{

    DDCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Scales" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSManagedObject *scaleInSQL = nil;
    
    NSError *error;
    
    NSArray *scales = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error occured %@", [error localizedDescription]);
    }
    
    if([scales count]==0){
        NSLog(@"No scales found");
        return false;
    }
    
    NSMutableArray *scaleValues;
    for(scaleInSQL in scales){
        [scaleValues addObject:[scaleInSQL valueForKey:@"value"]];
        _unit = [scaleInSQL valueForKey:@"unit"];
    }
    
    _tableData = scaleValues;
    
    NSEntityDescription *entityDescBrightness = [NSEntityDescription entityForName:@"Brightness" inManagedObjectContext:context];
    
    NSFetchRequest *brightnessRequest;
    [brightnessRequest setEntity:entityDescBrightness];
    
    NSManagedObject *brightnessInSQL = nil;
    
    NSError *errorBrightness;
    NSArray *brightness = [context executeFetchRequest:brightnessRequest error:&error];
    if(error){
        NSLog(@"Error occured %@", [errorBrightness localizedDescription]);
        return false;
    }
    
    brightnessInSQL = brightness[0];
    
    _brightness = [[brightness valueForKey:@"value"] floatValue];
    
    return true;
}


-(void)dealloc{
    DDCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    for(NSString *scales in _tableData){
        NSManagedObject *newScale;
        newScale = [NSEntityDescription insertNewObjectForEntityForName:@"Scales" inManagedObjectContext:context];
        [newScale setValue:scales forKey:@"value"];
        [newScale setValue:_unit forKey:@"unit"];
    }
    
    NSManagedObject *newBrightness;
    newBrightness = [NSEntityDescription insertNewObjectForEntityForName:@"Brightness" inManagedObjectContext:context];
    [newBrightness setValue:[NSNumber numberWithFloat:_brightness] forKey:@"value"];
    
    NSError *error;
    [context save:&error];
}

@end
