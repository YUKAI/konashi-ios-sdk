//
//  CommViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "CommViewController.h"
#import "Konashi.h"

@interface CommViewController ()
{
	KonashiUartBaudrate baudrate;
	NSArray *baudrateList;
}

@end

@implementation CommViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // UART系のイベントハンドラ
	[Konashi shared].uartRxCompleteHandler = ^(NSData *data) {
		NSLog(@"uart RX complete:%@", [data description]);
		NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		self.uartRecvText.text = [self.uartRecvText.text stringByAppendingString:string];
	};
    
    // I2C系のイベントハンドラ
    [Konashi addObserver:self selector:@selector(onI2cRecv) name:KonashiEventI2CReadCompleteNotification];
	[Konashi shared].i2cReadCompleteHandler = ^(NSData *data) {
		NSLog(@"i2c read complete:%@(%ld)", [data description], data.length);
	};
	
	baudrate = KonashiUartBaudrateRate2K4;
	baudrateList = @[@"2400", @"9600", @"19200", @"38400", @"57600", @"76800", @"115200"];
	self.uartBaudrateLabel.text = @"2400";
	
	[self.uartSetting addTarget:self action:@selector(onChageUartSetting:) forControlEvents:UIControlEventValueChanged];
	[self.i2cSetting addTarget:self action:@selector(onChageI2cSetting:) forControlEvents:UIControlEventValueChanged];
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
		[Konashi uartBaudrate:baudrate];
        [Konashi uartMode:KonashiUartModeEnable];
    }
    else {
        [Konashi uartMode:KonashiUartModeDisable];
    }
}

- (IBAction)uartSend:(id)sender
{
	[Konashi uartWriteData:[self.uartSendText.text dataUsingEncoding:NSASCIIStringEncoding]];
}

- (IBAction)changeBaudrate:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select baudrate" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
	for (NSString *title in baudrateList) {
		[actionSheet addButtonWithTitle:title];
	}
	[actionSheet setCancelButtonIndex:0];
	[actionSheet showInView:self.view];
}

- (IBAction)clearUartTextView:(id)sender
{
	self.uartRecvText.text = @"";
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
    unsigned char t[[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]];
    int i;
    
    for(i=0; i<(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
        t[i] = 'A' + i;
    }
    
    [Konashi i2cStartCondition];
    [NSThread sleepForTimeInterval:0.01];
	[Konashi i2cWriteData:[NSData dataWithBytes:t length:(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]] address:0x1F];
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
    unsigned char data[[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]];
    
    [Konashi i2cRead:(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength] data:data];
    [NSThread sleepForTimeInterval:0.01];
    [Konashi i2cStopCondition];
    
    int i;
    for(i=0; i<(int)[[[Konashi shared].activePeripheral.impl class] i2cDataMaxLength]; i++){
        NSLog(@"I2C Recv data: %d", data[i]);
        self.i2cRecvText.text = [self.i2cRecvText.text stringByAppendingString:[NSString stringWithFormat:@"%d ", data[i]]];
    }
}

- (IBAction)clearI2CTextView:(id)sender
{
	self.i2cRecvText.text = @"";
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex > 0) {
		baudrate = (KonashiUartBaudrate)([baudrateList[buttonIndex - 1] integerValue] / 240);
		self.uartBaudrateLabel.text = baudrateList[buttonIndex - 1];
		[Konashi uartBaudrate:baudrate];
	}
}

@end
