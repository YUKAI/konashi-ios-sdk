//
//  CBService+Konashi.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "CBService+Konashi.h"
#import "CBUUID+Konashi.h"

@implementation CBService (Konashi)

- (CBCharacteristic *) kns_findCharacteristicFromUUID:(CBUUID *)UUID
{
	for (CBCharacteristic *c in self.characteristics) {
		if ([c.UUID kns_isEqualToUUID:UUID]) return c;
	}
    return nil;
}

@end
