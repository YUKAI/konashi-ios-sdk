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
#define KONASHI_DEBUG

#ifdef KONASHI_DEBUG
#define KNS_LOG(__FORMAT__, ...) NSLog((@"%s line %d $ " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define KNS_LOG_METHOD NSLog(@"[Konashi]%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define KNS_LOG(...)
#define KNS_LOG_METHOD
#endif

// Konashi keys

static NSString *const KonashiPeripheralKey = @"KonashiPeripheralKey";
static NSString *const KonashiErrorKey = @"KonashiErrorKey";

// Konashi Events
static NSString *const KonashiEventCentralManagerPowerOnNotification = @"KonashiEventCentralManagerPoweredOn";

static NSString *const KonashiEventPeripheralFoundNotification = @"KonashiEventPeripheralFound";
static NSString *const KonashiEventPeripheralNotFoundNotification = @"KonashiEventPeripheralNotFound";
static NSString *const KonashiEventNoPeripheralsAvailableNotification = @"KonashiEventNoPeripheralsAvailable";
static NSString *const KonashiEventPeripheralSelectorDismissedNotification = @"KonashiEventPeripheralSelectorDismissed";
static NSString *const KonashiEventPeripheralSelectorDidSelectNotification = @"KonashiEventPeripheralSelectorDidSelectNotification";

static NSString *const KonashiEventStartDiscoveryNotification = @"KonashiEventStartDiscovery";
static NSString *const KonashiEventConnectingNotification = @"KonashiEventConnectingNotification";
static NSString *const KonashiEventDidFailToConnectNotification = @"KonashiEventDidFailToConnectNotification";
static NSString *const KonashiEventConnectedNotification = @"KonashiEventConnected";
static NSString *const KonashiEventDisconnectedNotification = @"KonashiEventDisconnected";
static NSString *const KonashiEventReadyToUseNotification = @"KonashiEventReady";
static NSString *const KonashiEventImplReadyToUseNotification = @"KonashiEventImplReadyToUseNotification";

static NSString *const KonashiEventDigitalIODidUpdateNotification = @"KonashiEventUpdatePioInput";

static NSString *const KonashiEventAnalogIODidUpdateNotification = @"KonashiEventUpdateAnalogValue";
static NSString *const KonashiEventAnalogIO0DidUpdateNotification = @"KonashiEventUpdateAnalogValueAio0";
static NSString *const KonashiEventAnalogIO1DidUpdateNotification = @"KonashiEventUpdateAnalogValueAio1";
static NSString *const KonashiEventAnalogIO2DidUpdateNotification = @"KonashiEventUpdateAnalogValueAio2";

static NSString *const KonashiEventI2CReadCompleteNotification = @"KonashiEventI2CReadComplete";

static NSString *const KonashiEventUartRxCompleteNotification = @"KonashiEventUartRxComplete";

static NSString *const KonashiEventBatteryLevelDidUpdateNotification = @"KonashiEventUpdateBatteryLevel";
static NSString *const KonashiEventSignalStrengthDidUpdateNotification = @"KonashiEventUpdateSignalStrength";

static NSString *const KonashiEventDidFindSoftwareRevisionStringNotification = @"KonashiEventDidFindSoftwareRevisionStringNotification";

static NSString *const KonashiEventSPIWriteCompleteNotification = @"KonashiEventSPIWriteCompleteNotification";
static NSString *const KonashiEventSPIReadCompleteNotification = @"KonashiEventSPIReadCompleteNotification";

static NSString *const KonashiLegacyRevisionString = @"T1.0.0";

static NSTimeInterval const KonashiFindTimeoutInterval = 2;

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
	KonashiUartBaudrateRate9K6 = 0x0028,
	KonashiUartBaudrateRate19K2 = 0x0050,
	KonashiUartBaudrateRate38K4 = 0x00a0,
	KonashiUartBaudrateRate57K6 = 0x00f0,
	KonashiUartBaudrateRate76K8 = 0x0140,
	KonashiUartBaudrateRate115K2 = 0x01e0
};

// Konashi SPI Speed
typedef NS_ENUM(int, KonashiSPISpeed) {
	KonashiSPISpeed200K = 20,
	KonashiSPISpeed500K = 50,
	KonashiSPISpeed1M = 100,
	KonashiSPISpeed2M = 200,
	KonashiSPISpeed3M = 300,
	KonashiSPISpeed6M = 600,
};

// Konashi SPI Mode
typedef NS_ENUM(int, KonashiSPIMode) {
	KonashiSPIModeEnableCPOL0CPHA0 = 0,
	KonashiSPIModeEnableCPOL0CPHA1 = 1,
	KonashiSPIModeEnableCPOL1CPHA0 = 2,
	KonashiSPIModeEnableCPOL1CPHA1 = 3,
	KonashiSPIModeDisable = -1
};
// Konashi SPI Bit order
typedef NS_ENUM(int, KonashiSPIBitOrder) {
	KonashiSPIBitOrderLSBFirst = 0,
	KonashiSPIBitOrderMSBFirst = 1
};

#endif
