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

@implementation DDCFlipsideViewController{
    Settings *settings;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)dealloc{
    [_scaleTable setEditing:FALSE];
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
    
    settings = [Settings getInstance];
    
    
    [_brightnessSlider setValue:[settings brightness] animated:FALSE];
    
    //Unit Picker
    _pickerData = [[NSMutableArray alloc] init];
    [_pickerData addObject:@"Metric"];
    [_pickerData addObject:@"Inch"];

    
    [_unitPicker setDataSource:self];
    [_unitPicker setDelegate:self];
    
    //Scale table
    _tableData = [[NSMutableArray alloc] initWithArray:[settings tableData]];
   
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
    if([[settings unit] isEqualToString:[_pickerData objectAtIndex:row]]){
        [pickerView selectRow:row inComponent:component animated:FALSE];
    }
    return [_pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.delegate didSelectUnit:[_pickerData objectAtIndex:row]];
    [settings setUnit:[_pickerData objectAtIndex:row]];
    NSLog(@"Did select new unit %@", [_pickerData objectAtIndex:row]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableData count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [_tableData removeObjectAtIndex:indexPath.row];
        if(indexPath.row == [settings indexPath].row){
            [settings setIndexPath:nil];
        }
        [_scaleTable reloadData];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_scaleTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_tableData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"M";

    if([settings indexPath]!=nil&&[settings indexPath].row==indexPath.row){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_oldCheckMark == indexPath){
        return;
    }
    
    [self.delegate didSelectNewScale:[_tableData objectAtIndex:indexPath.row]];
    [settings setIndexPath:indexPath];
    
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
    [settings setBrightness:[_brightnessSlider value]];
    NSLog(@"Did change Brightness: %f", [_brightnessSlider value]);
}

- (IBAction)done:(id)sender
{
    [settings setTableData:_tableData];
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
