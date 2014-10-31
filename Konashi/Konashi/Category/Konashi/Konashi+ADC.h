/* ========================================================================
 * Konashi+ADC.h
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

#define KONASHI_ADC_CH0 0
#define KONASHI_ADC_CH1 1
#define KONASHI_ADC_CH2 2
#define KONASHI_ADC_CH3 3
#define KONASHI_ADC_CH4 4
#define KONASHI_ADC_CH5 5
#define KONASHI_ADC_CH6 6
#define KONASHI_ADC_CH7 7

#define KONASHI_ADC_CH0_CH1 0   // +CH0 -CH1
#define KONASHI_ADC_CH2_CH3 1   // +CH2 -CH3
#define KONASHI_ADC_CH4_CH5 2   // +CH4 -CH5
#define KONASHI_ADC_CH6_CH7 3   // +CH6 -CH7
#define KONASHI_ADC_CH1_CH0 4   // +CH1 -CH0
#define KONASHI_ADC_CH3_CH2 5   // +CH3 -CH2
#define KONASHI_ADC_CH5_CH4 6   // +CH5 -CH4
#define KONASHI_ADC_CH7_CH6 7   // +CH7 -CH6

#define KONASHI_ADC_ADDR_00 0x48
#define KONASHI_ADC_ADDR_01 0x49
#define KONASHI_ADC_ADDR_10 0x4A
#define KONASHI_ADC_ADDR_11 0x4B

#define KONASHI_ADC_SD 0x80

#define KONASHI_ADC_REFOFF_ADCOFF 0
#define KONASHI_ADC_REFOFF_ADCON 1
#define KONASHI_ADC_REFON_ADCOFF 2
#define KONASHI_ADC_REFON_ADCON 3

@interface Konashi (ADC)

+ (KonashiResult)initADC:(uint8_t)address;
+ (KonashiResult)readADCWithChannel:(uint8_t)channel;
+ (KonashiResult)readDiffADCWithChannels:(uint8_t)channels;
+ (KonashiResult)selectPowerMode:(uint8_t)mode;

@end
