//
//  ViewController.m
//  GettingStarted
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
	[[Konashi shared] setReadyHandler:^(){
		[Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
		[Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender
{
	[Konashi find];
}

@end
