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
            [Konashi pwmMode:PIO0 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO0 dutyRatio:self.pwmDuty0.value * 100];
        } else {
            [Konashi pwmMode:PIO0 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting1){
        if(setting.on){
            [Konashi pwmMode:PIO1 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO1 dutyRatio:self.pwmDuty1.value * 100];
        } else {
            [Konashi pwmMode:PIO1 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting2){
        if(setting.on){
            [Konashi pwmMode:PIO2 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO2 dutyRatio:self.pwmDuty2.value * 100];
        } else {
            [Konashi pwmMode:PIO2 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting3){
        if(setting.on){
            [Konashi pwmMode:PIO3 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO3 dutyRatio:self.pwmDuty3.value * 100];
        } else {
            [Konashi pwmMode:PIO3 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting4){
        if(setting.on){
            [Konashi pwmMode:PIO4 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO4 dutyRatio:self.pwmDuty4.value * 100];
        } else {
            [Konashi pwmMode:PIO4 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting5){
        if(setting.on){
            [Konashi pwmMode:PIO5 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO5 dutyRatio:self.pwmDuty5.value * 100];
        } else {
            [Konashi pwmMode:PIO5 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting6){
        if(setting.on){
            [Konashi pwmMode:PIO6 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO6 dutyRatio:self.pwmDuty6.value * 100];
        } else {
            [Konashi pwmMode:PIO6 mode:KONASHI_PWM_DISABLE];
        }
    }
    else if(setting == self.pwmSetting7){
        if(setting.on){
            [Konashi pwmMode:PIO7 mode:KONASHI_PWM_ENABLE_LED_MODE];
            [Konashi pwmLedDrive:PIO7 dutyRatio:self.pwmDuty7.value * 100];
        } else {
            [Konashi pwmMode:PIO7 mode:KONASHI_PWM_DISABLE];
        }
    }
}

- (void)onChangeDuty:(id)sender
{
    UISlider *slider = (UISlider *)sender;

    if(slider == self.pwmDuty0){
        if(self.pwmSetting0.on){
            [Konashi pwmLedDrive:PIO0 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty1){
        if(self.pwmSetting1.on){
            [Konashi pwmLedDrive:PIO1 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty2){
        if(self.pwmSetting2.on){
            [Konashi pwmLedDrive:PIO2 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty3){
        if(self.pwmSetting3.on){
            [Konashi pwmLedDrive:PIO3 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty4){
        if(self.pwmSetting4.on){
            [Konashi pwmLedDrive:PIO4 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty5){
        if(self.pwmSetting5.on){
            [Konashi pwmLedDrive:PIO5 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty6){
        if(self.pwmSetting6.on){
            [Konashi pwmLedDrive:PIO6 dutyRatio:slider.value * 100];
        }
    }
    else if(slider == self.pwmDuty7){
        if(self.pwmSetting7.on){
            [Konashi pwmLedDrive:PIO7 dutyRatio:slider.value * 100];
        }
    }
}

- (IBAction)pushSet:(id)sender {
    [Konashi pwmPeriod:[self.port.text intValue] period:[self.period.text intValue]];
    [Konashi pwmDuty:[self.port.text intValue] duty:[self.duty.text intValue]];
    [Konashi pwmMode:[self.port.text intValue] mode:KONASHI_PWM_ENABLE];
    
    /*
    int period = [self.period.text intValue];
    int duty = [self.duty.text intValue];
    
    [Konashi pwmPeriod:PIO0 period:period];
    [Konashi pwmDuty:PIO0 duty:duty];
    [Konashi pwmPeriod:PIO1 period:period];
    [Konashi pwmDuty:PIO1 duty:duty];
    [Konashi pwmPeriod:PIO2 period:period];
    [Konashi pwmDuty:PIO2 duty:duty];
    [Konashi pwmPeriod:PIO3 period:period];
    [Konashi pwmDuty:PIO3 duty:duty];
    [Konashi pwmPeriod:PIO4 period:period];
    [Konashi pwmDuty:PIO4 duty:duty];
    [Konashi pwmPeriod:PIO5 period:period];
    [Konashi pwmDuty:PIO5 duty:duty];
    [Konashi pwmPeriod:PIO6 period:period];
    [Konashi pwmDuty:PIO6 duty:duty];
    [Konashi pwmPeriod:PIO7 period:period];
    [Konashi pwmDuty:PIO7 duty:duty];
     
    [Konashi pwmMode:PIO0 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO1 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO2 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO3 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO4 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO5 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO6 mode:KONASHI_PWM_ENABLE];
    [Konashi pwmMode:PIO7 mode:KONASHI_PWM_ENABLE];
    */
}

- (IBAction)endEdit:(id)sender {
    UITextField *tf = (UITextField *)sender;
    
    [tf resignFirstResponder];
}

@end
