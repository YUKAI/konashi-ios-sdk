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

@property (nonatomic, copy) KonashiEventHandler connectedHandler;
@property (nonatomic, copy) KonashiEventHandler disconnectedHandler;
@property (nonatomic, copy) KonashiEventHandler readyHandler;
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalInputDidChangeValueHandler;
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalOutputDidChangeValueHandler;
@property (nonatomic, copy) KonashiAnalogPinDidChangeValueHandler analogPinDidChangeValueHandler;
@property (nonatomic, copy) KonashiUartRxCompleteHandler uartRxCompleteHandler;
@property (nonatomic, copy) KonashiI2CReadCompleteHandler i2cReadCompleteHandler;
@property (nonatomic, copy) KonashiBatteryLevelDidUpdateHandler batteryLevelDidUpdateHandler;
@property (nonatomic, copy) KonashiSignalStrengthDidUpdateHandler signalStrengthDidUpdateHandler;

@end
