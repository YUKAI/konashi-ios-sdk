//
//  ViewController.m
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi/Konashi.h"
#import "Konashi/Konashi+UI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[Konashi sharedKonashi] addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];
    [[Konashi sharedKonashi] addObserver:self selector:@selector(recvUartRx) name:KONASHI_EVENT_UART_RX_COMPLETE];
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
    
    [[Konashi sharedKonashi] setUartBaudrate:KonashiUartRate9K6];
    [[Konashi sharedKonashi] setUartMode:KonashiUartModeEnable];
}

- (void) recvUartRx
{
    NSLog(@"UartRx %d", [[Konashi sharedKonashi] uartRead]);
}

- (IBAction)find:(id)sender {
    [[Konashi sharedKonashi] connectWithUserInterface];
}

- (IBAction)send:(id)sender {    
    [[Konashi sharedKonashi] uartWrite:'A'];
}
@end
