//
//  ViewController.h
//  PwmDrive
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UISlider *blightnessSlider;

- (IBAction)find:(id)sender;
- (IBAction)changeLedBlightness20:(id)sender;
- (IBAction)changeLedBlightness50:(id)sender;
- (IBAction)changeLedBlightness80:(id)sender;
- (IBAction)changeLedBlightnessBar:(id)sender;
@end
