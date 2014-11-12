//
//  PwnViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "PwnViewController.h"
#import "Konashi+JavaScriptBindings.h"

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
	NSString *pin = nil;
	CGFloat value = 0;
    if(setting == self.pwmSetting0){
		pin = @"Konashi.PIO0";
		value = self.pwmDuty0.value * 100;
    }
    else if(setting == self.pwmSetting1){
		pin = @"Konashi.PIO1";
		value = self.pwmDuty1.value * 100;
	}
    else if(setting == self.pwmSetting2){
		pin = @"Konashi.PIO2";
		value = self.pwmDuty2.value * 100;
	}
    else if(setting == self.pwmSetting3){
		pin = @"Konashi.PIO3";
		value = self.pwmDuty3.value * 100;
    }
    else if(setting == self.pwmSetting4){
		pin = @"Konashi.PIO4";
		value = self.pwmDuty4.value * 100;
	}
    else if(setting == self.pwmSetting5){
		pin = @"Konashi.PIO5";
		value = self.pwmDuty5.value * 100;
    }
    else if(setting == self.pwmSetting6){
		pin = @"Konashi.PIO6";
		value = self.pwmDuty6.value * 100;
    }
    else if(setting == self.pwmSetting7){
		pin = @"Konashi.PIO7";
		value = self.pwmDuty7.value * 100;
    }
	
	if(setting.on){
		[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"\
													 Konashi.pwmMode(%@, Konashi.KONASHI_PWM_ENABLE_LED_MODE);\
													 Konashi.pwmLedDrive(%@, %f);\
													 ", pin, pin, value]];
	} else {
		[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"\
													 Konashi.pwmMode(%@, Konashi.KONASHI_PWM_DISABLE);\
													 ", pin]];
	}
}

- (void)onChangeDuty:(id)sender
{
    UISlider *slider = (UISlider *)sender;

    if(slider == self.pwmDuty0){
        if(self.pwmSetting0.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO0, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty1){
        if(self.pwmSetting1.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO1, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty2){
        if(self.pwmSetting2.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO2, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty3){
        if(self.pwmSetting3.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO3, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty4){
        if(self.pwmSetting4.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO4, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty5){
        if(self.pwmSetting5.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO5, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty6){
        if(self.pwmSetting6.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO6, %f);", slider.value * 100]];
        }
    }
    else if(slider == self.pwmDuty7){
        if(self.pwmSetting7.on){
			[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pwmLedDrive(Konashi.PIO7, %f);", slider.value * 100]];
        }
    }
}

- (IBAction)pushSet:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"\
												 Konashi.pwmPeriod(%d, %d);",
												 [self.port.text intValue], [self.period.text intValue]]];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"\
												 Konashi.pwmDuty(%d, %d);",
												 [self.port.text intValue], [self.duty.text intValue]]];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"\
												 Konashi.pwmMode(%d, Konashi.KONASHI_PWM_ENABLE);",
												 [self.port.text intValue]]];
}

- (IBAction)endEdit:(id)sender {
    UITextField *tf = (UITextField *)sender;
    
    [tf resignFirstResponder];
}

@end
