//
//  PwnViewController.h
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PwnViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting0;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting1;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting2;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting3;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting4;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting5;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting6;
@property (weak, nonatomic) IBOutlet UISwitch *pwmSetting7;

@property (weak, nonatomic) IBOutlet UISlider *pwmDuty0;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty1;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty2;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty3;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty4;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty5;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty6;
@property (weak, nonatomic) IBOutlet UISlider *pwmDuty7;

@property (weak, nonatomic) IBOutlet UITextField *period;
@property (weak, nonatomic) IBOutlet UITextField *duty;
@property (weak, nonatomic) IBOutlet UITextField *port;
- (IBAction)pushSet:(id)sender;
- (IBAction)endEdit:(id)sender;
@end
