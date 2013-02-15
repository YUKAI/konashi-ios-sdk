//
//  ViewController.m
//  AioSample
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [Konashi addObserver:self selector:@selector(readAio) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
    [Konashi addObserver:self selector:@selector(readAio0) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)setVoltage1000:(id)sender {
    [Konashi analogWrite:AIO1 milliVolt:1000];
}

- (IBAction)requestReadAio0:(id)sender {
    [Konashi analogReadRequest:AIO0];
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
    NSLog(@"READ_AIO0: %d", [Konashi analogRead:AIO0]);
}

@end
