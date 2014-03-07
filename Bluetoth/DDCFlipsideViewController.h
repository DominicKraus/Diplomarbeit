//
//  DDCFlipsideViewController.h
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@class DDCFlipsideViewController;

@protocol DDCFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(DDCFlipsideViewController *)controller;
- (void)didSelectNewScale:(NSString *)scale;
- (void)didUpdateBrightnessValue:(float)value;
- (void)didSelectUnit:(NSString *)unit;
@end

@interface DDCFlipsideViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) id <DDCFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *scaleTable;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (strong, nonatomic) NSMutableArray *pickerData;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSIndexPath *oldCheckMark;


- (IBAction)didChangeBrightnessValue:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)didPressPlusButton:(id)sender;

@end
