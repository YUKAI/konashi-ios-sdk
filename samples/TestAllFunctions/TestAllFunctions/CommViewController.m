//
//  CommViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "CommViewController.h"
#import "Konashi.h"
#import "Konashi+LegacyAPI.h"

@interface CommViewController ()

@end

@implementation CommViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // UART系のイベントハンドラ
    [self.uartSetting addTarget:self action:@selector(onChageUartSetting:) forControlEvents:UIControlEventValueChanged];
    [Konashi addObserver:self selector:@selector(onUartRx) name:KonashiEventUartRxCompleteNotification];
	[Konashi shared].uartRxCompleteHandler = ^(unsigned char value) {
		NSLog(@"uart RX complete:%d", value);
	};
    
    // I2C系のイベントハンドラ
    [self.i2cSetting addTarget:self action:@selector(onChageI2cSetting:) forControlEvents:UIControlEventValueChanged];
    [Konashi addObserver:self selector:@selector(onI2cRecv) name:KonashiEventI2CReadCompleteNotification];
	[Konashi shared].i2cReadCompleteHandler = ^(NSData *data) {
		NSLog(@"i2c read complete:%@", [data description]);
	};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////////////////////////
// UART

- (void)onChageUartSetting:(id)sender
{
    if(self.uartSetting.on){
        if(self.uartBaudrate.selectedSegmentIndex == 0) {
            NSLog(@"2400");
            [Konashi uartBaudrate:KonashiUartBaudrateRate2K4];
        } else {
            NSLog(@"9600");
            [Konashi uartBaudrate:KonashiUartBaudrateRate9K6];
        }
        
        [Konashi uartMode:KonashiUartModeEnable];
    }
    else {
        [Konashi uartMode:KonashiUartModeDisable];
    }
}

- (IBAction)uartSend:(id)sender {
    unsigned char data;
    int i;
    
    for(i=0; i<self.uartSendText.text.length; i++){
        data = (unsigned char)*[[self.uartSendText.text substringWithRange:NSMakeRange(i, 1)] UTF8String];
        [Konashi uartWrite:data];
    }
}

- (void)onUartRx
{
    unsigned char data = [Konashi uartRead];
    NSLog(@"UartRx data: %d", data);

    self.uartRecvText.text =
        [self.uartRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%c", data]];
}


/////////////////////////////////////
// I2C

- (void)onChageI2cSetting:(id)sender
{
    if(self.i2cSetting.on){
        if(self.i2cSpeed.selectedSegmentIndex == 0) {
            [Konashi i2cMode:KonashiI2CModeEnable100K];
        } else {
            [Konashi i2cMode:KonashiI2CModeEnable400K];
        }
    }
    else {
        [Konashi i2cMode:KonashiI2CModeDisable];
    }
}

- (IBAction)i2cSend:(id)sender {
    unsigned char t[18];
    int i;
    
    for(i=0; i<(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
        t[i] = 'A' + i;
    }
    
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cWrite:(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength] data:t address:0x1F];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    [NSThread sleepForTimeInterval:0.01];
}

- (IBAction)i2cRecv:(id)sender {
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cReadRequest:(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength] address:0x1F];
}

- (void)onI2cRecv
{
    unsigned char data[18];
    
    [Konashi i2cRead:(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength] data:data];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    
    int i;
    for(i=0; i<(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
        NSLog(@"I2C Recv data: %d", data[i]);
        self.i2cRecvText.text =
            [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", data[i]]];
    }
}

@end
