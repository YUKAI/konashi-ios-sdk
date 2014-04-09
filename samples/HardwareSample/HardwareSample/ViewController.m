//
//  ViewController.m
//  HardwareSample
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
    
    [[Konashi sharedKonashi] addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(updateRSSI) name:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(updateBatteryLevel) name:KONASHI_EVENT_UPDATE_BATTERY_LEVEL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] find];
}

- (IBAction)reset:(id)sender {
    [[Konashi sharedKonashi] reset];
}

- (IBAction)requestReadBattery:(id)sender {
    [[Konashi sharedKonashi] batteryLevelReadRequest];
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
    
    // LED2 on
    [[Konashi sharedKonashi] pinMode:KonashiLED2 mode:KonashiPinModeOutput];
    [[Konashi sharedKonashi] digitalWrite:KonashiLED2 value:KonashiLevelHigh];
    
    // Set RSSI timer
    NSTimer *tm = [NSTimer
                   scheduledTimerWithTimeInterval:01.0f
                   target:self
                   selector:@selector(onRSSITimer:)
                   userInfo:nil
                   repeats:YES
                   ];
    [tm fire];
}

- (void) onRSSITimer:(NSTimer*)timer
{
    [[Konashi sharedKonashi] signalStrengthReadRequest];
}

- (void) updateRSSI
{
    float progress = -1.0 * [[Konashi sharedKonashi] signalStrengthRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.dbBar.progress = progress / 100;
    
    NSLog(@"RSSI: %ddb", [[Konashi sharedKonashi] signalStrengthRead]);
}

- (void) updateBatteryLevel
{
    float progress = [[Konashi sharedKonashi] batteryLevelRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.batteryBar.progress = progress / 100;
    
    NSLog(@"BATTERY LEVEL: %d%%", [[Konashi sharedKonashi] batteryLevelRead]);
}

@end
