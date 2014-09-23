//
//  CBUUID+Konashi.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "CBUUID+Konashi.h"

@implementation CBUUID (Konashi)

+ (CBUUID*) kns_UUIDWithUInt16:(UInt16)uuid
{
	char t[16];
	t[0] = ((uuid >> 8) & 0xff); t[1] = (uuid & 0xff);
	NSData *data = [[NSData alloc] initWithBytes:t length:16];
	return [CBUUID UUIDWithData:data];
}

- (BOOL)kns_isEqualToUUID:(CBUUID *)UUID
{
    return [self.data isEqualToData:UUID.data];
}

- (UInt16)kns_toUInt16
{
	char b1[16];
	[self.data getBytes:b1];
	return ((b1[0] << 8) | b1[1]);
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
