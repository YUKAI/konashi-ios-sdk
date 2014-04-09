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
    
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] connect];
}

- (void)ready
{
    [[Konashi sharedKonashi] pinMode:KonashiLED2 mode:KonashiPinModeOutput];
    [[Konashi sharedKonashi] digitalWrite:KonashiLED2 value:KonashiLevelHigh];
}

@end
