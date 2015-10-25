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

@property (nonatomic, assign) KonashiSPIMode spiMode;
@property (nonatomic, assign) KonashiSPISpeed spiSpeed;
@property (nonatomic, assign) KonashiSPIBitOrder spiBitOrder;
@property (nonatomic, readonly) NSData *spiReadData;

+ (CBUUID *)upgradeServiceUUID;
+ (CBUUID *)upgradeCharacteristicControlPointUUID;
+ (CBUUID *)upgradeCharacteristicDataUUID;
+ (CBUUID *)spiDataUUID;
+ (CBUUID *)spiNotificationUUID;
+ (CBUUID *)spiConfigUUID;

- (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder;
- (KonashiResult)spiWrite:(NSData *)data;
- (KonashiResult)spiReadRequest;
- (void)enableSPINotification;

@end
