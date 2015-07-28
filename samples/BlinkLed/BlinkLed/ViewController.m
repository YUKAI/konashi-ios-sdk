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
	
    [[Konashi shared] setReadyHandler:^{
        // Set pin mode to output
        [Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
        
        // blink timer
        self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(blink) userInfo:nil repeats:YES];
    }];
    
    [[Konashi shared] setDisconnectedHandler:^{
        // stop blinking
        [self.blinkTimer invalidate];
    }];
}

- (void)blink
{
    static BOOL glow = NO;
    glow = !glow;
    [Konashi digitalWrite:KonashiLED2 value:(glow ? KonashiLevelHigh : KonashiLevelLow)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

@end
