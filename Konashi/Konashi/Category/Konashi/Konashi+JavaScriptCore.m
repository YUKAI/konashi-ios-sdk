//
//  Konashi+JavaScriptCore.m
//  Konashi
//
//  Created by Akira Matsuda on 10/21/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi+JavaScriptCore.h"
#import "Konashi.h"

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
static NSString *const JS_KONASHI_EVENT_I2C_READ_COMPLETE = @"I2CReadComplete";
static NSString *const JS_KONASHI_EVENT_UART_RX_COMPLETE = @"UartRxComplete";
static NSString *const JS_KONASHI_EVENT_UPDATE_BATTERY_LEVEL = @"updateBatteryLevel";
static NSString *const JS_KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH = @"updateSignalStrength";

@interface KNSJavaScriptVirtualMachine ()

@property (nonatomic, readonly) JSContext *context;

@end

@implementation KNSJavaScriptVirtualMachine

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
		vm.context[@"Konashi"][@"HIGH"] = @1;
		vm.context[@"Konashi"][@"LOW"] = @0;
		vm.context[@"Konashi"][@"INPUT"] = @0;
		vm.context[@"Konashi"][@"OUTPUT"] = @1;
		vm.context[@"Konashi"][@"PULLUP"] = @1;
		vm.context[@"Konashi"][@"NO_PULLS"] = @0;
		vm.context[@"Konashi"][@"ENABLE"] = @YES;
		vm.context[@"Konashi"][@"DISABLE"] = @NO;
		vm.context[@"Konashi"][@"PIO0"] = @0;
		vm.context[@"Konashi"][@"PIO1"] = @1;
		vm.context[@"Konashi"][@"PIO2"] = @2;
		vm.context[@"Konashi"][@"PIO3"] = @3;
		vm.context[@"Konashi"][@"PIO4"] = @4;
		vm.context[@"Konashi"][@"PIO5"] = @5;
		vm.context[@"Konashi"][@"PIO6"] = @6;
		vm.context[@"Konashi"][@"PIO7"] = @7;
		vm.context[@"Konashi"][@"S1"] = @0;
		vm.context[@"Konashi"][@"LED2"] = @1;
		vm.context[@"Konashi"][@"LED3"] = @2;
		vm.context[@"Konashi"][@"LED4"] = @3;
		vm.context[@"Konashi"][@"LED5"] = @4;
		vm.context[@"Konashi"][@"AIO0"] = @0;
		vm.context[@"Konashi"][@"AIO1"] = @1;
		vm.context[@"Konashi"][@"AIO2"] = @2;
		vm.context[@"Konashi"][@"I2C_SDA"] = @6;
		vm.context[@"Konashi"][@"I2C_SCL"] = @7;
		vm.context[@"Konashi"][@"KONASHI_SUCCESS"] = @0;
		vm.context[@"Konashi"][@"KONASHI_FAILURE"] = @-1;
		vm.context[@"Konashi"][@"KONASHI_PWM_DISABLE"] = @NO;
		vm.context[@"Konashi"][@"KONASHI_PWM_ENABLE"] = @YES;
		vm.context[@"Konashi"][@"KONASHI_PWM_ENABLE_LED_MODE"] = @2;
		vm.context[@"Konashi"][@"KONASHI_PWM_LED_PERIOD"] = @10000;
		vm.context[@"Konashi"][@"KONASHI_ANALOG_REFERENCE"] = @1300;
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_2K4"] = @0x000a;
		vm.context[@"Konashi"][@"KONASHI_UART_RATE_9K6"] = @0x0028;
		vm.context[@"Konashi"][@"KONASHI_I2C_DATA_MAX_LENGTH"] = @18;
		vm.context[@"Konashi"][@"KONASHI_I2C_DISABLE"] = @NO;
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE"] = @YES;
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE_100K"] = @1;
		vm.context[@"Konashi"][@"KONASHI_I2C_ENABLE_400K"] = @2;
		vm.context[@"Konashi"][@"KONASHI_I2C_STOP_CONDITION"] = @0;
		vm.context[@"Konashi"][@"KONASHI_I2C_START_CONDITION"] = @1;
		vm.context[@"Konashi"][@"KONASHI_I2C_RESTART_CONDITION"] = @2;
		vm.context[@"Konashi"][@"KONASHI_UART_DATA_MAX_LENGTH"] = @19;
		vm.context[@"Konashi"][@"KONASHI_UART_DISABLE"] = @0;
		vm.context[@"Konashi"][@"KONASHI_UART_ENABLE"] = @1;
		
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
								 KonashiEventSignalStrengthDidUpdateNotification : JS_KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH};
		
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

+ (void)addBridgeHandlerWithTarget:(id)target selector:(SEL)selector
{
	KNSJavaScriptVirtualMachine *vm = [KNSJavaScriptVirtualMachine sharedInstance];
	vm.context[@"KonashiBridgeHandler"][NSStringFromSelector(selector)] = ^(){
		[target performSelector:@selector(selector)];
	};
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
