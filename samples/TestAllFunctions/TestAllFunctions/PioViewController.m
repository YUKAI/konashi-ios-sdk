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
    [Konashi addObserver:self selector:@selector(updatePioInput) name:KonashiEventDigitalIODidUpdateNotification];
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
    
    if(pin==self.pin0){
        if(pin.on){
            self.out0.enabled = YES;
            self.pullup0.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO0 mode:KonashiPinModeOutput];
        } else {
            self.out0.enabled = NO;
            self.pullup0.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO0 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin1){
        if(pin.on){
            self.out1.enabled = YES;
            self.pullup1.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO1 mode:KonashiPinModeOutput];
        } else {
            self.out1.enabled = NO;
            self.pullup1.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO1 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin2){
        if(pin.on){
            self.out2.enabled = YES;
            self.pullup2.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO2 mode:KonashiPinModeOutput];
        } else {
            self.out2.enabled = NO;
            self.pullup2.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO2 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin3){
        if(pin.on){
            self.out3.enabled = YES;
            self.pullup3.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO3 mode:KonashiPinModeOutput];
        } else {
            self.out3.enabled = NO;
            self.pullup3.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO3 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin4){
        if(pin.on){
            self.out4.enabled = YES;
            self.pullup4.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO4 mode:KonashiPinModeOutput];
        } else {
            self.out4.enabled = NO;
            self.pullup4.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO4 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin5){
        if(pin.on){
            self.out5.enabled = YES;
            self.pullup5.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO5 mode:KonashiPinModeOutput];
        } else {
            self.out5.enabled = NO;
            self.pullup5.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO5 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin6){
        if(pin.on){
            self.out6.enabled = YES;
            self.pullup6.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO6 mode:KonashiPinModeOutput];
        } else {
            self.out6.enabled = NO;
            self.pullup6.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO6 mode:KonashiPinModeInput];
        }
    }
    else if(pin==self.pin7){
        if(pin.on){
            self.out7.enabled = YES;
            self.pullup7.enabled = NO;
            [Konashi pinMode:KonashiDigitalIO7 mode:KonashiPinModeOutput];
        } else {
            self.out7.enabled = NO;
            self.pullup7.enabled = YES;
            [Konashi pinMode:KonashiDigitalIO7 mode:KonashiPinModeInput];
        }
    }
}


/////////////////////////////////////
// OUTPUT / 出力

- (void)onChangeOutput:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
    
    if(pin==self.out0){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO0 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO0 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out1){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO1 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out2){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO2 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out3){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO3 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO3 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out4){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO4 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO4 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out5){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO5 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO5 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out6){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO6 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO6 value:KonashiLevelLow];
        }
    }
    else if(pin==self.out7){
        if(pin.on){
            [Konashi digitalWrite:KonashiDigitalIO7 value:KonashiLevelHigh];
        } else {
            [Konashi digitalWrite:KonashiDigitalIO7 value:KonashiLevelLow];
        }
    }
}


/////////////////////////////////////
// PULLUP / プルアップ

- (void)onChangePullup:(id)sender
{
    UISwitch *pin = (UISwitch *)sender;
    
    if(pin==self.pullup0){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO0 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO0 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO1 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup2){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO2 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO2 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup3){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO3 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO3 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup4){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO4 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO4 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup5){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO5 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO5 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup6){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO6 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO6 mode:KonashiPinModeNoPulls];
        }
    }
    else if(pin==self.pullup7){
        if(pin.on){
            [Konashi pinPullup:KonashiDigitalIO7 mode:KonashiPinModePullup];
        } else {
            [Konashi pinPullup:KonashiDigitalIO7 mode:KonashiPinModeNoPulls];
        }
    }
}


/////////////////////////////////////
// 入力の変化

- (void)updatePioInput
{
    self.in0.on = [Konashi digitalRead:KonashiDigitalIO0];
    self.in1.on = [Konashi digitalRead:KonashiDigitalIO1];
    self.in2.on = [Konashi digitalRead:KonashiDigitalIO2];
    self.in3.on = [Konashi digitalRead:KonashiDigitalIO3];
    self.in4.on = [Konashi digitalRead:KonashiDigitalIO4];
    self.in5.on = [Konashi digitalRead:KonashiDigitalIO5];
    self.in6.on = [Konashi digitalRead:KonashiDigitalIO6];
    self.in7.on = [Konashi digitalRead:KonashiDigitalIO7];
}

@end
