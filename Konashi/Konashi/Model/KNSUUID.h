//
//  KNSUUID.h
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct __KNSUUID {
	UInt16 uuid16;
	char uuid128[37];
} KNSUUID;

KNSUUID uuidWithUInt16(UInt16 uuid16);
KNSUUID uuidWithCharacter(char *uuid128);
