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

#import "KNSUUID.h"

#define KONASHI_LEVEL_SERVICE_READ_LEN                          1
#define KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN                 1
#define KONASHI_ANALOG_READ_LEN                                 2
#define KONASHI_UART_RX_NOTIFICATION_READ_LEN                   1
#define KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_READ_LEN          1

KNSUUID KONASHI_BATT_SERVICE_UUID = {0x180F};
KNSUUID KONASHI_LEVEL_SERVICE_UUID = {0x2A19};
KNSUUID KONASHI_POWER_STATE_UUID = {0x2A1B};

/***************************
  KONASHI GATT DB
****************************/

KNSUUID KONASHI_SERVICE_UUID = {0xFF00};
// PIO
KNSUUID KONASHI_PIO_SETTING_UUID = {0x3000};
KNSUUID KONASHI_PIO_PULLUP_UUID = {0x3001};
KNSUUID KONASHI_PIO_OUTPUT_UUID = {0x3002};
KNSUUID KONASHI_PIO_INPUT_NOTIFICATION_UUID = {0x3003};

// PWM
KNSUUID KONASHI_PWM_CONFIG_UUID = {0x3004};
KNSUUID KONASHI_PWM_PARAM_UUID = {0x3005};
KNSUUID KONASHI_PWM_DUTY_UUID = {0x3006};

// Analog
KNSUUID KONASHI_ANALOG_DRIVE_UUID = {0x3007};
KNSUUID KONASHI_ANALOG_READ0_UUID = {0x3008};
KNSUUID KONASHI_ANALOG_READ1_UUID = {0x3009};
KNSUUID KONASHI_ANALOG_READ2_UUID = {0x300A};

// I2C
KNSUUID KONASHI_I2C_CONFIG_UUID = {0x300B};
KNSUUID KONASHI_I2C_START_STOP_UUID = {0x300C};
KNSUUID KONASHI_I2C_WRITE_UUID = {0x300D};
KNSUUID KONASHI_I2C_READ_PARAM_UIUD = {0x300E};
KNSUUID KONASHI_I2C_READ_UUID = {0x300F};

// UART
KNSUUID KONASHI_UART_CONFIG_UUID = {0x3010};
KNSUUID KONASHI_UART_BAUDRATE_UUID = {0x3011};
KNSUUID KONASHI_UART_TX_UUID = {0x3012};
KNSUUID KONASHI_UART_RX_NOTIFICATION_UUID = {0x3013};

// Hardware
KNSUUID KONASHI_HARDWARE_RESET_UUID = {0x3014};
KNSUUID KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_UUID = {0x3015};


#endif  // KONASHI_DB

