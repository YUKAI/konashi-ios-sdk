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

static KonashiACMode ACDriveMode;

+ (KonashiResult)initACDrive:(KonashiACMode)mode freq:(int)freq
{
    ACDriveMode=mode;
    if(mode==KonashiACModeOnOff){
        [Konashi selectACDriveFreq:freq];
        [Konashi pinMode:KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        return [Konashi pinMode:KONASHI_AC_PIN_CTRL mode:KonashiPinModeOutput];
    } else if(mode==KonashiACModePWM) {
        [Konashi selectACDriveFreq:freq];
        [Konashi pinMode:KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        [Konashi pwmMode:KONASHI_AC_PIN_CTRL mode:KonashiPWMModeEnable];
        return [Konashi pwmPeriod:KONASHI_AC_PIN_CTRL period:KONASHI_PWM_AC_PERIOD];
    } else {
        return KonashiResultFailure;
    }
}

+ (KonashiResult)onACDrive
{
    if(ACDriveMode==0){
        return [Konashi digitalWrite:KONASHI_AC_PIN_CTRL value:KonashiLevelHigh];
    } else {
        return KonashiResultFailure;
    }
}

+ (KonashiResult)offACDrive
{
    if(ACDriveMode==0){
        return [Konashi digitalWrite:KONASHI_AC_PIN_CTRL value:KonashiLevelLow];
    } else {
        return KonashiResultFailure;
    }
}

+ (KonashiResult)updateACDriveDuty:(float)ratio
{
    if(ACDriveMode==1){
        int duty;
        if(ratio < 0.0){
            ratio = 0.0;
        }
        if(ratio > 100.0){
            ratio = 100.0;
        }
        duty = (int)(KONASHI_PWM_AC_PERIOD * ratio / 100);
        return [Konashi pwmDuty:KONASHI_AC_PIN_CTRL duty:duty];
    } else {
        return KonashiResultFailure;
    }
}

+ (KonashiResult)selectACDriveFreq:(int)freq
{
    if(freq==KONASHI_AC_FREQ_50HZ) {
        return [Konashi digitalWrite:KONASHI_AC_PIN_FREQ value:KonashiLevelLow];
    } else if(freq==KONASHI_AC_FREQ_60HZ) {
        return [Konashi digitalWrite:KONASHI_AC_PIN_FREQ value:KonashiLevelHigh];
    } else {
        return KonashiResultFailure;
    }
}

@end
