//
//  KNSPeripheralImplProtocol.h
//  Konashi
//
//  Created by Akira Matsuda on 9/20/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@protocol KNSPeripheralImplProtocol <NSObject>

@required
- (CBPeripheralState)state;
- (BOOL)isReady;
- (NSString *)findName;

- (int)writeValuePioSetting;
- (int)writeValuePioPullup;
- (int)writeValuePioOutput;

- (int) pinMode:(int)pin mode:(int)mode;
- (int) pinModeAll:(int)mode;
- (int) pinPullup:(int)pin mode:(int)mode;
- (int) pinPullupAll:(int)mode;
- (int) digitalRead:(int)pin;
- (int) digitalReadAll;
- (int) digitalWrite:(int)pin value:(int)value;
- (int) digitalWriteAll:(int)value;

- (int) writeValuePwmSetting;
- (int) writeValuePwmPeriod:(int)pin;
- (int) writeValuePwmDuty:(int)pin;

- (int) pwmMode:(int)pin mode:(int)mode;
- (int) pwmPeriod:(int)pin period:(unsigned int)period;
- (int) pwmDuty:(int)pin duty:(unsigned int)duty;
- (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio;

- (int) readValueAio:(int)pin;

- (int) analogReference;
- (int) analogReadRequest:(int)pin;
- (int) analogRead:(int)pin;
- (int) analogWrite:(int)pin milliVolt:(int)milliVolt;

- (int) i2cMode:(int)mode;
- (int) i2cSendCondition:(int)condition;
- (int) i2cStartCondition;
- (int) i2cRestartCondition;
- (int) i2cStopCondition;
- (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
- (int) i2cReadRequest:(int)length address:(unsigned char)address;
- (int) i2cRead:(int)length data:(unsigned char*)data;

- (int) uartMode:(int)mode;
- (int) uartBaudrate:(int)baudrate;
- (int) uartWrite:(unsigned char)data;
- (unsigned char) uartRead;

- (int) reset;
- (int) batteryLevelReadRequest;
- (int) batteryLevelRead;
- (int) signalStrengthReadRequest;
- (int) signalStrengthRead;

- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;

@end