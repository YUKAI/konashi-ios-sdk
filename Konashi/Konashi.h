/* ========================================================================
 * Konashi.h
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


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@class Konashi;

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
typedef NS_ENUM(int, KonashiLevel) {
	KonashiLevelLow	 = 0,
	KonashiLevelHigh,
};
typedef NS_ENUM(int, KonashiPinMode) {
	KonashiPinModeInput	= 0,
	KonashiPinModeOutput,
	KonashiPinModeNoPulls = 0,
	KonashiPinModePullup
};
typedef NS_ENUM(int, KonashiResultState) {
	KonashiResultStateSuccess = 0,
	KonashiResultStateFailure = -1
};

// Konashi I/0 pin
typedef NS_OPTIONS(int, KonashiPinMask) {
	KonashiPinMask0 = 0,
	KonashiPinMask1 = 1 << 0,
	KonashiPinMask2 = 1 << 1,
	KonashiPinMask3 = 1 << 2,
	KonashiPinMask4 = 1 << 3,
	KonashiPinMask5 = 1 << 4,
	KonashiPinMask6 = 1 << 5,
	KonashiPinMask7 = 1 << 6,
};

typedef NS_ENUM(int, KonashiDigitalIOPin) {
	KonashiDigitalIO0 = 0,
	KonashiDigitalIO1,
	KonashiDigitalIO2,
	KonashiDigitalIO3,
	KonashiDigitalIO4,
	KonashiDigitalIO5,
	KonashiDigitalIO6,
	KonashiDigitalIO7
};

typedef NS_ENUM(int, KonashiOnboardIO) {
	KonashiS1 = KonashiDigitalIO0,
	KonashiLED2 = KonashiDigitalIO1,
	KonashiLED3 = KonashiDigitalIO2,
	KonashiLED4 = KonashiDigitalIO3,
	KonashiLED5 = KonashiDigitalIO4
};

typedef NS_ENUM(int, KonashiAnalogIOPin) {
	KonashiAnalogIO0 = 0,
	KonashiAnalogIO1,
	KonashiAnalogIO2
};

typedef NS_ENUM(int, KonashiI2CPin) {
	KonashiI2C_SDA = 6,
	KonashiI2C_SCL = 7
};

// Konashi PWM
typedef NS_ENUM(int, KonashiPwmMode) {
	KonashiPwmModeDisable = 0,
	KonashiPwmModeEnable,
	KonashiPwmModeEnableLED
};
static const unsigned int KonashiLEDPeriod = 10000;

// Konashi analog I/O
static const int KonashiAnalogReference = 1300;

// Konashi UART baudrate
typedef NS_ENUM(int, KonashiUartRate) {
	KonashiUartRate2K4 = 0x000a,
	KonashiUartRate9K6 = 0x0028
};

// Konashi I2C
static const int KonashiI2CDataMaxLength = 18;
typedef NS_ENUM(int, KonashiI2CMode) {
	KonashiI2CModeDisable,
	KonashiI2CModeEnable,
	KonashiI2CModeEnable100K = 1,
	KonashiI2CModeEnable400K
};
typedef NS_ENUM(int, KonashiI2CCondition) {
	KonashiI2CConditionStop,
	KonashiI2CConditionStart,
	KonashiI2CConditionRestart
};

// Konashi UART
static const int KonashiUartDataMaxLength = 19;
typedef NS_ENUM(int, KonashiUartMode) {
	KonashiUartModeDisable,
	KonashiUartModeEnable
};

typedef void(^KonashiEventHandler)(Konashi *konashi);
typedef void(^KonashiEventHandler1)(Konashi *konashi, int value);
typedef void(^KonashiEventHandler2)(Konashi *konashi, unsigned char value);
typedef void(^KonashiEventHandler3)(Konashi *konashi, unsigned char *value);
typedef void(^KonashiDigitalPinDidChangeValueHandler)(Konashi *konashi, KonashiDigitalIOPin pin, int value);
typedef void(^KonashiAnalogPinDidChangeValueHandler)(Konashi *konashi, KonashiAnalogIOPin pin, int value);
typedef KonashiEventHandler2 KonashiUartRxCompleteHandler;
typedef KonashiEventHandler3 KonashiI2CReadCompleteHandler;
typedef KonashiEventHandler1 KonashiBatteryLevelDidUpdateHandler;
typedef KonashiEventHandler1 KonashiSignalStrengthDidUpdateHandler;

// Konashi Events
static NSString *const KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON = @"KonashiEventCentralManagerPoweredOn";

static NSString *const KONASHI_EVENT_PERIPHERAL_FOUND = @"KonashiEventPeripheralFound";
static NSString *const KONASHI_EVENT_PERIPHERAL_NOT_FOUND = @"KonashiEventPeripheralNotFound";
static NSString *const KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE = @"KonashiEventNoPeripheralsAvailable";
static NSString *const KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED = @"KonashiEventPeripheralSelectorDismissed";

static NSString *const KONASHI_EVENT_CONNECTED = @"KonashiEventConnected";
static NSString *const KONASHI_EVENT_DISCONNECTED = @"KonashiEventDisconnected";
static NSString *const KONASHI_EVENT_READY = @"KonashiEventReady";

static NSString *const KONASHI_EVENT_UPDATE_PIO_INPUT = @"KonashiEventUpdatePioInput";

static NSString *const KONASHI_EVENT_UPDATE_ANALOG_VALUE = @"KonashiEventUpdateAnalogValue";
static NSString *const KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0 = @"KonashiEventUpdateAnalogValueAio0";
static NSString *const KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1 = @"KonashiEventUpdateAnalogValueAio1";
static NSString *const KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2 = @"KonashiEventUpdateAnalogValueAio2";

static NSString *const KONASHI_EVENT_I2C_READ_COMPLETE = @"KonashiEventI2CReadComplete";

static NSString *const KONASHI_EVENT_UART_RX_COMPLETE = @"KonashiEventUartRxComplete";

static NSString *const KONASHI_EVENT_UPDATE_BATTERY_LEVEL = @"KonashiEventUpdateBatteryLevel";
static NSString *const KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH = @"KonashiEventUpdateSignalStrength";

static const NSTimeInterval KonashiFindTimeoutInterval = 2.0;

// Konashi interface
@interface Konashi : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
    UIActionSheet *pickerViewPopup;
    UIPopoverController *pickerViewPopup_pad;
    UIPickerView *picker;

    // status
    BOOL isCallFind;
    NSString *findName;
    BOOL isReady;

    // Digital PIO
    unsigned char pioSetting;
    unsigned char pioPullup;
    unsigned char pioOutput;
    unsigned char pioInput;
	unsigned char piobyte[32];
    
    // PWM
    unsigned char pwmSetting;
    unsigned int pwmDuty[8];
    unsigned int pwmPeriod[8];
    
    // Analog IO
    unsigned int analogValue[3];
    
    // I2C
    unsigned char i2cSetting;
    unsigned char i2cReadData[KonashiI2CDataMaxLength];
    unsigned char i2cReadDataLength;
    unsigned char i2cReadAddress;
    
    // UART
    unsigned char uartSetting;
    unsigned char uartBaudrate;
    unsigned char uartRxData;
    
    // Hardware
    int batteryLevel;
    int rssi;
    
    // BLE
    NSMutableArray *peripherals;
    CBCentralManager *cm;
    CBPeripheral *activePeripheral;
}

@property (nonatomic, copy) KonashiEventHandler connectedHander;
@property (nonatomic, copy) KonashiEventHandler disconnectedHander;
@property (nonatomic, copy) KonashiEventHandler readyHander;
@property (nonatomic, copy) KonashiEventHandler centralManagerPoweredOnHandler;
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalInputDidChangeValueHandler;
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalOutputDidChangeValueHandler;
@property (nonatomic, copy) KonashiAnalogPinDidChangeValueHandler analogPinDidChangeValueHandler;
@property (nonatomic, copy) KonashiUartRxCompleteHandler uartRxCompleteHandler;
@property (nonatomic, copy) KonashiI2CReadCompleteHandler i2cReadCompleteHandler;
@property (nonatomic, copy) KonashiBatteryLevelDidUpdateHandler batteryLevelDidUpdateHandler;
@property (nonatomic, copy) KonashiSignalStrengthDidUpdateHandler signalStrengthDidUpdateHandler;

// Singleton
+ (Konashi *) shared;

// Konashi control methods
+ (KonashiResultState) initWithConnectedHandler:(KonashiEventHandler)connectedHandler disconnectedHandler:(KonashiEventHandler)disconnectedHander readyHandler:(KonashiEventHandler)readyHandler;
+ (KonashiResultState) initialize;
+ (int) find;
+ (int) findWithName:(NSString*)name;
+ (int) disconnect;
+ (BOOL) isConnected;
+ (BOOL) isReady;
+ (NSString *)peripheralName;

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
