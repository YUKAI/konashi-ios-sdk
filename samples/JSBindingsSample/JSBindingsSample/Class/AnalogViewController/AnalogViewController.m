//
//  AnalogViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "AnalogViewController.h"
#import "Konashi.h"
#import "Konashi+JavaScriptCore.h"

@interface AnalogViewController ()

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
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithTarget:self selector:@selector(onGetAio0)];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithTarget:self selector:@selector(onGetAio1)];
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithTarget:self selector:@selector(onGetAio2)];
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.updateAnalogValueAio0 = function() {\
		KonashiBridgeHandler.onGetAio0();\
	 };\
	 Konashi.updateAnalogValueAio1 = function() {\
		KonashiBridgeHandler.onGetAio1();\
	 };\
	 Konashi.updateAnalogValueAio2 = function() {\
		KonashiBridgeHandler.onGetAio2();\
	 };\
	 "];
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
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.analogWrite(KonashiConst.AIO0, %d);", volt]];
}

- (IBAction)setAio1:(id)sender {
    int volt = (int)(self.dacBar1.value * 1300);
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.analogWrite(KonashiConst.AIO1, %d);", volt]];
}

- (IBAction)setAio2:(id)sender {
    int volt = (int)(self.dacBar2.value * 1300);
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.analogWrite(KonashiConst.AIO2, %d);", volt]];
}


/////////////////////////////////////
// ADC

- (IBAction)getAio0:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogReadRequest(Konashi.AIO0);"];
}

- (IBAction)getAio1:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogReadRequest(Konashi.AIO1);"];
}

- (IBAction)getAio2:(id)sender {
	[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogReadRequest(Konashi.AIO2);"];
}

- (void)onGetAio0
{
	JSValue *value = [KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogRead(Konashi.AIO0);"];
    self.adc0.text = [NSString stringWithFormat:@"%.3f", (double)[value toDouble] / 1000];
}
- (void)onGetAio1
{
	JSValue *value = [KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogRead(Konashi.AIO1);"];
    self.adc1.text = [NSString stringWithFormat:@"%.3f", (double)[value toDouble] / 1000];
}
- (void)onGetAio2
{
	JSValue *value = [KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.analogRead(Konashi.AIO2);"];
    self.adc2.text = [NSString stringWithFormat:@"%.3f", (double)[value toDouble] / 1000];
}

@end
