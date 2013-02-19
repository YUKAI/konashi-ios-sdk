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
    [Konashi addObserver:self selector:@selector(updatePioInput) name:KONASHI_EVENT_UPDATE_PIO_INPUT];
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
            [Konashi pinMode:PIO0 mode:OUTPUT];
        } else {
            self.out0.enabled = NO;
            self.pullup0.enabled = YES;
            [Konashi pinMode:PIO0 mode:INPUT];
        }
    }
    else if(pin==self.pin1){
        if(pin.on){
            self.out1.enabled = YES;
            self.pullup1.enabled = NO;
            [Konashi pinMode:PIO1 mode:OUTPUT];
        } else {
            self.out1.enabled = NO;
            self.pullup1.enabled = YES;
            [Konashi pinMode:PIO1 mode:INPUT];
        }
    }
    else if(pin==self.pin2){
        if(pin.on){
            self.out2.enabled = YES;
            self.pullup2.enabled = NO;
            [Konashi pinMode:PIO2 mode:OUTPUT];
        } else {
            self.out2.enabled = NO;
            self.pullup2.enabled = YES;
            [Konashi pinMode:PIO2 mode:INPUT];
        }
    }
    else if(pin==self.pin3){
        if(pin.on){
            self.out3.enabled = YES;
            self.pullup3.enabled = NO;
            [Konashi pinMode:PIO3 mode:OUTPUT];
        } else {
            self.out3.enabled = NO;
            self.pullup3.enabled = YES;
            [Konashi pinMode:PIO3 mode:INPUT];
        }
    }
    else if(pin==self.pin4){
        if(pin.on){
            self.out4.enabled = YES;
            self.pullup4.enabled = NO;
            [Konashi pinMode:PIO4 mode:OUTPUT];
        } else {
            self.out4.enabled = NO;
            self.pullup4.enabled = YES;
            [Konashi pinMode:PIO4 mode:INPUT];
        }
    }
    else if(pin==self.pin5){
        if(pin.on){
            self.out5.enabled = YES;
            self.pullup5.enabled = NO;
            [Konashi pinMode:PIO5 mode:OUTPUT];
        } else {
            self.out5.enabled = NO;
            self.pullup5.enabled = YES;
            [Konashi pinMode:PIO5 mode:INPUT];
        }
    }
    else if(pin==self.pin6){
        if(pin.on){
            self.out6.enabled = YES;
            self.pullup6.enabled = NO;
            [Konashi pinMode:PIO6 mode:OUTPUT];
        } else {
            self.out6.enabled = NO;
            self.pullup6.enabled = YES;
            [Konashi pinMode:PIO6 mode:INPUT];
        }
    }
    else if(pin==self.pin7){
        if(pin.on){
            self.out7.enabled = YES;
            self.pullup7.enabled = NO;
            [Konashi pinMode:PIO7 mode:OUTPUT];
        } else {
            self.out7.enabled = NO;
            self.pullup7.enabled = YES;
            [Konashi pinMode:PIO7 mode:INPUT];
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
            [Konashi digitalWrite:PIO0 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO0 value:LOW];
        }
    }
    else if(pin==self.out1){
        if(pin.on){
            [Konashi digitalWrite:PIO1 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO1 value:LOW];
        }
    }
    else if(pin==self.out2){
        if(pin.on){
            [Konashi digitalWrite:PIO2 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO2 value:LOW];
        }
    }
    else if(pin==self.out3){
        if(pin.on){
            [Konashi digitalWrite:PIO3 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO3 value:LOW];
        }
    }
    else if(pin==self.out4){
        if(pin.on){
            [Konashi digitalWrite:PIO4 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO4 value:LOW];
        }
    }
    else if(pin==self.out5){
        if(pin.on){
            [Konashi digitalWrite:PIO5 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO5 value:LOW];
        }
    }
    else if(pin==self.out6){
        if(pin.on){
            [Konashi digitalWrite:PIO6 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO6 value:LOW];
        }
    }
    else if(pin==self.out7){
        if(pin.on){
            [Konashi digitalWrite:PIO7 value:HIGH];
        } else {
            [Konashi digitalWrite:PIO7 value:LOW];
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
            [Konashi pinPullup:PIO0 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO0 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:PIO1 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO1 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup1){
        if(pin.on){
            [Konashi pinPullup:PIO1 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO1 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup2){
        if(pin.on){
            [Konashi pinPullup:PIO2 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO2 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup3){
        if(pin.on){
            [Konashi pinPullup:PIO3 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO3 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup4){
        if(pin.on){
            [Konashi pinPullup:PIO4 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO4 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup5){
        if(pin.on){
            [Konashi pinPullup:PIO5 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO5 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup6){
        if(pin.on){
            [Konashi pinPullup:PIO6 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO6 mode:NO_PULLS];
        }
    }
    else if(pin==self.pullup7){
        if(pin.on){
            [Konashi pinPullup:PIO7 mode:PULLUP];
        } else {
            [Konashi pinPullup:PIO7 mode:NO_PULLS];
        }
    }
}


/////////////////////////////////////
// 入力の変化

- (void)updatePioInput
{
    self.in0.on = [Konashi digitalRead:PIO0];
    self.in1.on = [Konashi digitalRead:PIO1];
    self.in2.on = [Konashi digitalRead:PIO2];
    self.in3.on = [Konashi digitalRead:PIO3];
    self.in4.on = [Konashi digitalRead:PIO4];
    self.in5.on = [Konashi digitalRead:PIO5];
    self.in6.on = [Konashi digitalRead:PIO6];
    self.in7.on = [Konashi digitalRead:PIO7];
}

@end
