//
//  KoshianPeripheralImpl.h
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNSPeripheral.h"
#import "KNSPeripheralBaseImpl.h"

@interface KNSKoshianPeripheralImpl : KNSPeripheralBaseImpl <KNSPeripheralImplProtocol>

+ (CBUUID *)upgradeServiceUUID;
+ (CBUUID *)upgradeCharacteristicControlPointUUID;
+ (CBUUID *)upgradeCharacteristicDataUUID;

@end
