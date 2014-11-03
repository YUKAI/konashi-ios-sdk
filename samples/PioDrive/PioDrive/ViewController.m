//
//  ViewController.m
//  PioDrive
//
//  Created on 12/22/12.
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
    
    [Konashi initialize];
    //[Konashi findWithName:@"konashi#4-0452"];
    
    //[Konashi addObserver:self selector:@selector(cmPoweredOn) name:KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON];
    //[Konashi addObserver:self selector:@selector(peripheralNotFound) name:KONASHI_EVENT_PERIPHERAL_NOT_FOUND];
    [Konashi addObserver:self selector:@selector(disconnected) name:KONASHI_EVENT_DISCONNECTED];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [Konashi addObserver:self selector:@selector(updatePioInput) name:KONASHI_EVENT_UPDATE_PIO_INPUT];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    //[Konashi findWithName:@"konashi#4-0960"];
    [Konashi find];
}

- (IBAction)disconnect:(id)sender {
    [Konashi disconnect];
}

- (IBAction)upLed3:(id)sender {
    [Konashi digitalWrite:KonashiLED3 value:KonashiLevelLow];
}

- (IBAction)downLed3:(id)sender {
    [Konashi digitalWrite:KonashiLED3 value:KonashiLevelHigh];
}

- (IBAction)upLed4:(id)sender {
    [Konashi digitalWrite:KonashiLED4 value:KonashiLevelLow];
}

- (IBAction)downLed4:(id)sender {
    [Konashi digitalWrite:KonashiLED4 value:KonashiLevelHigh];
}

- (IBAction)upLed5:(id)sender {
    [Konashi digitalWrite:KonashiLED5 value:KonashiLevelLow];
}

- (IBAction)downLed5:(id)sender {
    [Konashi digitalWrite:KonashiLED5 value:KonashiLevelHigh];
}

/*- (void) cmPoweredOn
{
    [Konashi find];
}*/

/*- (void) peripheralNotFound
{
    NSLog(@"peripheralNotFound :-(");
}*/

- (void) disconnected
{
    NSLog(@"DISCONNECTED");
}

- (void) ready
{
    NSLog(@"READY peripheral name:%@", [Konashi peripheralName]);
    
    // Show buttons
    self.led3.hidden = NO;
    self.led4.hidden = NO;
    self.led5.hidden = NO;
    self.pioMessage.hidden = NO;
    
    [Konashi pinMode:KonashiS1 mode:KonashiPinModeInput];
    [Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
    [Konashi pinMode:KonashiLED3 mode:KonashiPinModeOutput];
    [Konashi pinMode:KonashiLED4 mode:KonashiPinModeOutput];
    [Konashi pinMode:KonashiLED5 mode:KonashiPinModeOutput];
    
    //[Konashi pinModeAll:0b11111110];
}

- (void) updatePioInput
{
    NSLog(@"UPDATE_PIO_INPUT");
    
    if([Konashi digitalRead:KonashiS1]){
        [Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
    } else {
        [Konashi digitalWrite:KonashiLED2 value:KonashiLevelLow];
    }
}

@end
