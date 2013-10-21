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
        [Konashi pinMode:KONASHI_AC_PIN_FREQ mode:OUTPUT];
        return [Konashi pinMode:KONASHI_AC_PIN_CTRL mode:OUTPUT];
    } else if(mode==1) {
        [Konashi selectACDriveFreq:freq];
        [Konashi pinMode:KONASHI_AC_PIN_FREQ mode:OUTPUT];
        [Konashi pwmMode:KONASHI_AC_PIN_CTRL mode:KONASHI_PWM_ENABLE];
        return [Konashi pwmPeriod:KONASHI_AC_PIN_CTRL period:KONASHI_PWM_AC_PERIOD];
    } else {
        return KONASHI_FAILURE;
    }
}

+ (int)onACDrive
{
    if(ACDriveMode==0){
        return [Konashi digitalWrite:KONASHI_AC_PIN_CTRL value:HIGH];
    } else {
        return KONASHI_FAILURE;
    }
}

+ (int)offACDrive
{
    if(ACDriveMode==0){
        return [Konashi digitalWrite:KONASHI_AC_PIN_CTRL value:LOW];
    } else {
        return KONASHI_FAILURE;
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
        return [Konashi pwmDuty:KONASHI_AC_PIN_CTRL duty:duty];
    } else {
        return KONASHI_FAILURE;
    }
}

+ (int)selectACDriveFreq:(int)freq
{
    if(freq==KONASHI_AC_FREQ_50HZ) {
        return [Konashi digitalWrite:KONASHI_AC_PIN_FREQ value:LOW];
    } else if(freq==KONASHI_AC_FREQ_60HZ) {
        return [Konashi digitalWrite:KONASHI_AC_PIN_FREQ value:HIGH];
    } else {
        return KONASHI_FAILURE;
    }
}

@end
