//
//  PioViewController.m
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import "PioViewController.h"
#import "Konashi.h"

@interface PioViewController ()

@end

@implementation PioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // I/O設定のスイッチのイベントハンドラ登録
    [self.pin0 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin1 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin2 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin3 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin4 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin5 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin6 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    [self.pin7 addTarget:self action:@selector(onChangePin:) forControlEvents:UIControlEventValueChanged];
    
    // 出力のスイッチのイベントハンドラ登録
    [self.out0 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out1 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out2 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out3 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out4 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out5 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out6 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    [self.out7 addTarget:self action:@selector(onChangeOutput:) forControlEvents:UIControlEventValueChanged];
    
    // プルアップのイベントハンドラ登録
    [self.pullup0 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup1 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup2 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup3 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup4 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup5 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup6 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];
    [self.pullup7 addTarget:self action:@selector(onChangePullup:) forControlEvents:UIControlEventValueChanged];

    // 入力状態の変化イベントハンドラ
	[KNSJavaScriptVirtualMachine addBridgeHandlerWithKey:@"updatePioInput" hendler:^(JSValue *value) {
		self.in0.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO0);"] toBool];
		self.in1.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO1);"] toBool];
		self.in2.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO2);"] toBool];
		self.in3.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO3);"] toBool];
		self.in4.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO4);"] toBool];
		self.in5.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO5);"] toBool];
		self.in6.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO6);"] toBool];
		self.in7.on = [[KNSJavaScriptVirtualMachine evaluateScript:@"Konashi.digitalRead(Konashi.PIO7);"] toBool];
	}];
	[KNSJavaScriptVirtualMachine evaluateScript:@"\
	 Konashi.updatePioInput = function() {\
		KonashiBridgeHandler.updatePioInput();\
	 };"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////////////////////////
// I/O設定

- (void)onChangePin:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
	
	__block NSString *pinNumber = nil;
	NSString *mode = nil;
	if(pin.on){
		mode = @"Konashi.OUTPUT";
	} else {
		mode = @"Konashi.INPUT";
	}
	[self.pinSettingSwitch enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (pin == obj) {
			pinNumber = [NSString stringWithFormat:@"Konashi.PIO%lu", (unsigned long)idx];
			UISwitch *sw = (UISwitch *)obj;
			if (sw.on == YES) {
				UISwitch *s = self.outputPinSwitch[idx];
				s.enabled = YES;
				s = self.pullupPinSwitch[idx];
				s.enabled = NO;
			}
			else {
				UISwitch *s = self.outputPinSwitch[idx];
				s.enabled = NO;
				s = self.pullupPinSwitch[idx];
				s.enabled = YES;
			}
			*stop = YES;
		}
	}];
	
	NSString *script = [NSString stringWithFormat:@"Konashi.pinMode(%@,%@);", pinNumber, mode];
	JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:script];
	NSLog(@"%@", [v description]);
}


/////////////////////////////////////
// OUTPUT / 出力

- (void)onChangeOutput:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
	NSString *level = nil;
	if(pin.on){
		level = @"Konashi.HIGH";
	} else {
		level = @"Konashi.LOW";
	}
	[self.outputPinSwitch enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (pin == obj) {
			NSString *pinNumber = [NSString stringWithFormat:@"Konashi.PIO%lu", (unsigned long)idx];
			NSString *script = [NSString stringWithFormat:@"Konashi.digitalWrite(%@,%@);", pinNumber, level];
			JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:script];
			NSLog(@"%@", [v description]);
			*stop = YES;
		}
	}];
}


/////////////////////////////////////
// PULLUP / プルアップ

- (void)onChangePullup:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
	
	NSString *pinNumber = nil;
	NSString *level = nil;
	if(pin.on){
		level = @"Konashi.PULLUP";
	} else {
		level = @"Konashi.NO_PULLS";
	}
	[self.outputPinSwitch enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (pin == obj) {
			NSString *pinNumber = [NSString stringWithFormat:@"Konashi.PIO%lu", (unsigned long)idx];
			NSString *script = [NSString stringWithFormat:@"Konashi.pinPullup(%@,%@);", pinNumber, level];
			JSValue *v = [KNSJavaScriptVirtualMachine evaluateScript:script];
			NSLog(@"%@", [v description]);
			*stop = YES;
		}
	}];
	if(pin==self.out0){
		pinNumber = @"Konashi.PIO0";
	}
	else if(pin==self.out1){
		pinNumber = @"Konashi.PIO1";
	}
	else if(pin==self.out2){
		pinNumber = @"Konashi.PIO2";
	}
	else if(pin==self.out3){
		pinNumber = @"Konashi.PIO3";
	}
	else if(pin==self.out4){
		pinNumber = @"Konashi.PIO4";
	}
	else if(pin==self.out5){
		pinNumber = @"Konashi.PIO5";
	}
	else if(pin==self.out6){
		pinNumber = @"Konashi.PIO6";
	}
	else if(pin==self.out7){
		pinNumber = @"Konashi.PIO7";
	}
	[KNSJavaScriptVirtualMachine evaluateScript:[NSString stringWithFormat:@"Konashi.pinPullup(%@,%@);", pinNumber, level]];
}

@end
