//
//  ViewController.m
//  GroveExtension
//
//  Created by yukai on 2013/10/07.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi/Konashi+Grove.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(completeAnalogRead) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(readBrightness) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ready
{
    NSLog(@"Ready");
    [[Konashi sharedKonashi] setPWMMode:KonashiLED2 mode:KonashiPWMModeEnableLED];
}

- (void)completeAnalogRead
{
    int aioValue=[[Konashi sharedKonashi] analogRead:KonashiAnalogIO0];
    [[Konashi sharedKonashi] pwmLedDrive:KonashiLED2 dutyRatio:aioValue/13];
    NSLog(@"Brightness:%d",aioValue);
}

- (void)readBrightness
{
    [[Konashi sharedKonashi] readGroveAnalogPort:A0];
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] connect];
}

- (IBAction)disconnect:(id)sender {
    [[Konashi sharedKonashi] disconnect];
}
@end
