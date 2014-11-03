//
//  KonashiConstant.h
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#ifndef Konashi_KonashiConstant_h
#define Konashi_KonashiConstant_h

// Debug
// Define in "Build Settings > Preprocessor Macros", not here
// #define KONASHI_DEBUG

#ifdef KONASHI_DEBUG
#define KNS_LOG(...) NSLog(__VA_ARGS__)
#define KNS_LOG_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define KNS_LOG(...)
#define KNS_LOG_METHOD
#endif

// Konashi Events
#define KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON @"KonashiEventCentralManagerPoweredOn"

#define KONASHI_EVENT_PERIPHERAL_FOUND @"KonashiEventPeripheralFound"
#define KONASHI_EVENT_PERIPHERAL_NOT_FOUND @"KonashiEventPeripheralNotFound"
#define KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE @"KonashiEventNoPeripheralsAvailable"
#define KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED @"KonashiEventPeripheralSelectorDismissed"

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

#define KONASHI_FIND_TIMEOUT 2

// Konashi common
typedef NS_ENUM(int, KonashiLevel) {
	KonashiLevelUnknown = -1,
	KonashiLevelLow	 = 0,
	KonashiLevelHigh = 1,
};
typedef NS_ENUM(int, KonashiPinMode) {
	KonashiPinModeInput	= 0,
	KonashiPinModeOutput = 1,
	KonashiPinModeNoPulls = 0,
	KonashiPinModePullup = 1
};
typedef NS_ENUM(int, KonashiResult) {
	KonashiResultSuccess = 0,
	KonashiResultFailure = -1
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
	KonashiDigitalIO1 = 1,
	KonashiDigitalIO2 = 2,
	KonashiDigitalIO3 = 3,
	KonashiDigitalIO4 = 4,
	KonashiDigitalIO5 = 5,
	KonashiDigitalIO6 = 6,
	KonashiDigitalIO7 = 7,
	KonashiS1 = KonashiDigitalIO0,
	KonashiLED2 = KonashiDigitalIO1,
	KonashiLED3 = KonashiDigitalIO2,
	KonashiLED4 = KonashiDigitalIO3,
	KonashiLED5 = KonashiDigitalIO4,
	KonashiI2C_SDA = 6,
	KonashiI2C_SCL = 7
};

typedef NS_ENUM(int, KonashiAnalogIOPin) {
	KonashiAnalogIO0 = 0,
	KonashiAnalogIO1 = 1,
	KonashiAnalogIO2 = 2
};

// Konashi PWM
typedef NS_ENUM(int, KonashiPWMMode) {
	KonashiPWMModeDisable = 0,
	KonashiPWMModeEnable = 1,
	KonashiPWMModeEnableLED = 2
};
static const unsigned int KonashiLEDPeriod = 10000;

// Konashi analog I/O
static const int KonashiAnalogReference = 1300;

// Konashi I2C
typedef NS_ENUM(int, KonashiI2CMode) {
	KonashiI2CModeDisable = 0,
	KonashiI2CModeEnable = 1,
	KonashiI2CModeEnable100K = 1,
	KonashiI2CModeEnable400K = 2
};
typedef NS_ENUM(int, KonashiI2CCondition) {
	KonashiI2CConditionStop = 0,
	KonashiI2CConditionStart = 1,
	KonashiI2CConditionRestart = 2
};

// Konashi UART
static const int KonashiUartDataMaxLength = 19;
typedef NS_ENUM(int, KonashiUartMode) {
	KonashiUartModeDisable = 0,
	KonashiUartModeEnable = 1
};

// Konashi UART baudrate
typedef NS_ENUM(int, KonashiUartBaudrate) {
	KonashiUartBaudrateRate2K4 = 0x000a,
	KonashiUartBaudrateRate9K6 = 0x0028
};

#endif
