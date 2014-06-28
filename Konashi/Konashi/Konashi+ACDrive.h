/* ========================================================================
 * Konashi+ACDrive.h
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

typedef NS_ENUM(NSUInteger, KONASHI_AC_PIN) {
    KONASHI_AC_PIN_CTRL = KonashiDigitalIO0,
	KONASHI_AC_PIN_FREQ = KonashiDigitalIO1,
};

typedef NS_ENUM(NSUInteger, KONASHI_AC_MODE) {
    KONASHI_AC_MODE_ONOFF = 0,
	KONASHI_AC_MODE_PWM
};

static const int KONASHI_PWM_AC_PERIOD = 10000;

typedef NS_ENUM(NSUInteger, KONASHI_AC_FREQ) {
	KONASHI_AC_FREQ_50HZ = 50,
	KONASHI_AC_FREQ_60HZ = 60,
};

@interface Konashi (ACDrive)

- (KonashiResult)setACDriveMode:(KONASHI_AC_MODE)mode freq:(KONASHI_AC_FREQ)freq;
- (KonashiResult)onACDrive;
- (KonashiResult)offACDrive;
- (KonashiResult)updateACDriveDuty:(float)ratio;
- (KonashiResult)selectACDriveFreq:(int)freq;

@end
