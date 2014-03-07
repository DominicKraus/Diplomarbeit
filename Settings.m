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
    self.tableData = [[NSArray alloc] initWithObjects:@"1:10",@"1:100", nil];
    self.indexPath = nil;
    self.unit = @"Metric";
    self.brightness = 1.0;
    
    return self;
}

+(Settings*) getInstance{
    if(!singelton){
        singelton = [[Settings alloc]init];
    }
    return singelton;
}

@end
