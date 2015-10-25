//
//  KonashiJavaScriptBindingsProtocol.h
//  Konashi
//
//  Created by Akira Matsuda on 11/12/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#ifndef Konashi_KonashiJavaScriptBindingsProtocol_h
#define Konashi_KonashiJavaScriptBindingsProtocol_h

#import "Konashi.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol KonashiJavaScriptBindings <JSExport>

+ (KonashiResult) find;
+ (KonashiResult) findWithName:(NSString*)name;
+ (KonashiResult) disconnect;
+ (BOOL) isConnected;
+ (BOOL) isReady;
+ (NSString *)peripheralName;

// Digital PIO methods
JSExportAs(pinMode, + (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode);
+ (KonashiResult) pinModeAll:(KonashiPinMode)mode;
JSExportAs(pinPullup, + (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode);
+ (KonashiResult) pinPullupAll:(KonashiPinMode)mode;
+ (KonashiResult) digitalRead:(KonashiDigitalIOPin)pin;
+ (int) digitalReadAll;
JSExportAs(digitalWrite, + (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value);
+ (KonashiResult) digitalWriteAll:(KonashiLevel)value;

// PWM methods
JSExportAs(pwmMode, + (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode);
JSExportAs(pwmPeriod, + (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period);
JSExportAs(pwmDuty, + (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty);
JSExportAs(pwmLedDrive, + (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio);

// Analog IO methods
+ (int) analogReference;
+ (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
+ (int) analogRead:(KonashiAnalogIOPin)pin;
JSExportAs(analogWrite, + (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt);

// I2C methods
+ (KonashiResult) i2cMode:(KonashiI2CMode)mode;
+ (KonashiResult) i2cStartCondition;
+ (KonashiResult) i2cRestartCondition;
+ (KonashiResult) i2cStopCondition;
JSExportAs(i2cReadRequest, + (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address);
JSExportAs(i2cWriteString, + (KonashiResult) i2cWriteString:(NSString *)data address:(unsigned char)address);
+ (NSData *)i2cReadData;

// UART methods
+ (KonashiResult) uartMode:(KonashiUartMode)mode;
+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
+ (KonashiResult) uartWriteString:(NSString *)string;
+ (NSData *) readUartData;

// Konashi hardware methods
+ (KonashiResult) reset;
+ (KonashiResult) batteryLevelReadRequest;
+ (int) batteryLevelRead;
+ (KonashiResult) signalStrengthReadRequest;
+ (int) signalStrengthRead;

// Konashi SPI methods
JSExportAs(spiMode, + (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder);
+ (KonashiResult)spiWrite:(NSData *)data;
+ (KonashiResult)spiReadRequest;
+ (NSData *)spiReadData;

@end

#endif
