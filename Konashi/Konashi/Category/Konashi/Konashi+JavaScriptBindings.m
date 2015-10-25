//
//  Konashi+JavaScriptCore.m
//  Konashi
//
//  Created by Akira Matsuda on 10/21/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi.h"
#import "KNSKonashiPeripheralImpl.h"
#import "KNSKoshianPeripheralImpl.h"
#import "Konashi+JavaScriptBindings.h"

@interface KNSJavaScriptVirtualMachine ()

@property (nonatomic, readonly) JSContext *context;

@end

@implementation KNSJavaScriptVirtualMachine

static NSString *const JS_KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON = @"centralManagerPoweredOn";
static NSString *const JS_KONASHI_EVENT_PERIPHERAL_FOUND = @"peripheralFound";
static NSString *const JS_KONASHI_EVENT_PERIPHERAL_NOT_FOUND = @"peripheralNotFound";
static NSString *const JS_KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE = @"noPeripheralsAvailable";
static NSString *const JS_KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED = @"peripheralSelectorDismissed";
static NSString *const JS_KONASHI_EVENT_CONNECTED = @"connected";
static NSString *const JS_KONASHI_EVENT_DISCONNECTED = @"disconnected";
static NSString *const JS_KONASHI_EVENT_READY = @"ready";
static NSString *const JS_KONASHI_EVENT_UPDATE_PIO_INPUT = @"updatePioInput";
static NSString *const JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE = @"updateAnalogValue";
static NSString *const JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0 = @"updateAnalogValueAio0";
static NSString *const JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1 = @"updateAnalogValueAio1";
static NSString *const JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2 = @"updateAnalogValueAio2";
static NSString *const JS_KONASHI_EVENT_I2C_READ_COMPLETE = @"i2cReadComplete";
static NSString *const JS_KONASHI_EVENT_UART_RX_COMPLETE = @"uartRxComplete";
static NSString *const JS_KONASHI_EVENT_UPDATE_BATTERY_LEVEL = @"updateBatteryLevel";
static NSString *const JS_KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH = @"updateSignalStrength";
static NSString *const JS_KONASHI_EVENT_START_DISCOVERY = @"startDiscovery";
static NSString *const JS_KONASHI_EVENT_SPI_WRITE_COMPLETE = @"spiWriteComplete";
static NSString *const JS_KONASHI_EVENT_SPI_READ_COMPLETE = @"spiReadComplete";

- (instancetype)init
{
	self = [super init];
	if (self) {
		_context = [JSContext new];
	}
	
	return self;
}

