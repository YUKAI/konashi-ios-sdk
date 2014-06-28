//
//  AnalogViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "AnalogViewController.h"
#import "Konashi/Konashi.h"

@interface AnalogViewController ()
{
	NSArray *labelArray;
}
@end

@implementation AnalogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.dacBar0 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    [self.dacBar1 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    [self.dacBar2 addTarget:self action:@selector(onChangeDacBar:) forControlEvents:UIControlEventValueChanged];
    
    // ADC
	[Konashi sharedKonashi].analogPinDidChangeValueHandler = ^(Konashi *konashi, KonashiAnalogIOPin pin, int value) {
		UILabel *label = labelArray[pin];
		label.text = [NSString stringWithFormat:@"%.3f", (double)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO0] / 1000];
	};
//    [Konashi addObserver:self selector:@selector(onGetAio0) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
//    [Konashi addObserver:self selector:@selector(onGetAio1) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1];
//    [Konashi addObserver:self selector:@selector(onGetAio2) name:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	labelArray = @[self.adc0, self.adc1, self.adc2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////
// DAC

- (void)onChangeDacBar:(id)sender
{
    if(sender == self.dacBar0){
        self.dac0.text = [NSString stringWithFormat:@"%.3f", self.dacBar0.value * 1.3];
    }
    else if(sender == self.dacBar1){
        self.dac1.text = [NSString stringWithFormat:@"%.3f", self.dacBar1.value * 1.3];
    }
    else if(sender == self.dacBar2){
        self.dac2.text = [NSString stringWithFormat:@"%.3f", self.dacBar2.value * 1.3];
    }
}

- (IBAction)setAio0:(id)sender {
    int volt = (int)(self.dacBar0.value * 1300);
    [[Konashi sharedKonashi] analogWrite:KonashiAnalogIO0 milliVolt:volt];
}

- (IBAction)setAio1:(id)sender {
    int volt = (int)(self.dacBar1.value * 1300);
    [[Konashi sharedKonashi] analogWrite:KonashiAnalogIO1 milliVolt:volt];
}

- (IBAction)setAio2:(id)sender {
    int volt = (int)(self.dacBar2.value * 1300);
    [[Konashi sharedKonashi] analogWrite:KonashiAnalogIO2 milliVolt:volt];
}


/////////////////////////////////////
// ADC

- (IBAction)getAio0:(id)sender {
    [[Konashi sharedKonashi] analogReadRequest:KonashiAnalogIO0];
}

- (IBAction)getAio1:(id)sender {
    [[Konashi sharedKonashi] analogReadRequest:KonashiAnalogIO1];
}

- (IBAction)getAio2:(id)sender {
    [[Konashi sharedKonashi] analogReadRequest:KonashiAnalogIO2];
}

- (void)onGetAio0
{
    self.adc0.text = [NSString stringWithFormat:@"%.3f", (double)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO0] / 1000];
}
- (void)onGetAio1
{
    self.adc1.text = [NSString stringWithFormat:@"%.3f", (double)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO1] / 1000];
}
- (void)onGetAio2
{
    self.adc2.text = [NSString stringWithFormat:@"%.3f", (double)[[Konashi sharedKonashi] analogRead:KonashiAnalogIO2] / 1000];
}

@end
