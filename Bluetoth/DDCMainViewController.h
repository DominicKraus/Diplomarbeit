//
//  DDCMainViewController.h
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import "DDCFlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface DDCMainViewController : UIViewController <DDCFlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