+ (instancetype)sharedInstance
{
	static KNSJavaScriptVirtualMachine *vm;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		vm = [KNSJavaScriptVirtualMachine new];
		vm.context[@"Konashi"] = [Konashi class];
		vm.context[@"Konashi"][@"KONASHI_URL_SCHEME"] = @"konashijs";
		
		vm.context[@"Konashi"][@"HIGH"] = @(KonashiLevelHigh);
		vm.context[@"Konashi"][@"LOW"] = @(KonashiLevelLow);
		
		vm.context[@"Konashi"][@"INPUT"] = @(KonashiPinModeInput);
		vm.context[@"Konashi"][@"OUTPUT"] = @(KonashiPinModeOutput);
		vm.context[@"Konashi"][@"PULLUP"] = @(KonashiPinModePullup);
		vm.context[@"Konashi"][@"NO_PULLS"] = @(KonashiPinModeNoPulls);
		
		vm.context[@"Konashi"][@"ENABLE"] = @YES;
		vm.context[@"Konashi"][@"DISABLE"] = @NO;
		
		vm.context[@"Konashi"][@"PIO0"] = @(KonashiDigitalIO0);
		vm.context[@"Konashi"][@"PIO1"] = @(KonashiDigitalIO1);
		vm.context[@"Konashi"][@"PIO2"] = @(KonashiDigitalIO2);
		vm.context[@"Konashi"][@"PIO3"] = @(KonashiDigitalIO3);
		vm.context[@"Konashi"][@"PIO4"] = @(KonashiDigitalIO4);
		vm.context[@"Konashi"][@"PIO5"] = @(KonashiDigitalIO5);
		vm.context[@"Konashi"][@"PIO6"] = @(KonashiDigitalIO6);
		vm.context[@"Konashi"][@"PIO7"] = @(KonashiDigitalIO7);
		
		vm.context[@"Konashi"][@"S1"] = @(KonashiS1);
		vm.context[@"Konashi"][@"LED2"] = @(KonashiLED2);
		vm.context[@"Konashi"][@"LED3"] = @(KonashiLED3);
		vm.context[@"Konashi"][@"LED4"] = @(KonashiLED4);
		vm.context[@"Konashi"][@"LED5"] = @(KonashiLED5);
		vm.context[@"Konashi"][@"AIO0"] = @(KonashiAnalogIO0);
		vm.context[@"Konashi"][@"AIO1"] = @(KonashiAnalogIO1);
		vm.context[@"Konashi"][@"AIO2"] = @(KonashiAnalogIO2);
		
		vm.context[@"Konashi"][@"I2C_SDA"] = @(KonashiI2C_SDA);
		vm.context[@"Konashi"][@"I2C_SCL"] = @(KonashiI2C_SCL);
		
		vm.context[@"Konashi"][@"KONASHI_SUCCESS"] = @(KonashiResultSuccess);
		vm.context[@"Konashi"][@"KONASHI_FAILURE"] = @(KonashiResultFailure);
		
		vm.context[@"Konashi"][@"KONASHI_PWM_DISABLE"] = @(KonashiPWMModeDisable);
		vm.context[@"Konashi"][@"KONASHI_PWM_ENABLE"] = @(KonashiPWMModeEnable);
		vm.context[@"Konashi"][@"KONASHI_PWM_ENABLE_LED_MODE"] = @(KonashiPWMModeEnableLED);
		vm.context[@"Konashi"][@"KONASHI_PWM_LED_PERIOD"] = @(KonashiLEDPeriod);
		
		vm.context[@"Konashi"][@"KONASHI_ANALOG_REFERENCE"] = @([[KNSKonashiPeripheralImpl class] analogReference]);
		vm.context[@"Konashi"][@"KOSHIAN_ANALOG_REFERENCE"] = @([[KNSKoshianPeripheralImpl class] analogReference]);
		
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_2K4"] = @(KonashiUartBaudrateRate2K4);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_9K6"] = @(KonashiUartBaudrateRate9K6);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_19K2"] = @(KonashiUartBaudrateRate19K2);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_38K4"] = @(KonashiUartBaudrateRate38K4);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_57K6"] = @(KonashiUartBaudrateRate57K6);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_76K8"] = @(KonashiUartBaudrateRate76K8);
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_115K2"] = @(KonashiUartBaudrateRate115K2);
		
		vm.context[@"Konashi"][@"KONASHI_I2C_DATA_MAX_LENGTH"] = @([[KNSKonashiPeripheralImpl class] i2cDataMaxLength]);
		vm.context[@"Konashi"][@"KOSHIAN_I2C_DATA_MAX_LENGTH"] = @([[KNSKoshianPeripheralImpl class] i2cDataMaxLength]);
		vm.context[@"Konashi"][@"KONASHI_I2C_DISABLE"] = @(KonashiI2CModeDisable);
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE"] = @(KonashiI2CModeEnable);
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE_100K"] = @(KonashiI2CModeEnable100K);
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE_400K"] = @(KonashiI2CModeEnable400K);
		vm.context[@"Konashi"][@"KONASHI_I2C_STOP_CONDITION"] = @(KonashiI2CConditionStop);
		vm.context[@"Konashi"][@"KONASHI_I2C_START_CONDITION"] = @(KonashiI2CConditionStart);
		vm.context[@"Konashi"][@"KONASHI_I2C_RESTART_CONDITION"] = @(KonashiI2CConditionRestart);
		
		vm.context[@"Konashi"][@"KONASHI_UART_DISABLE"] = @(KonashiUartModeDisable);
		vm.context[@"Konashi"][@"KONASHI_UART_ENABLE"] = @(KonashiUartModeEnable);
		vm.context[@"Konashi"][@"KONASHI_UART_MAX_DATA_LENGTH"] = @(1);
		vm.context[@"Konashi"][@"KOSHIAN_1_0_UART_MAX_DATA_LENGTH"] = @(1);
		vm.context[@"Konashi"][@"KOSHIAN_2_0_UART_MAX_DATA_LENGTH"] = @(18);
		
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_200K"] = @(KonashiSPISpeed200K);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_500K"] = @(KonashiSPISpeed500K);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_1M"] = @(KonashiSPISpeed1M);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_2M"] = @(KonashiSPISpeed2M);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_3M"] = @(KonashiSPISpeed3M);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_SPEED_6M"] = @(KonashiSPISpeed6M);
		
		vm.context[@"Konashi"][@"KOSHIAN_SPI_MODE_CPOL0_CPHA0"] = @(KonashiSPIModeEnableCPOL0CPHA0);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_MODE_CPOL0_CPHA1"] = @(KonashiSPIModeEnableCPOL0CPHA1);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_MODE_CPOL1_CPHA0"] = @(KonashiSPIModeEnableCPOL1CPHA0);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_MODE_CPOL1_CPHA1"] = @(KonashiSPIModeEnableCPOL1CPHA1);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_MODE_DISABLE"] = @(KonashiSPIModeDisable);
		
		vm.context[@"Konashi"][@"KOSHIAN_SPI_BIT_ORDER_LSB_FIRST"] = @(KonashiSPIBitOrderLSBFirst);
		vm.context[@"Konashi"][@"KOSHIAN_SPI_BIT_ORDER_MSB_FIRST"] = @(KonashiSPIBitOrderMSBFirst);
		
		NSDictionary *events = @{KonashiEventCentralManagerPowerOnNotification : JS_KONASHI_EVENT_CENTRAL_MANAGER_POWERED_ON,
							KonashiEventPeripheralNotFoundNotification : JS_KONASHI_EVENT_PERIPHERAL_NOT_FOUND,
							KonashiEventConnectedNotification : JS_KONASHI_EVENT_CONNECTED,
							KonashiEventDisconnectedNotification : JS_KONASHI_EVENT_DISCONNECTED,
							KonashiEventReadyToUseNotification : JS_KONASHI_EVENT_READY,
							KonashiEventDigitalIODidUpdateNotification : JS_KONASHI_EVENT_UPDATE_PIO_INPUT,
							KonashiEventAnalogIODidUpdateNotification : JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE,
							KonashiEventAnalogIO0DidUpdateNotification : JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0,
							KonashiEventAnalogIO1DidUpdateNotification : JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1,
							KonashiEventAnalogIO2DidUpdateNotification : JS_KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2,
							KonashiEventI2CReadCompleteNotification : JS_KONASHI_EVENT_I2C_READ_COMPLETE,
							KonashiEventUartRxCompleteNotification : JS_KONASHI_EVENT_UART_RX_COMPLETE,
							KonashiEventBatteryLevelDidUpdateNotification : JS_KONASHI_EVENT_UPDATE_BATTERY_LEVEL,
							KonashiEventSignalStrengthDidUpdateNotification : JS_KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH,
							KonashiEventStartDiscoveryNotification : JS_KONASHI_EVENT_START_DISCOVERY,
							KonashiEventSPIWriteCompleteNotification : JS_KONASHI_EVENT_SPI_WRITE_COMPLETE,
							KonashiEventSPIReadCompleteNotification : JS_KONASHI_EVENT_SPI_READ_COMPLETE
							};
		
		[events enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			[[NSNotificationCenter defaultCenter] addObserverForName:key object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
				[KNSJavaScriptVirtualMachine callFunctionWithKey:obj namespace:@"Konashi" args:nil];
			}];
			vm.context[@"Konashi"][obj] = ^(JSValue* value) {
			};
		}];
		
		vm.context[@"Konashi"][@"log"] = ^(JSValue* value) {
			NSLog(@"[Konashi log]: %@", value);
		};
		vm.context.exceptionHandler = ^(JSContext *ctx, JSValue* error) {
			NSLog(@"[Konashi JSB Exception]: %@", error);
		};
		
		vm.context[@"KonashiBridgeHandler"] = [NSObject class];
		vm.context[@"KonashiBridgeStore"] = [NSObject class];
	});
	
	return vm;
}

+ (JSValue *)evaluateScript:(NSString *)script
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	return [vm.context evaluateScript:script];
}

+ (JSValue *)callFunctionWithKey:(NSString *)key namespace:(NSString *)namespace args:(NSArray *)args
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	id obj = vm.context[namespace][key];
	JSValue *value = nil;
	if ([obj isMemberOfClass:[JSValue class]]) {
		value = [(JSValue *)obj callWithArguments:nil];
	}
	else {
		value = [vm.context[namespace][key] callWithArguments:args];
	}
	
	return value;
}

+ (JSValue *)callFunctionWithKey:(NSString *)key args:(NSArray *)args
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	return [vm.context[key] callWithArguments:args];
}

+ (void)addBridgeHandlerWithKey:(NSString *)key hendler:(void (^)(JSValue* value))handler
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	vm.context[@"KonashiBridgeHandler"][key] = handler;
}

+ (void)setBridgeVariableWithKey:(NSString *)key variable:(id)obj
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	vm.context[@"KonashiBridgeStore"][key] = obj;
}

+ (JSValue *)getBridgeVariableWithKey:(NSString *)key
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	return vm.context[@"KonashiBridgeStore"][key];
}

@end

@implementation KNSWebView

@end
