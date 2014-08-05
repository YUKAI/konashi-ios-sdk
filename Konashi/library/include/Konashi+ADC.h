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

typedef NS_ENUM(NSUInteger, KONASHI_ADC_CH) {
    KONASHI_ADC_CH0 = 0,
	KONASHI_ADC_CH1,
	KONASHI_ADC_CH2,
	KONASHI_ADC_CH3,
	KONASHI_ADC_CH4,
	KONASHI_ADC_CH5,
	KONASHI_ADC_CH6,
	KONASHI_ADC_CH7
};

typedef NS_ENUM(NSUInteger, KONASHI_ADC_CH_CH) {
    KONASHI_ADC_CH0_CH1 = 0,
	KONASHI_ADC_CH2_CH3,
	KONASHI_ADC_CH4_CH5,
	KONASHI_ADC_CH6_CH7,
	KONASHI_ADC_CH1_CH0,
	KONASHI_ADC_CH3_CH2,
	KONASHI_ADC_CH5_CH4,
	KONASHI_ADC_CH7_CH6
};

typedef NS_ENUM(NSUInteger, KONASHI_ADC_ADDR) {
	KONASHI_ADC_ADDR_00 = 0x48,
	KONASHI_ADC_ADDR_01 = 0x49,
	KONASHI_ADC_ADDR_10 = 0x4A,
	KONASHI_ADC_ADDR_11 = 0x4B,
};

static const int KONASHI_ADC_SD = 0x80;

typedef NS_ENUM(NSUInteger, KONASHI_ADC_REF) {
	KONASHI_ADC_REFOFF_ADCOFF = 0,
	KONASHI_ADC_REFOFF_ADCON,
	KONASHI_ADC_REFON_ADCOFF,
	KONASHI_ADC_REFON_ADCON
};

@interface Konashi (ADC)

- (KonashiResult)initADC:(uint8_t)address;
- (KonashiResult)readADCWithChannel:(uint8_t)channel;
- (KonashiResult)readDiffADCWithChannels:(uint8_t)channels;
- (KonashiResult)selectPowerMode:(uint8_t)mode;

@end
