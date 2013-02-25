//
//  Konashi.h
//
//  Copyright (c) 2012 YUKAI Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


// Debug
#define KONASHI_DEBUGx

#ifdef KONASHI_DEBUG
#define KNS_LOG(...) NSLog(__VA_ARGS__)
#define KNS_LOG_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define KNS_LOG(...)
#define KNS_LOG_METHOD
#endif

// Konashi common
#define HIGH 1
#define LOW 0
#define OUTPUT 1
#define INPUT 0
#define PULLUP 1
#define NO_PULLS 0
#define ENABLE 1
#define DISABLE 0
#define TRUE 1
#define FALSE 0
#define KONASHI_SUCCESS 0
#define KONASHI_FAILURE -1

// Konashi I/0 pin
#define PIO0 0
#define PIO1 1
#define PIO2 2
#define PIO3 3
#define PIO4 4
#define PIO5 5
#define PIO6 6
#define PIO7 7

#define S1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED5 4

#define AIO0 0
#define AIO1 1
#define AIO2 2

#define I2C_SDA 6
#define I2C_SCL 7

// Konashi PWM
#define KONASHI_PWM_DISABLE 0
#define KONASHI_PWM_ENABLE 1
#define KONASHI_PWM_ENABLE_LED_MODE 2
#define KONASHI_PWM_LED_PERIOD 10000  // 10ms

// Konashi analog I/O
#define KONASHI_ANALOG_REFERENCE 1300 // 1300mV

// Konashi UART baudrate
#define KONASHI_UART_RATE_2K4 0x000a
#define KONASHI_UART_RATE_9K6 0x0028

// Konashi I2C
#define KONASHI_I2C_DATA_MAX_LENGTH 18
#define KONASHI_I2C_DISABLE 0
#define KONASHI_I2C_ENABLE 1
#define KONASHI_I2C_ENABLE_100K 1
#define KONASHI_I2C_ENABLE_400K 2
#define KONASHI_I2C_STOP_CONDITION 0
#define KONASHI_I2C_START_CONDITION 1
#define KONASHI_I2C_RESTART_CONDITION 2

// Konashi UART
#define KONASHI_UART_DATA_MAX_LENGTH 19
#define KONASHI_UART_DISABLE 0
#define KONASHI_UART_ENABLE 1

// Konashi Events
#define KONASHI_EVENT_CONNECTED @"KonashiEventConnected"
#define KONASHI_EVENT_DISCONNECTED @"KonashiEventDisconnected"
#define KONASHI_EVENT_READY @"KonashiEventReady"

#define KONASHI_EVENT_UPDATE_PIO_INPUT @"KonashiEventUpdatePioInput"

#define KONASHI_EVENT_UPDATE_ANALOG_VALUE @"KonashiEventUpdateAnalogValue"
#define KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0 @"KonashiEventUpdateAnalogValueAio0"
#define KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1 @"KonashiEventUpdateAnalogValueAio1"
#define KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2 @"KonashiEventUpdateAnalogValueAio2"

#define KONASHI_EVENT_I2C_READ_COMPLETE @"KonashiEventI2CReadComplete"

#define KONASHI_EVENT_UART_RX_COMPLETE @"KonashiEventUartRxComplete"

#define KONASHI_EVENT_UPDATE_BATTERY_LEVEL @"KonashiEventUpdateBatteryLevel"
#define KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH @"KonashiEventUpdateSignalStrength"


// Konashi interface
@interface Konashi : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
    UIActionSheet *pickerViewPopup;
    UIPopoverController *pickerViewPopup_pad;
    UIPickerView *picker;
    
    // Digital PIO
    unsigned char pioSetting;
    unsigned char pioPullup;
    unsigned char pioOutput;
    unsigned char pioInput;
    
    // PWM
    unsigned char pwmSetting;
    unsigned int pwmDuty[8];
    unsigned int pwmPeriod[8];
    
    // Analog IO
    unsigned int analogValue[3];
    
    // I2C
    unsigned char i2cSetting;
    unsigned char i2cReadData[KONASHI_I2C_DATA_MAX_LENGTH];
    unsigned char i2cReadDataLength;
    unsigned char i2cReadAddress;
    
    // UART
    unsigned char uartSetting;
    unsigned char uartBaudrate;
    unsigned char uartRxData;
    
    // Hardware
    int batteryLevel;
    int rssi;
    BOOL isReady;
    
    // BLE
    NSMutableArray *peripherals;
    CBCentralManager *cm;
    CBPeripheral *activePeripheral;
}


// Singleton
+ (Konashi *) shared;

// Konashi control methods
+ (int) initialize;
+ (int) find;
+ (int) findWithName:(NSString*)name;
+ (int) disconnect;
+ (BOOL) isConnected;
+ (BOOL) isReady;

// Digital PIO methods
+ (int) pinMode:(int)pin mode:(int)mode;
+ (int) pinModeAll:(int)mode;
+ (int) pinPullup:(int)pin mode:(int)mode;
+ (int) pinPullupAll:(int)mode;
+ (int) digitalRead:(int)pin;
+ (int) digitalReadAll;
+ (int) digitalWrite:(int)pin value:(int)value;
+ (int) digitalWriteAll:(int)value;

// PWM methods
+ (int) pwmMode:(int)pin mode:(int)mode;
+ (int) pwmPeriod:(int)pin period:(unsigned int)period;
+ (int) pwmDuty:(int)pin duty:(unsigned int)duty;
+ (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio;

// Analog IO methods
+ (int) analogReference;
+ (int) analogReadRequest:(int)pin;
+ (int) analogRead:(int)pin;
+ (int) analogWrite:(int)pin milliVolt:(int)milliVolt;

// I2C methods
+ (int) i2cMode:(int)mode;
+ (int) i2cStartCondition;
+ (int) i2cRestartCondition;
+ (int) i2cStopCondition;
+ (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
+ (int) i2cReadRequest:(int)length address:(unsigned char)address;
+ (int) i2cRead:(int)length data:(unsigned char*)data;

// UART methods
+ (int) uartMode:(int)mode;
+ (int) uartBaudrate:(int)baudrate;
+ (int) uartWrite:(unsigned char)data;
+ (unsigned char) uartRead;

// Konashi hardware methods
+ (int) reset;
+ (int) batteryLevelReadRequest;
+ (int) batteryLevelRead;
+ (int) signalStrengthReadRequest;
+ (int) signalStrengthRead;


// Konashi event methods
+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName;
+ (void) removeObserver:(id)notificationObserver;



@end
