//
//  ViewController.h
//  PioDrive
//
//  Created on 12/22/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pioMessage;
@property (weak, nonatomic) IBOutlet UIButton *led3;
@property (weak, nonatomic) IBOutlet UIButton *led4;
@property (weak, nonatomic) IBOutlet UIButton *led5;


- (IBAction)find:(id)sender;
- (IBAction)disconnect:(id)sender;

- (IBAction)upLed3:(id)sender;
- (IBAction)downLed3:(id)sender;
- (IBAction)upLed4:(id)sender;
- (IBAction)downLed4:(id)sender;
- (IBAction)upLed5:(id)sender;
- (IBAction)downLed5:(id)sender;


@end
