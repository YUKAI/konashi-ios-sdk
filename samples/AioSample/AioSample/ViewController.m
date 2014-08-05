//
//  ViewController.m
//  AioSample
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi/Konashi.h"
#import "Konashi/Konashi+UI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
    [[Konashi sharedKonashi] addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(readAio) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(readAio0) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi]connectWithUserInterface];
}

- (IBAction)setVoltage1000:(id)sender {
    [[Konashi sharedKonashi] analogWrite:KonashiAnalogIO1 milliVolt:1000];
}

- (IBAction)requestReadAio0:(id)sender {
    [[Konashi sharedKonashi] analogReadRequest:KonashiAnalogIO0];
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
}

- (void) readAio
{
    NSLog(@"READ_AIO");
}

- (void) readAio0
{
    NSLog(@"READ_AIO0: %ld", (long)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO0]);
    self.adcValue.text = [NSString stringWithFormat:@"%.3f", (float)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO0]/1000];
}

@end
