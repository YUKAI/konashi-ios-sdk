//
//  Konashi+LegacyAPI.h
//  Konashi
//
//  Created by Akira Matsuda on 11/9/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi.h"

@interface Konashi (LegacyAPI)

+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin NS_DEPRECATED(NA, NA, 5_0, 8_0);
+ (int) digitalReadAll NS_DEPRECATED(NA, NA, 5_0, 8_0);
+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value NS_DEPRECATED(NA, NA, 5_0, 8_0);
+ (KonashiResult) digitalWriteAll:(int)value NS_DEPRECATED(NA, NA, 5_0, 8_0);

+ (int) analogRead:(KonashiAnalogIOPin)pin NS_DEPRECATED(NA, NA, 5_0, 8_0);

+ (KonashiResult) i2cRead:(int)length data:(unsigned char*)data NS_DEPRECATED(NA, NA, 5_0, 8_0);

+ (unsigned char) uartRead NS_DEPRECATED(NA, NA, 5_0, 8_0);

+ (int) batteryLevelRead NS_DEPRECATED(NA, NA, 5_0, 8_0);
+ (int) signalStrengthRead NS_DEPRECATED(NA, NA, 5_0, 8_0);

@end
