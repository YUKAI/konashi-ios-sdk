//
//  ViewController.m
//  SPISample
//
//  Created by Akira Matsuda on 10/25/15.
//  Copyright © 2015 YUKAI Engineering.Inc. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UITextView *spiLogTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// Override point for customization after application launch.
	[[Konashi shared] setConnectedHandler:^{
		NSLog(@"CONNECTED");
	}];
	[[Konashi shared] setReadyHandler:^{
		NSLog(@"READY");
		KonashiResult result = [Konashi uartMode:KonashiUartModeEnable baudrate:KonashiUartBaudrateRate9K6];
		if (result == KonashiResultSuccess) {
			result = [Konashi pinMode:KonashiDigitalIO2 mode:KonashiPinModeOutput];
		}
		if (result == KonashiResultSuccess) {
			result = [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelHigh];
		}
		if (result == KonashiResultSuccess) {
			result = [Konashi spiMode:KonashiSPIModeEnableCPOL0CPHA0 speed:KonashiSPISpeed200K bitOrder:KonashiSPIBitOrderMSBFirst];
		}
		if (result == KonashiResultSuccess) {
			NSLog(@"Ready to use SPI.");
			[[Konashi shared] setSpiWriteCompleteHandler:^{
				[Konashi spiReadRequest];
			}];
			[[Konashi shared] setSpiReadCompleteHandler:^(NSData *data) {
				self.spiLogTextView.text = [data description];
				NSLog(@"SPI Read %@", [data description]);
				[Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelHigh];
			}];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - 

- (IBAction)find:(id)sender
{
	[Konashi find];
}

- (IBAction)send:(id)sender
{
	KonashiResult result = KonashiResultFailure;
	// チップセレクトしたPIOを下げる
	result = [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelLow];
	if (result == KonashiResultSuccess) {
		// データを送信（0x61~0x6b）
		Byte data[11] = {0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b};
		result = [Konashi spiWrite:[NSData dataWithBytes:&data length:11]];
	}
	if (result == KonashiResultSuccess) {
		// チップセレクトしたPIOを上げる
		result = [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelHigh];
	}
	NSLog(@"SPI send result : %d (0 == success)", result);
}

@end
