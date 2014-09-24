/* ========================================================================
 * KonashiDb.h
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


#ifndef KONASHI_DB
#define KONASHI_DB

#define KONASHI_LEVEL_SERVICE_READ_LEN                          1
#define KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN                 1
#define KONASHI_ANALOG_READ_LEN                                 2
#define KONASHI_UART_RX_NOTIFICATION_READ_LEN                   1
#define KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_READ_LEN          1

#define KONASHI_BATT_SERVICE_UUID  [CBUUID UUIDWithString:@"180F"]
#define KONASHI_LEVEL_SERVICE_UUID [CBUUID UUIDWithString:@"2A19"]
#define KONASHI_POWER_STATE_UUID   [CBUUID UUIDWithString:@"2A1B"]

/***************************
  KONASHI GATT DB
****************************/

#define KONASHI_SERVICE_UUID [CBUUID UUIDWithString: @"FF00"]
// PIO
#define KONASHI_PIO_SETTING_UUID [CBUUID UUIDWithString: @"3000"]
#define KONASHI_PIO_PULLUP_UUID [CBUUID UUIDWithString: @"3001"]
#define KONASHI_PIO_OUTPUT_UUID [CBUUID UUIDWithString: @"3002"]
#define KONASHI_PIO_INPUT_NOTIFICATION_UUID [CBUUID UUIDWithString: @"3003"]

// PWM
#define KONASHI_PWM_CONFIG_UUID [CBUUID UUIDWithString: @"3004"]
#define KONASHI_PWM_PARAM_UUID [CBUUID UUIDWithString: @"3005"]
#define KONASHI_PWM_DUTY_UUID [CBUUID UUIDWithString: @"3006"]

// Analog
#define KONASHI_ANALOG_DRIVE_UUID [CBUUID UUIDWithString: @"3007"]
#define KONASHI_ANALOG_READ0_UUID [CBUUID UUIDWithString: @"3008"]
#define KONASHI_ANALOG_READ1_UUID [CBUUID UUIDWithString: @"3009"]
#define KONASHI_ANALOG_READ2_UUID [CBUUID UUIDWithString: @"300A"]

// I2C
#define KONASHI_I2C_CONFIG_UUID [CBUUID UUIDWithString: @"300B"]
#define KONASHI_I2C_START_STOP_UUID [CBUUID UUIDWithString: @"300C"]
#define KONASHI_I2C_WRITE_UUID [CBUUID UUIDWithString: @"300D"]
#define KONASHI_I2C_READ_PARAM_UIUD [CBUUID UUIDWithString: @"300E"]
#define KONASHI_I2C_READ_UUID [CBUUID UUIDWithString: @"300F"]

// UART
#define KONASHI_UART_CONFIG_UUID [CBUUID UUIDWithString: @"3010"]
#define KONASHI_UART_BAUDRATE_UUID [CBUUID UUIDWithString: @"3011"]
#define KONASHI_UART_TX_UUID [CBUUID UUIDWithString: @"3012"]
#define KONASHI_UART_RX_NOTIFICATION_UUID [CBUUID UUIDWithString: @"3013"]

// Hardware
#define KONASHI_HARDWARE_RESET_UUID [CBUUID UUIDWithString: @"3014"]
#define KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_UUID [CBUUID UUIDWithString: @"3015"]


#endif  // KONASHI_DB

