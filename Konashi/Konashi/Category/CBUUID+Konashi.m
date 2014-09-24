//
//  CBUUID+Konashi.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "CBUUID+Konashi.h"

@implementation CBUUID (Konashi)

- (BOOL)kns_isEqualToUUID:(CBUUID *)UUID
{
    return [self.data isEqualToData:UUID.data];
}

- (NSString *)kns_dataDescription
{
    return [self.data description];
}

- (NSString *)kns_representativeString
{
	NSData *data = [self data];
	
	NSUInteger bytesToConvert = [data length];
	const unsigned char *uuidBytes = [data bytes];
	NSMutableString *outputString = [NSMutableString stringWithCapacity:16];
	
	for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
	{
		switch (currentByteIndex)
		{
			case 3:
			case 5:
			case 7:
			case 9:[outputString appendFormat:@"%02x-", uuidBytes[currentByteIndex]]; break;
			default:[outputString appendFormat:@"%02x", uuidBytes[currentByteIndex]];
		}
		
	}
	
	return outputString;
}

@end
