//
//  ViewController.m
//  I2cSample
//
//  Drive I2C LCD - ACM1602NI
//
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
    
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)clearLcd:(id)sender {
    NSLog(@"CLEAR_LCD");
    
    [self initLcd];
    
    [self writeCmd:0x31];
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
    
    [Konashi i2cMode:KonashiI2CModeEnable100K];
}

- (void) writeCmd:(unsigned char)cmd
{
    unsigned char t[2];
    
    t[0] = 0x00;  // the control byte is 0x00, the next folling byte is command byte
    t[1] = cmd;
    
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cWrite:2 data:t address:0b1010000];  // slaver address could only set to 1010000
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    [NSThread sleepForTimeInterval:0.01];
}

- (void) writeData:(unsigned char)data
{
    unsigned char t[2];
    
    t[0] = 0x80;  // the control byte is 0x80, the next folling byte is data byte
    t[1] = data;
    
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cWrite:2 data:t address:0b1010000];  // slaver address could only set to 1010000
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    [NSThread sleepForTimeInterval:0.01];
}

- (void) initLcd
{
    [self writeCmd:0x01];           // clear display
    [self writeCmd:0x38];           // 8bit 2lines
    [self writeCmd:0x0f];           // set display, cursor, blink on/off
    [self writeCmd:0x06];           // entry mode
    [self writeCmd:0x08 | 0x04];    // 0x0c: display ON

    [NSThread sleepForTimeInterval:0.1];
    
    [self writeCmd:0x80];           // set DDRAM address (position 00)
    
    [self writeData:'D'];
    [self writeData:'O'];
    [self writeData:'W'];
    [self writeData:'N'];
    [self writeData:'L'];
    [self writeData:'O'];
    [self writeData:'A'];
    [self writeData:'D'];
}

@end
