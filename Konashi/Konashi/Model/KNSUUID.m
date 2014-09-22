//
//  KNSUUID.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSUUID.h"

KNSUUID uuidWithUInt16(UInt16 uuid16)
{
	KNSUUID uuid = {uuid16};
	return uuid;
}

KNSUUID uuidWithCharacter(char *uuid128)
{
	KNSUUID uuid = {0, *uuid128};
	return uuid;
}

CBUUID *convetToCBUUID(KNSUUID uuid)
{
	NSString *uuidString = nil;
	if (uuid.uuid16) {
		uuidString = [NSString stringWithFormat:@"%d", uuid.uuid16];
	}
	else if (uuid.uuid128) {
		uuidString = [NSString stringWithUTF8String:uuid.uuid128];
	}
	
	return [CBUUID UUIDWithString:uuidString];
}
