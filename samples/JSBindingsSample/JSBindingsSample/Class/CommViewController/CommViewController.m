//
//  CommViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "CommViewController.h"
#import "Konashi.h"
#import "Konashi+JavaScriptBindings.h"

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
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"onUartRx" hendler:^(JSValue *value) {
		JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.readUartData();"];
		NSData *data = [v toObject];
		NSLog(@"UartRx data: %@", [data description]);
		
		NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		if (string) {
			self.uartRecvText.text = [self.uartRecvText.text stringByAppendingString:string];
		}
	}];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"onI2cRecv" hendler:^(JSValue *value) {
		//TODO: buggy
		JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.i2cReadData();"]];
		NSData *data = [v toObject];
		[NSThread sleepForTimeInterval:0.01];
		[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStopCondition();"];
		
		int i;
		unsigned char *d = (unsigned char *)[data bytes];
		for(i=0; i<(long)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
			NSLog(@"I2C Recv data: %d", d[i]);
			self.i2cRecvText.text = [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", d[i]]];
		}
	}];
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.uartRxComplete = function() {\
		KonashiBridgeHandler.onUartRx();\
	 };\
	 Konashi.i2cReadComplete = function() {\
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
    int i;
    for(i=0; i<self.uartSendText.text.length; i++){
		[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.uartWriteString('%@');", [self.uartSendText.text substringWithRange:NSMakeRange(i, 1)]]];
    }
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
	NSMutableString *string = [NSMutableString new];
    for(int i=0; i<(long)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
		[string appendFormat:@"%c", 'A' + i];
    }
	
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStartCondition();"];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.i2cWriteString('%@', 0x1F);", string]];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStopCondition();"];
    [NSThread sleepForTimeInterval:0.01];
}

- (IBAction)i2cRecv:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.i2cStartCondition();"];
    [NSThread sleepForTimeInterval:0.01];
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.i2cReadRequest(%ld, 0x1F);", (long)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]]];
}

@end
