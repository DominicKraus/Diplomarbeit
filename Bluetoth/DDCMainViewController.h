//
//  DDCMainViewController.h
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import "DDCFlipsideViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreData/CoreData.h>

@interface DDCMainViewController : UIViewController <DDCFlipsideViewControllerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>

- (IBAction)didTouchSetScale:(id)sender;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *discoveredCharacteristic;
@property (strong, nonatomic) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UITextField *scaleText;
@property (weak, nonatomic) IBOutlet UIButton *setScaleButton;


@end
