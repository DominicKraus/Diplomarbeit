//
//  DDCFlipsideViewController.h
//  Bluetoth
//
//  Created by Dominic Kraus on 23.02.14.
//  Copyright (c) 2014 Dominic Kraus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDCFlipsideViewController;

@protocol DDCFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(DDCFlipsideViewController *)controller;
- (void)didSelectNewScale:(NSString *)scale;
@end

@interface DDCFlipsideViewController : UIViewController

@property (weak, nonatomic) id <DDCFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
