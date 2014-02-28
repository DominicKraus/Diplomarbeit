//
//  DDCMainViewController.m
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import "DDCMainViewController.h"

@interface DDCMainViewController ()

@end

@implementation DDCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _data = [[NSMutableData alloc] init];
    
    _setScaleButton.enabled = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(DDCFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectNewScale:(NSString *)scale{
    //TODO
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString * state = nil;
    switch ([_centralManager state]) {
        case CBCentralManagerStatePoweredOn:
            state = @"BLE is available : Start scan";
            [_centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];   ///vl 2. auch nil
            break;
            
        case CBCentralManagerStatePoweredOff:
            state = @"Ble is turned off";
            break;
            
        default:
            state = @"Default: Not good!";
            break;
    }

    NSLog(@"Current BT-State: %@",state);
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if(_discoveredPeripheral != peripheral){
        _discoveredPeripheral = peripheral;
    }
    
    NSLog(@"Try connecting to device");
    [_centralManager connectPeripheral:peripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Did fail to connect!");
    [self cleanup];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"Connected!");
    
    [central stopScan];
    
    [_data setLength:0];
    
    [_setScaleButton setEnabled:true];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"Discovered Services!");
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
     NSLog(@"Discovered Characteristics!");
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        _discoveredCharacteristic = characteristic;                             //vl die falsche Characteristic, daher möglicherweise zuerst einmal etwas empfangen notwendig
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"Received Data!");
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSLog(stringFromData);
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        [_scaleText setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        [_scaleText reloadInputViews];
        
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
    
    [_data appendData:characteristic.value];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    /*if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }*/
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
        NSLog(@"Notification end on %@", characteristic);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    _discoveredCharacteristic = nil;
    NSLog(@"Did disconnect %@", peripheral.name);
    [_centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

-(void)cleanup{
    //checks if is subscribed to a characteristic on peripheral
    if(_discoveredPeripheral.services!=nil){
        /*
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:_dis) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
         */
        
         [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error){
        NSLog(@"Error while sending");
    }
    
    NSLog(@"Did send!");
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StoppedScan");
    [_centralManager stopScan];
}
 
- (IBAction)didTouchSetScale:(id)sender {
    NSData *data = [_scaleText.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Try to send data to peripheral");
    [_discoveredPeripheral writeValue:data forCharacteristic:_discoveredCharacteristic type:CBCharacteristicWriteWithoutResponse];
}
@end
