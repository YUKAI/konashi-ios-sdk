//
//  CBService+Konashi.h
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (Konashi)

- (CBCharacteristic *) kns_findCharacteristicFromUUID:(CBUUID *)UUID;

@end
