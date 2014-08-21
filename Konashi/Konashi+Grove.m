/* ========================================================================
 * Konashi+Grove.m
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


#import "Konashi+Grove.h"

@implementation Konashi (Grove)

- (KonashiResult)readGroveDigitalPort:(KonashiDigitalIOPin)port
{
    return [self digitalRead:port];
}

- (KonashiResult)writeGroveDigitalPort:(KonashiDigitalIOPin)port value:(KonashiLevel)value
{
    return [self digitalWrite:port value:value];
}

- (KonashiResult)readGroveAnalogPort:(KonashiAnalogIOPin)port
{
    return [self analogReadRequest:port];
}

- (KonashiResult)writeGroveAnalogPort:(KonashiAnalogIOPin)port milliVolt:(int)milliVolt
{
    return [self analogWrite:port milliVolt:milliVolt];
}

@end
