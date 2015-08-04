//
//  ViewController.m
//  GettingStarted
//
//  Created by sagiii on 2015/08/04.
//  Copyright (c) 2015年 sagiii. All rights reserved.
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
    
    // Register event handler
    [[Konashi shared] setReadyHandler:^{
        // Set pin mode to output
        [Konashi pinMode:KonashiLED2 mode:KonashiPinModeOutput];
        
        // Make LED2 glow
        [Konashi digitalWrite:KonashiLED2 value:KonashiLevelHigh];
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


@end
