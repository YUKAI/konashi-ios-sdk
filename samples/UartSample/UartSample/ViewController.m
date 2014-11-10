//
//  ViewController.m
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"
#import "Konashi+LegacyAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KonashiEventConnectedNotification];
    [Konashi addObserver:self selector:@selector(ready) name:KonashiEventReadyToUseNotification];
    [Konashi addObserver:self selector:@selector(recvUartRx) name:KonashiEventUartRxCompleteNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) ready
{
    NSLog(@"READY");
    
    self.statusMessage.hidden = FALSE;
    
    [Konashi uartBaudrate:KonashiUartBaudrateRate9K6];
    [Konashi uartMode:KonashiUartModeEnable];
}

- (void) recvUartRx
{
    NSLog(@"UartRx %d", [Konashi uartRead]);
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)send:(id)sender {    
    [Konashi uartWrite:'A'];
}
@end
