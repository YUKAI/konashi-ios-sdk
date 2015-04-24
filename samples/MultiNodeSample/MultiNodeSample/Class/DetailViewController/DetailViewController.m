//
//  DetailViewController.m
//  MultiNodeSample
//
//  Created by Akira Matsuda on 2/10/15.
//  Copyright (c) 2015 Akira Matsuda. All rights reserved.
//

#import "DetailViewController.h"
#import "Konashi.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *sendDataTextField;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Uart Broadcast test";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[KNSCentralManager sharedInstance].activePeripherals enumerateObjectsUsingBlock:^(KNSPeripheral *p, BOOL *stop) {
		[p uartMode:KonashiUartModeEnable baudrate:KonashiUartBaudrateRate9K6];
		[p setUartRxCompleteHandler:^(NSData *data) {
			NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			NSLog(@"uart RX complete:%@(length = %ld:%@)", string, (unsigned long)data.length, [data description]);
		}];
	}];
}

- (IBAction)sendData:(id)sender
{
	[[KNSCentralManager sharedInstance].activePeripherals enumerateObjectsUsingBlock:^(KNSPeripheral *p, BOOL *stop) {
		[p uartWriteData:[self.sendDataTextField.text dataUsingEncoding:NSASCIIStringEncoding]];
	}];
}

@end
