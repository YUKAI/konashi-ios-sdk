//
//  ViewController.h
//  HardwareSample
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *dbBar;
@property (weak, nonatomic) IBOutlet UIProgressView *batteryBar;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;

- (IBAction)find:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)requestReadBattery:(id)sender;
@end
