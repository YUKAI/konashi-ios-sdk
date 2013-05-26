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
    [Konashi digitalWrite:LED3 value:LOW];
}

- (IBAction)downLed3:(id)sender {
    [Konashi digitalWrite:LED3 value:HIGH];
}

- (IBAction)upLed4:(id)sender {
    [Konashi digitalWrite:LED4 value:LOW];
}

- (IBAction)downLed4:(id)sender {
    [Konashi digitalWrite:LED4 value:HIGH];
}

- (IBAction)upLed5:(id)sender {
    [Konashi digitalWrite:LED5 value:LOW];
}

- (IBAction)downLed5:(id)sender {
    [Konashi digitalWrite:LED5 value:HIGH];
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
    
    [Konashi pinMode:S1 mode:INPUT];
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi pinMode:LED3 mode:OUTPUT];
    [Konashi pinMode:LED4 mode:OUTPUT];
    [Konashi pinMode:LED5 mode:OUTPUT];
    
    //[Konashi pinModeAll:0b11111110];
}

- (void) updatePioInput
{
    NSLog(@"UPDATE_PIO_INPUT");
    
    if([Konashi digitalRead:S1]){
        [Konashi digitalWrite:LED2 value:HIGH];
    } else {
        [Konashi digitalWrite:LED2 value:LOW];
    }
}

@end
