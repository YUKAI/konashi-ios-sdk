//
//  CBPeripheral+Konashi.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "CBPeripheral+Konashi.h"
#import "KonashiUtils.h"
#import "KonashiConstant.h"
#import "CBUUID+Konashi.h"

@implementation CBPeripheral (Konashi)

- (CBService*) kns_findServiceFromUUID:(CBUUID *)UUID
{
	for (CBService *s in self.services) {
		if ([s.UUID kns_isEqualToUUID:UUID]) return s;
	}
    return nil;
}

- (void) kns_discoverAllServices
{
	[self discoverServices:nil]; // Discover all services without filter
}

- (void) kns_discoverAllCharacteristics
{
	if (NSFoundationVersionNumber_iOS_8_3 > floor(NSFoundationVersionNumber)) {
		// iOS9
		//DeviceInfo 180a
		CBService *s = [self.services objectAtIndex:0];
		KNS_LOG(@"Fetching characteristics for service with UUID : %@", [s.UUID kns_dataDescription]);
		[self discoverCharacteristics:nil forService:s];
		//Konashi Service ff00
		s = [self.services objectAtIndex:2];
		KNS_LOG(@"Fetching characteristics for service with UUID : %@", [s.UUID kns_dataDescription]);
		[self discoverCharacteristics:nil forService:s];
	}
	else {
		// iOS8 or earlier
		[self.services enumerateObjectsUsingBlock:^(CBService * _Nonnull s, NSUInteger idx, BOOL * _Nonnull stop) {
			KNS_LOG(@"Fetching characteristics for service with UUID : %@", [s.UUID kns_dataDescription]);
			[self discoverCharacteristics:nil forService:s];
		}];

	}
}

@end
