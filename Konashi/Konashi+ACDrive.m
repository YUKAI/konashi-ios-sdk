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

+ (int)initACDrive:(int)mode freq:(int)freq
{
    ACDriveMode=mode;
    if(mode==0){
        [Konashi selectACDriveFreq:freq];
        [[Konashi sharedKonashi] pinMode:KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        return [[Konashi sharedKonashi] pinMode:KONASHI_AC_PIN_CTRL mode:KonashiPinModeOutput];
    } else if(mode==1) {
        [Konashi selectACDriveFreq:freq];
        [[Konashi sharedKonashi] pinMode:KONASHI_AC_PIN_FREQ mode:KonashiPinModeOutput];
        [[Konashi sharedKonashi] pwmMode:KONASHI_AC_PIN_CTRL mode:KonashiPwmModeEnable];
        return [[Konashi sharedKonashi] pwmPeriod:KONASHI_AC_PIN_CTRL period:KONASHI_PWM_AC_PERIOD];
    } else {
        return KonashiResultFailed;
    }
}

+ (int)onACDrive
{
    if(ACDriveMode==0){
        return [[Konashi sharedKonashi] digitalWrite:KONASHI_AC_PIN_CTRL value:KonashiLevelHigh];
    } else {
        return KonashiResultFailed;
    }
}

+ (int)offACDrive
{
    if(ACDriveMode==0){
        return [[Konashi sharedKonashi] digitalWrite:KONASHI_AC_PIN_CTRL value:KonashiLevelLow];
    } else {
        return KonashiResultFailed;
    }
}

+ (int)updateACDriveDuty:(float)ratio
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
        return [[Konashi sharedKonashi] pwmDuty:KONASHI_AC_PIN_CTRL duty:duty];
    } else {
        return KonashiResultFailed;
    }
}

+ (int)selectACDriveFreq:(int)freq
{
    if(freq==KONASHI_AC_FREQ_50HZ) {
        return [[Konashi sharedKonashi] digitalWrite:KONASHI_AC_PIN_FREQ value:KonashiLevelLow];
    } else if(freq==KONASHI_AC_FREQ_60HZ) {
        return [[Konashi sharedKonashi] digitalWrite:KONASHI_AC_PIN_FREQ value:KonashiLevelHigh];
    } else {
        return KonashiResultFailed;
    }
}

@end
