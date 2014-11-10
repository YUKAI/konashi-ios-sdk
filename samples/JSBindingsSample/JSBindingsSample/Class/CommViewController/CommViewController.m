//
//  CommViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "CommViewController.h"
#import "Konashi.h"
#import "Konashi+JavaScriptCore.h"

@interface CommViewController ()

@end

@implementation CommViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // UART系のイベントハンドラ
	// I2C系のイベントハンドラ
    [self.uartSetting addTarget:self action:@selector(onChageUartSetting:) forControlEvents:UIControlEventValueChanged];
	[self.i2cSetting addTarget:self action:@selector(onChageI2cSetting:) forControlEvents:UIControlEventValueChanged];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithTarget:self selector:@selector(onUartRx)];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithTarget:self selector:@selector(onI2cRecv)];
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.UartRxComplete = function() {\
		KonashiBridgeHandler.onUartRx();\
	 };\
	 Konashi.I2CReadComplete = function() {\
		KonashiBridgeHandler.onI2cRecv();\
	 };"];
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
			[KNSJavaScriptVirtualMachine evaluateScript:@"\
			 Konashi.log('2400');\
			 Konashi.uartBaudrate(Konashi.KONASHI_UART_RATE_2K4);\
			 "];
        } else {
			[KNSJavaScriptVirtualMachine evaluateScript:@"\
			 Konashi.log('9600');\
			 Konashi.uartBaudrate(Konashi.KONASHI_UART_RATE_9K6);\
			 "];
        }
		
		[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.uartMode(Konashi.KONASHI_UART_ENABLE);"];
    }
    else {
		[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.uartMode(Konashi.KONASHI_UART_DISABLE);"];
    }
}

- (IBAction)uartSend:(id)sender {
    unsigned char data;
    int i;
    
    for(i=0; i<self.uartSendText.text.length; i++){
        data = (unsigned char)*[[self.uartSendText.text substringWithRange:NSMakeRange(i, 1)] UTF8String];
		[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.uartWrite(%c);", data]];
    }
}

- (void)onUartRx
{
	JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.uartRead();"];
	unsigned char data = [[v toString] UTF8String][0];
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
			[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cMode(Konashi.KONASHI_I2C_ENABLE_100K);"];
        } else {
			[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cMode(Konashi.KONASHI_I2C_ENABLE_400K);"];
        }
    }
    else {
		[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cMode(Konashi.KONASHI_I2C_DISABLE);"];
    }
}

- (IBAction)i2cSend:(id)sender {
    unsigned char t[18];
    int i;
    
    for(i=0; i<18; i++){
        t[i] = 'A' + i;
    }
	
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStartCondition();"];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.i2cWrite(18, %s, 0x1F);", t]];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStopCondition();"];
    [NSThread sleepForTimeInterval:0.01];
}

- (IBAction)i2cRecv:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStartCondition();"];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cReadRequest(18, 0x1F);"];
}

- (void)onI2cRecv
{
	//TODO: buggy
    unsigned char data[18];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.i2cRead(18, %s);", data]];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStopCondition();"];
    
    int i;
    for(i=0; i<18; i++){
        NSLog(@"I2C Recv data: %d", data[i]);
        self.i2cRecvText.text =
            [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", data[i]]];
    }
}

@end
