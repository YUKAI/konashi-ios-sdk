//
//  ViewController.m
//  ADCExtension
//
//  Created by yukai on 2013/10/08.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi+ADC.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize adcValueLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"Ready");
		[Konashi initADC:KONASHI_ADC_ADDR_00];
		[Konashi selectPowerMode:KONASHI_ADC_REFON_ADCON];
	}];
	[[Konashi shared] setI2cReadCompleteHandler:^(NSData *data) {
		uint8_t val[2];
		[Konashi i2cStopCondition];
		[Konashi i2cRead:2 data:val];
		int amp = val[0] * 256 + val[1];
		[adcValueLabel setText:[NSString stringWithFormat:@"%d",amp]];
		NSLog(@"ADC Value: %d\n",amp);
	}];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.9f target:self selector:@selector(readValue) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)readValue{
    [Konashi readADCWithChannel:KONASHI_ADC_CH0];
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

@end
