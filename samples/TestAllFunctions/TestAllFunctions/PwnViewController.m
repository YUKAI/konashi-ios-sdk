//
//  PwnViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "PwnViewController.h"
#import "Konashi.h"

@interface PwnViewController ()

@end

@implementation PwnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.pwmSetting0 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting1 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting2 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting3 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting4 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting5 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting6 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    [self.pwmSetting7 addTarget:self action:@selector(onChangeSetting:) forControlEvents:UIControlEventValueChanged];
    
    [self.pwmDuty0 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty1 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty2 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty3 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty4 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty5 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty6 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
    [self.pwmDuty7 addTarget:self action:@selector(onChangeDuty:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onChangeSetting:(id)sender
{
    UISwitch *setting = (UISwitch *)sender;

    if(setting == self.pwmSetting0){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO0 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO0 dutyRatio:self.pwmDuty0.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO0 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting1){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO1 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO1 dutyRatio:self.pwmDuty1.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO1 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting2){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO2 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO2 dutyRatio:self.pwmDuty2.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO2 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting3){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO3 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO3 dutyRatio:self.pwmDuty3.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO3 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting4){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO4 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO4 dutyRatio:self.pwmDuty4.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO4 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting5){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO5 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO5 dutyRatio:self.pwmDuty5.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO5 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting6){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO6 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO6 dutyRatio:self.pwmDuty6.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO6 mode:KonashiPWMModeDisable];
        }
    }
    else if(setting == self.pwmSetting7){
        if(setting.on){
            [Konashi pwmMode:KonashiDigitalIO7 mode:KonashiPWMModeEnableLED];
            [Konashi pwmLedDrive:KonashiDigitalIO7 dutyRatio:self.pwmDuty7.value * 100];
        } else {
            [Konashi pwmMode:KonashiDigitalIO7 mode:KonashiPWMModeDisable];
        }
    }
}

- (void)onChangeDuty:(id)sender
{
    UISlider *slider = (UISlider *)sender;

    if(slider == self.pwmDuty0){
        if(self.pwmSetting0.on){
            [Konashi pwmLedDrive:KonashiDigitalIO0 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty1){
        if(self.pwmSetting1.on){
            [Konashi pwmLedDrive:KonashiDigitalIO1 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty2){
        if(self.pwmSetting2.on){
            [Konashi pwmLedDrive:KonashiDigitalIO2 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty3){
        if(self.pwmSetting3.on){
            [Konashi pwmLedDrive:KonashiDigitalIO3 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty4){
        if(self.pwmSetting4.on){
            [Konashi pwmLedDrive:KonashiDigitalIO4 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty5){
        if(self.pwmSetting5.on){
            [Konashi pwmLedDrive:KonashiDigitalIO5 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty6){
        if(self.pwmSetting6.on){
            [Konashi pwmLedDrive:KonashiDigitalIO6 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty7){
        if(self.pwmSetting7.on){
            [Konashi pwmLedDrive:KonashiDigitalIO7 dutyRatio:slider.value * 100];
        }
    }
}

- (IBAction)pushSet:(id)sender {
    [Konashi pwmPeriod:[self.port.text intValue] period:[self.period.text intValue]];
    [Konashi pwmDuty:[self.port.text intValue] duty:[self.duty.text intValue]];
    [Konashi pwmMode:[self.port.text intValue] mode:KonashiPWMModeEnable];
    
    /*
    int period = [self.period.text intValue];
    int duty = [self.duty.text intValue];
    
    [Konashi pwmPeriod:KonashiDigitalIO0 period:period];
    [Konashi pwmDuty:KonashiDigitalIO0 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO1 period:period];
    [Konashi pwmDuty:KonashiDigitalIO1 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO2 period:period];
    [Konashi pwmDuty:KonashiDigitalIO2 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO3 period:period];
    [Konashi pwmDuty:KonashiDigitalIO3 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO4 period:period];
    [Konashi pwmDuty:KonashiDigitalIO4 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO5 period:period];
    [Konashi pwmDuty:KonashiDigitalIO5 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO6 period:period];
    [Konashi pwmDuty:KonashiDigitalIO6 duty:duty];
    [Konashi pwmPeriod:KonashiDigitalIO7 period:period];
    [Konashi pwmDuty:KonashiDigitalIO7 duty:duty];
     
    [Konashi pwmMode:KonashiDigitalIO0 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO1 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO2 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO3 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO4 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO5 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO6 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:KonashiDigitalIO7 mode:KONASHI_PWM_ENABLE];
    */
}

- (IBAction)endEdit:(id)sender {
    UITextField *tf = (UITextField *)sender;
    
    [tf resignFirstResponder];
}

@end
