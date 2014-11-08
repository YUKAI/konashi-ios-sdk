//
//  Konashi+LegacyAPI.m
//  Konashi
//
//  Created by Akira Matsuda on 11/9/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi+LegacyAPI.h"

@implementation Konashi (LegacyAPI)

#pragma mark - digital

+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	return [[Konashi shared].activePeripheral digitalRead:pin];
}

+ (int) digitalReadAll
{
	return [[Konashi shared].activePeripheral digitalReadAll];
}

+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	return [[Konashi shared].activePeripheral digitalWrite:pin value:value];
}

+ (KonashiResult) digitalWriteAll:(int)value
{
	return [[Konashi shared].activePeripheral digitalWriteAll:value];
}

#pragma mark - analog

+ (int) analogRead:(KonashiAnalogIOPin)pin
{
	return [[Konashi shared].activePeripheral analogRead:pin];
}

#pragma mark - I2C

+ (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	return [[Konashi shared].activePeripheral i2cRead:length data:data];
}

#pragma mark - Uart

+ (unsigned char) uartRead
{
	return [[Konashi shared].activePeripheral uartRead];
}

#pragma mark - Hardware

+ (int) batteryLevelRead
{
	return [[Konashi shared].activePeripheral batteryLevelRead];
}

+ (int) signalStrengthRead
{
	return [[Konashi shared].activePeripheral signalStrengthRead];
}

@end
