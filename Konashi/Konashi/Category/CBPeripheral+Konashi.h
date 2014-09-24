//
//  CBPeripheral+Konashi.h
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Konashi)

- (CBService*) kns_findServiceFromUUID:(CBUUID *)UUID;
- (void) kns_discoverAllServices;
- (void) kns_discoverAllCharacteristics;

@end
