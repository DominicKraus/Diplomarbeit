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
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
