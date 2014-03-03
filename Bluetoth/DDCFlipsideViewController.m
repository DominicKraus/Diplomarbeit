//
//  DDCFlipsideViewController.m
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import "DDCFlipsideViewController.h"

@interface DDCFlipsideViewController ()

@end

@implementation DDCFlipsideViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Hide status bar
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [_brightnessSlider setValue:1.0 animated:FALSE];
    
    //Unit Picker
    _pickerData = [[NSMutableArray alloc] init];
    [_pickerData addObject:@"Metric"];
    [_pickerData addObject:@"Inch"];
    
    [_unitPicker setDataSource:self];
    [_unitPicker setDelegate:self];
    
    //Scale table
    _tableData = [[NSMutableArray alloc] init];
    [_tableData addObject:@"1:1"];
    [_tableData addObject:@"1:100"];
    
    [_scaleTable setDataSource:self];
    [_scaleTable setDelegate:self];
	// Do any additional setup after loading theview, typically from a nib.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.delegate didSelectUnit:[_pickerData objectAtIndex:row]];
    NSLog(@"Did select new unit %@", [_pickerData objectAtIndex:row]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_scaleTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"M";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectNewScale:[_tableData objectAtIndex:indexPath.row]];
    NSLog(@"Did select new scale %@", [_tableData objectAtIndex:indexPath.row]);
    

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if(_oldCheckMark!=nil){
        UITableViewCell *cellOld = [tableView cellForRowAtIndexPath:_oldCheckMark];
        [cellOld setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    _oldCheckMark = indexPath;

}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)didChangeBrightnessValue:(id)sender {
    [self.delegate didUpdateBrightnessValue:[_brightnessSlider value]];
    NSLog(@"Did change Brightness: %f", [_brightnessSlider value]);
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)didPressPlusButton:(id)sender {
    UIAlertView *inputView = [[UIAlertView alloc] initWithTitle:@"Add scale" message:@"Please write your Scale (e.g.: value:value)" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [inputView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [inputView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSLog(@"Added new Scale");
        NSString *newScale = [[alertView textFieldAtIndex:0] text];
        [_tableData addObject:newScale];
        [_scaleTable reloadData];
    }
}
@end
