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

- (BOOL) kns_isEqualTo16BitUUID:(CBUUID *)UUID
{
	char b1[16];
	char b2[16];
	[self.data getBytes:b1];
	[UUID.data getBytes:b2];
	if (memcmp(b1, b2, self.data.length) == 0)return YES;
	else return NO;
}

- (UInt16)kns_toUInt16
{
	char b1[16];
	[self.data getBytes:b1];
	return ((b1[0] << 8) | b1[1]);
}

- (NSString *)kns_stringValue
{
    return [self.data description];
}

@end
