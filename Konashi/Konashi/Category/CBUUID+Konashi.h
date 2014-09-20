//
//  CBUUID+Konashi.h
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBUUID (Konashi)

+ (CBUUID*) kns_UUIDWithUInt16:(UInt16)uuid;
- (BOOL)kns_isEqualTo16BitUUID:(CBUUID *)UUID;
- (UInt16)kns_toUInt16;
- (NSString *)kns_stringValue;

@end
