//
//  ViewController.m
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
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
	[[Konashi shared] setConnectedHandler:^{
		NSLog(@"CONNECTED");
	}];
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"READY");
		
		self.statusMessage.hidden = NO;
		
		[Konashi uartMode:KonashiUartModeEnable baudrate:KonashiUartBaudrateRate9K6];
	}];
	[[Konashi shared] setUartRxCompleteHandler:^(NSData *data) {
		NSLog(@"UartRx %@", [data description]);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)send:(id)sender {
    [Konashi uartWriteData:[NSData dataWithBytes:"A" length:1]];
}
@end
