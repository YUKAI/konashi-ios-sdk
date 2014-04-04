/* ========================================================================
 * Konashi+Grove.h
 *
 * http://konashi.ux-xu.com
 * ========================================================================
 * Copyright 2013 Yukai Engineering Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================================== */


#import "Konashi.h"

/* Macros */

// Digital Port
#define D0 PIO0
#define D1 PIO1
#define D2 PIO2
#define D3 PIO3
#define D4 PIO4
#define D5 PIO5
#define D6 PIO6
#define D7 PIO7

// Analog Port
static const int A0 = KonashiAnalogIO0;
static const int A1 = KonashiAnalogIO1;
static const int A2 = KonashiAnalogIO2;

/* Functions */

@interface Konashi (Grove)

+ (int)readGroveDigitalPort:(int)port;
+ (int)writeGroveDigitalPort:(int)port value:(int)value;
+ (int)readGroveAnalogPort:(int)port;
+ (int)writeGroveAnalogPort:(int)port milliVolt:(int)milliVolt;

@end
