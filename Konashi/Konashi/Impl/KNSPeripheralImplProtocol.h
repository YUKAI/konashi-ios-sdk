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

- (KonashiResult)writeValuePioSetting;
- (KonashiResult)writeValuePioPullup;
- (KonashiResult)writeValuePioOutput;

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinModeAll:(int)mode;
- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;
- (KonashiResult) pinPullupAll:(int)mode;
- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin;
- (int) digitalReadAll;
- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value;
- (KonashiResult) digitalWriteAll:(int)value;

- (KonashiResult) writeValuePwmSetting;
- (KonashiResult) writeValuePwmPeriod:(KonashiDigitalIOPin)pin;
- (KonashiResult) writeValuePwmDuty:(KonashiDigitalIOPin)pin;

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;
- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;
- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;
- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin;

- (int) analogReference;
- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
- (int) analogRead:(KonashiAnalogIOPin)pin;
- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;

- (KonashiResult) i2cMode:(KonashiI2CMode)mode;
- (KonashiResult) i2cSendCondition:(KonashiI2CCondition)condition;
- (KonashiResult) i2cStartCondition;
- (KonashiResult) i2cRestartCondition;
- (KonashiResult) i2cStopCondition;
- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;
- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data;

- (KonashiResult) uartMode:(KonashiUartMode)mode;
- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
- (KonashiResult) uartWrite:(unsigned char)data;
- (unsigned char) uartRead;

- (KonashiResult) reset;
- (KonashiResult) batteryLevelReadRequest;
- (int) batteryLevelRead;
- (KonashiResult) signalStrengthReadRequest;
- (int) signalStrengthRead;

- (void)enablePIOInputNotification;
- (void)enableUART_RXNotification;

@end