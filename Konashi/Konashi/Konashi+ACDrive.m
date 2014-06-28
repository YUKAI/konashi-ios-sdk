/* ========================================================================
 * Konashi+ACDrive.m
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


#import "Konashi+ACDrive.h"

@implementation Konashi (ACDrive)

static int ACDriveMode;

- (KonashiResult)setACDriveMode:(KONASHI_AC_MODE)mode freq:(KONASHI_AC_FREQ)freq
{
	KonashiResult result = KonashiResultFailed;
    ACDriveMode = mode;
    if (mode == 0) {
        [self selectACDriveFreq:freq];
        [self pinMode:(KonashiDigitalIOPin)KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        result = [self pinMode:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL mode:KonashiPinModeOutput];
    }
	else if (mode == 1) {
        [self selectACDriveFreq:freq];
        [self pinMode:(KonashiDigitalIOPin)KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        [self setPWMMode:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL mode:KonashiPWMModeEnable];
		result = [self setPWMPeriod:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL period:KONASHI_PWM_AC_PERIOD];
    }
	
	return result;
}

- (KonashiResult)onACDrive
{
	KonashiResult result = KonashiResultFailed;
    if (ACDriveMode == 0) {
        result = [self digitalWrite:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL value:KonashiLevelHigh];
    }
	
	return result;
}

- (KonashiResult)offACDrive
{
	KonashiResult result = KonashiResultFailed;
    if (ACDriveMode == 0) {
        result = [self digitalWrite:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL value:KonashiLevelLow];
    }
	
	return result;
}

- (KonashiResult)updateACDriveDuty:(float)ratio
{
	KonashiResult result = KonashiResultFailed;
    if(ACDriveMode == 1){
        int duty;
        if (ratio < 0.0) {
            ratio = 0.0;
        }
        if (ratio > 100.0) {
            ratio = 100.0;
        }
        duty = (int)(KONASHI_PWM_AC_PERIOD * ratio / 100);
        result = [self setPWMDuty:(KonashiDigitalIOPin)KONASHI_AC_PIN_CTRL duty:duty];
    }
	
	return result;
}

- (KonashiResult)selectACDriveFreq:(int)freq
{
	KonashiResult result = KonashiResultFailed;
    if (freq == KONASHI_AC_FREQ_50HZ) {
        result =  [self digitalWrite:(KonashiDigitalIOPin)KONASHI_AC_PIN_FREQ value:KonashiLevelLow];
    }
	else if (freq==KONASHI_AC_FREQ_60HZ) {
        result = [self digitalWrite:(KonashiDigitalIOPin)KONASHI_AC_PIN_FREQ value:KonashiLevelHigh];
    }
	
	return result;
}

@end
