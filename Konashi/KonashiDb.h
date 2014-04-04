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

static const int KONASHI_BATT_SERVICE_UUID		= 0x180F;
static const int KONASHI_LEVEL_SERVICE_UUID		= 0x2A19;
static const int KONASHI_POWER_STATE_UUID		= 0x2A1B;
static const int KONASHI_LEVEL_SERVICE_READ_LEN	= 1;

/***************************
  KONASHI GATT DB
****************************/

static const int  KONASHI_SERVICE_UUID								= 0xFF00;
// PIO
static const int  KONASHI_PIO_SETTING_UUID							= 0x3000;
static const int  KONASHI_PIO_PULLUP_UUID							= 0x3001;
static const int  KONASHI_PIO_OUTPUT_UUID							= 0x3002;
static const int  KONASHI_PIO_INPUT_NOTIFICATION_UUID				= 0x3003;
static const int  KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN			= 1;

// PWM
static const int  KONASHI_PWM_CONFIG_UUID							= 0x3004;
static const int  KONASHI_PWM_PARAM_UUID								= 0x3005;
static const int  KONASHI_PWM_DUTY_UUID								= 0x3006;

// Analog
static const int  KONASHI_ANALOG_DRIVE_UUID							= 0x3007;
static const int  KONASHI_ANALOG_READ0_UUID							= 0x3008;
static const int  KONASHI_ANALOG_READ1_UUID							= 0x3009;
static const int  KONASHI_ANALOG_READ2_UUID							= 0x300A;
static const int KONASHI_ANALOG_READ_LEN								= 2;

// I2C
static const int  KONASHI_I2C_CONFIG_UUID							= 0x300B;
static const int KONASHI_I2C_START_STOP_UUID							= 0x300C;
static const int KONASHI_I2C_WRITE_UUID								= 0x300D;
static const int  KONASHI_I2C_READ_PARAM_UIUD						= 0x300E;
static const int  KONASHI_I2C_READ_UUID								= 0x300F;

// UART
static const int  KONASHI_UART_CONFIG_UUID							= 0x3010;
static const int  KONASHI_UART_BAUDRATE_UUID							= 0x3011;
static const int  KONASHI_UART_TX_UUID								= 0x3012;
static const int  KONASHI_UART_RX_NOTIFICATION_UUID					= 0x3013;
static const int  KONASHI_UART_RX_NOTIFICATION_READ_LEN				= 1;

// Hardware
static const int  KONASHI_HARDWARE_RESET_UUID						= 0x3014;
static const int  KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_UUID			= 0x3015;
static const int  KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_READ_LEN		= 1;


#endif  // KONASHI_DB

