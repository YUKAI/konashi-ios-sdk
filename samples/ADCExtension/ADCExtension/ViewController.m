//
//  ViewController.m
//  ADCExtension
//
//  Created by yukai on 2013/10/08.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi/Konashi+UI.h"
#import "Konashi/Konashi+ADC.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize adcValueLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(completeI2cRead) name:KONASHI_EVENT_I2C_READ_COMPLETE];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.9f target:self selector:@selector(readValue) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ready{
    NSLog(@"Ready");
    [[Konashi sharedKonashi] initADC:KONASHI_ADC_ADDR_00];
    [[Konashi sharedKonashi] selectPowerMode:KONASHI_ADC_REFON_ADCON];
}

- (void)completeI2cRead{
    uint8_t val[2];
    [[Konashi sharedKonashi] i2cStopCondition];
    [[Konashi sharedKonashi] i2cRead:2 data:val];
    int amp=val[0]*256+val[1];
    [adcValueLabel setText:[NSString stringWithFormat:@"%d",amp]];
    NSLog(@"ADC Value: %d\n",amp);
}

- (void)readValue{
    [[Konashi sharedKonashi]readADCWithChannel:KONASHI_ADC_CH0];
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] connectWithUserInterface];
}

- (IBAction)disconnect:(id)sender {
    [[Konashi sharedKonashi] disconnect];
}
@end
