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
    
    [Konashi addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [Konashi addObserver:self selector:@selector(updateRSSI) name:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];
    [Konashi addObserver:self selector:@selector(updateBatteryLevel) name:KONASHI_EVENT_UPDATE_BATTERY_LEVEL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)reset:(id)sender {
    [Konashi reset];
}

- (IBAction)requestReadBattery:(id)sender {
    [Konashi batteryLevelReadRequest];
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
    [Konashi pinMode:LED2 mode:OUTPUT];
    [Konashi digitalWrite:LED2 value:HIGH];
    
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
    [Konashi signalStrengthReadRequest];
}

- (void) updateRSSI
{
    float progress = -1.0 * [Konashi signalStrengthRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.dbBar.progress = progress / 100;
    
    NSLog(@"RSSI: %ddb", [Konashi signalStrengthRead]);
}

- (void) updateBatteryLevel
{
    float progress = [Konashi batteryLevelRead];
    
    if(progress > 100.0){
        progress = 100.0;
    }
    
    self.batteryBar.progress = progress / 100;
    
    NSLog(@"BATTERY LEVEL: %d%%", [Konashi batteryLevelRead]);
}

@end
