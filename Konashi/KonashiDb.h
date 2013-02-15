//
//  KonashiDb.h
//
//  Copyright (c) 2012 YUKAI Engineering. All rights reserved.
//

#ifndef KONASHI_DB
#define KONASHI_DB

#define KONASHI_BATT_SERVICE_UUID                               0x180F
#define KONASHI_LEVEL_SERVICE_UUID                              0x2A19
#define KONASHI_POWER_STATE_UUID                                0x2A1B
#define KONASHI_LEVEL_SERVICE_READ_LEN                          1

/***************************
  KONASHI GATT DB
****************************/

#define KONASHI_SERVICE_UUID                                    0xFF00
// PIO
#define KONASHI_PIO_SETTING_UUID                                0x3000
#define KONASHI_PIO_PULLUP_UUID                                 0x3001
#define KONASHI_PIO_OUTPUT_UUID                                 0x3002
#define KONASHI_PIO_INPUT_NOTIFICATION_UUID                     0x3003
#define KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN                 1

// PWM
#define KONASHI_PWM_CONFIG_UUID                                 0x3004
#define KONASHI_PWM_PARAM_UUID                                  0x3005
#define KONASHI_PWM_DUTY_UUID                                   0x3006

// Analog
#define KONASHI_ANALOG_DRIVE_UUID                               0x3007
#define KONASHI_ANALOG_READ0_UUID                               0x3008
#define KONASHI_ANALOG_READ1_UUID                               0x3009
#define KONASHI_ANALOG_READ2_UUID                               0x300A
#define KONASHI_ANALOG_READ_LEN                                 2

// I2C
#define KONASHI_I2C_CONFIG_UUID                                 0x300B
#define KONASHI_I2C_START_STOP_UUID                             0x300C
#define KONASHI_I2C_WRITE_UUID                                  0x300D
#define KONASHI_I2C_READ_PARAM_UIUD                             0x300E
#define KONASHI_I2C_READ_UUID                                   0x300F

// UART
#define KONASHI_UART_CONFIG_UUID                                0x3010
#define KONASHI_UART_BAUDRATE_UUID                              0x3011
#define KONASHI_UART_TX_UUID                                    0x3012
#define KONASHI_UART_RX_NOTIFICATION_UUID                       0x3013
#define KONASHI_UART_RX_NOTIFICATION_READ_LEN                   1

// Hardware
#define KONASHI_HARDWARE_RESET_UUID                             0x3014
#define KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_UUID              0x3015
#define KONASHI_HARDWARE_LOW_BAT_NOTIFICATION_READ_LEN          1


#endif  // KONASHI_DB

