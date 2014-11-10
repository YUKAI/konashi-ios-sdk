//
//  Konashi+JavaScriptCore.h
//  Konashi
//
//  Created by Akira Matsuda on 10/21/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "KonashiConstant.h"
@class Konashi;

@protocol KonashiJavaScriptBindings <JSExport>

+ (Konashi *) shared;
+ (KonashiResult) initialize;
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
JSExportAs(i2cWrite, + (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address);
JSExportAs(i2dReadRequest, + (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address);
JSExportAs(i2cRead, + (KonashiResult) i2cRead:(int)length data:(unsigned char*)data);

// UART methods
+ (KonashiResult) uartMode:(KonashiUartMode)mode;
+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
+ (KonashiResult) uartWrite:(unsigned char)data;
+ (unsigned char) uartRead;

// Konashi hardware methods
+ (KonashiResult) reset;
+ (KonashiResult) batteryLevelReadRequest;
+ (int) batteryLevelRead;
+ (KonashiResult) signalStrengthReadRequest;
+ (int) signalStrengthRead;

@end

@interface KNSJavaScriptVirtualMachine : NSObject

+ (JSValue *)evaluateScript:(NSString *)script;
+ (JSValue *)callFunctionWithKey:(NSString *)key args:(NSArray *)args;
+ (void)addBridgeHandlerWithTarget:(id)target selector:(SEL)selector;
+ (void)addBridgeHandlerWithKey:(NSString *)key hendler:(void (^)(JSValue* value))handler;
+ (void)setBridgeVariableWithKey:(NSString *)key variable:(id)obj;
+ (JSValue *)getBridgeVariableWithKey:(NSString *)key;

@end

@interface KNSWebView : UIView
{
	UIWebView *webView;
	KNSJavaScriptVirtualMachine *vm;
}

@end
