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
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

- (IBAction)find:(id)sender;
- (IBAction)changeLedBrightness20:(id)sender;
- (IBAction)changeLedBrightness50:(id)sender;
- (IBAction)changeLedBrightness80:(id)sender;
- (IBAction)changeLedBrightnessBar:(id)sender;
@end
