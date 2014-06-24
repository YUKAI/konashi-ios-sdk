/* ========================================================================
 * Konashi+ADC.m
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


#import "Konashi+ADC.h"

@implementation Konashi (ADC)

static uint8_t adcAddress;
static uint8_t powerMode;

- (KonashiResult)initADC:(uint8_t)address
{
    if (address < KONASHI_ADC_ADDR_00 || address > KONASHI_ADC_ADDR_11) {
        return KonashiResultFailed;
    }
    adcAddress = address;
	
    return [self setI2CMode:KonashiI2CModeEnable400K];
}

- (KonashiResult)readADCWithChannel:(uint8_t)channel
{
    if (channel > KONASHI_ADC_CH7 || adcAddress < KONASHI_ADC_ADDR_00 || adcAddress > KONASHI_ADC_ADDR_11) {
        return KonashiResultFailed;
    }
    uint8_t c = ((uint8_t)channel >> 1) | ((channel & 1) << 2);
    uint8_t data = KONASHI_ADC_SD | (c << 4) | (powerMode << 2);
    [self i2cStartCondition];
    [self i2cWrite:1 data:&data address:adcAddress];
    [self i2cRestartCondition];
	
    return [self i2cReadRequest:2 address:adcAddress];
}

- (KonashiResult)readDiffADCWithChannels:(uint8_t)channels
{
    if (channels > KONASHI_ADC_CH7_CH6 || adcAddress < KONASHI_ADC_ADDR_00 || adcAddress > KONASHI_ADC_ADDR_11) {
        return KonashiResultFailed;
    }
    uint8_t data = (channels << 4) | (powerMode << 2);
    [self i2cStartCondition];
    [self i2cWrite:1 data:&data address:adcAddress];
    [self i2cRestartCondition];
	
    return [self i2cReadRequest:2 address:adcAddress];
}

- (KonashiResult)selectPowerMode:(uint8_t)mode
{
    if (mode > KONASHI_ADC_REFON_ADCON || adcAddress < KONASHI_ADC_ADDR_00 || adcAddress > KONASHI_ADC_ADDR_11) {
        return KonashiResultFailed;
    }
    powerMode = mode;
    [self i2cStartCondition];
    [self i2cWrite:1 data:&powerMode address:adcAddress];
	
    return [self i2cStopCondition];
}

@end
