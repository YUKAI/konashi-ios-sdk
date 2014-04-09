//
//  CommViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "CommViewController.h"
#import "Konashi.h"

@interface CommViewController ()

@end

@implementation CommViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // UART系のイベントハンドラ
    [self.uartSetting addTarget:self action:@selector(onChageUartSetting:) forControlEvents:UIControlEventValueChanged];
	[Konashi sharedKonashi].uartRxCompleteHandler = ^(Konashi *konashi, unsigned char value) {
		NSLog(@"UartRx data: %d", value);
		
		self.uartRecvText.text = [self.uartRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%c", value]];
	};
//    [Konashi addObserver:self selector:@selector(onUartRx) name:KONASHI_EVENT_UART_RX_COMPLETE];
    
    // I2C系のイベントハンドラ
    [self.i2cSetting addTarget:self action:@selector(onChageI2cSetting:) forControlEvents:UIControlEventValueChanged];
	[Konashi sharedKonashi].i2cReadCompleteHandler = ^(Konashi *konashi, unsigned char *value) {
		unsigned char data[18];
		
		[[Konashi sharedKonashi] i2cRead:18 data:data];
		[NSThread sleepForTimeInterval:0.01];
		[[Konashi sharedKonashi] i2cStopCondition];
		
		int i;
		for(i=0; i<18; i++){
			NSLog(@"I2C Recv data: %d", data[i]);
			self.i2cRecvText.text =
            [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", data[i]]];
		}
	};
//    [Konashi addObserver:self selector:@selector(onI2cRecv) name:KONASHI_EVENT_I2C_READ_COMPLETE];
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
            [[Konashi sharedKonashi] setUartBaudrate:KonashiUartRate2K4];
        } else {
            NSLog(@"9600");
            [[Konashi sharedKonashi] setUartBaudrate:KonashiUartRate9K6];
        }
        
        [[Konashi sharedKonashi] setUartMode:KonashiUartModeEnable];
    }
    else {
        [[Konashi sharedKonashi] setUartMode:KonashiUartModeDisable];
    }
}

- (IBAction)uartSend:(id)sender {
    unsigned char data;
    int i;
    
    for(i=0; i<self.uartSendText.text.length; i++){
        data = (unsigned char)*[[self.uartSendText.text substringWithRange:NSMakeRange(i, 1)] UTF8String];
        [[Konashi sharedKonashi] uartWrite:data];
    }
}

- (void)onUartRx
{
    unsigned char data = [[Konashi sharedKonashi] uartRead];
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
            [[Konashi sharedKonashi] setI2CMode:KonashiI2CModeEnable100K];
        } else {
            [[Konashi sharedKonashi] setI2CMode:KonashiI2CModeEnable400K];
        }
    }
    else {
        [[Konashi sharedKonashi] setI2CMode:KonashiI2CModeDisable];
    }
}

- (IBAction)i2cSend:(id)sender {
    unsigned char t[18];
    int i;
    
    for(i=0; i<18; i++){
        t[i] = 'A' + i;
    }
    
    [[Konashi sharedKonashi] i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [[Konashi sharedKonashi] i2cWrite:18 data:t address:0x1F];
    [NSThread sleepForTimeInterval:0.01];
    [[Konashi sharedKonashi] i2cStopCondition];
    [NSThread sleepForTimeInterval:0.01];
}

- (IBAction)i2cRecv:(id)sender {
    [[Konashi sharedKonashi] i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
    [[Konashi sharedKonashi] i2cReadRequest:18 address:0x1F];
}

- (void)onI2cRecv
{
    unsigned char data[18];
    
    [[Konashi sharedKonashi] i2cRead:18 data:data];
    [NSThread sleepForTimeInterval:0.01];
    [[Konashi sharedKonashi] i2cStopCondition];
    
    int i;
    for(i=0; i<18; i++){
        NSLog(@"I2C Recv data: %d", data[i]);
        self.i2cRecvText.text =
            [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", data[i]]];
    }
}

@end
