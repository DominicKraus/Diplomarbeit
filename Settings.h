//
//  Settings.h
//  Bluetoth
//
//  Created by Dominic Kraus on 06.03.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCAppDelegate.h"

@interface Settings : NSObject


@property(readwrite,nonatomic)NSArray *tableData;
@property(readwrite,nonatomic)NSIndexPath *indexPath;
@property(readwrite,nonatomic)float brightness;
@property(readwrite,nonatomic)NSString *unit;

+(Settings*)getInstance;
-(BOOL)retreiveCoreData;
-(BOOL)saveCoreData;

@end
