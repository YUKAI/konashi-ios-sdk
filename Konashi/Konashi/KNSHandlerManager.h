//
//  KNSHandlerManager.h
//  Konashi
//
//  Created by Akira Matsuda on 11/10/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KonashiConstant.h"

@interface KNSHandlerManager : NSObject

@property (nonatomic, copy) void (^connectedHandler)();
@property (nonatomic, copy) void (^disconnectedHandler)();
@property (nonatomic, copy) void (^readyHandler)();
@property (nonatomic, copy) void (^digitalInputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);
@property (nonatomic, copy) void (^digitalOutputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);
@property (nonatomic, copy) void (^analogPinDidChangeValueHandler)(KonashiAnalogIOPin pin, int value);
@property (nonatomic, copy) void (^uartRxCompleteHandler)(NSData *data);
@property (nonatomic, copy) void (^i2cReadCompleteHandler)(NSData *data);
@property (nonatomic, copy) void (^batteryLevelDidUpdateHandler)(int value);
@property (nonatomic, copy) void (^signalStrengthDidUpdateHandler)(int value);
@property (nonatomic, copy) void (^spiWriteCompleteHandler)();
@property (nonatomic, copy) void (^spiReadCompleteHandler)(NSData *data);

@end
