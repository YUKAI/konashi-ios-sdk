//
//  KNSCentralManager.m
//  Konashi
//
//  Created by Akira Matsuda on 11/13/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSCentralManager.h"
#import "Konashi.h"
#import "KNSPeripheralImpls.h"
#import <objc/runtime.h>

@interface KNSCentralManagerHandler : NSObject

@property (nonatomic, copy) void (^didUpdateStateBlock)(CBCentralManager *central);
@property (nonatomic, copy) void (^willRestoreStateBlock)(CBCentralManager *central, NSDictionary *dict);
@property (nonatomic, copy) void (^didRetrievePeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didRetrieveConnectedPeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didFailToConnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);
@property (nonatomic, copy) void (^didDisconnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didConnectPeripheral)(CBCentralManager *central, CBPeripheral *peripheral);

@end

@implementation KNSCentralManagerHandler

@end

@interface KNSCentralManager ()
{
	NSMutableSet *connectedPeripherals_;
	NSMutableSet *peripherals_;
	NSMutableSet *activePeripherals_;
}

@property (nonatomic, readonly) KNSCentralManagerHandler *handler;

@end

@implementation KNSCentralManager

static KNSCentralManager *c;
+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		c = [KNSCentralManager new];
	});
	
	return c;
}

- (instancetype)init
{
	self = [self initWithDelegate:self queue:dispatch_get_main_queue()];
	if (self) {
		_handler = [KNSCentralManagerHandler new];
		connectedPeripherals_ = [NSMutableSet new];
		peripherals_ = [NSMutableSet new];
		activePeripherals_ = [NSMutableSet new];
	}
	
	return self;
}

- (NSSet *)connectedPeripherals
{
	return [connectedPeripherals_ copy];
}

- (NSSet *)peripherals
{
	return [peripherals_ copy];
}

#pragma mark - 

- (void)discover:(void (^)(CBPeripheral *peripheral, BOOL *stop))discoverBlocks
{
	[self discover:discoverBlocks timeoutBlock:^(NSSet *peripherals) {
	} timeoutInterval:KonashiFindTimeoutInterval];
}

- (void)discover:(void (^)(CBPeripheral *peripheral, BOOL *stop))discoverBlocks timeoutBlock:(void (^)(NSSet *peripherals))timeoutBlock timeoutInterval:(NSTimeInterval)timeoutInterval
{
    KNS_LOG(@"discover");
	if (self.discovering == NO) {
		[peripherals_ removeAllObjects];
		
		self.discovering = YES;
		NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:timeoutInterval target:self selector:@selector(stopDiscoveriong:) userInfo:@{@"callback":[timeoutBlock copy]} repeats:YES];
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[self.handler setDidUpdateStateBlock:^(CBCentralManager *central) {
				if (central.state == CBCentralManagerStatePoweredOn) {
					[central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
				}
			}];
			__weak typeof(self) bself = self;
			[self.handler setDidDiscoverPeripheralBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
				BOOL stop = NO;
				discoverBlocks(peripheral, &stop);
				if (stop == YES) {
					[bself stopDiscoveriong:t];
				}
			}];			
		});
		
		if (self.state == CBCentralManagerStatePoweredOn) {
			[self scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
		}
	}
}

- (void)stopDiscoveriong:(NSTimer *)timer
{
	KNS_LOG(@"stopDiscoveriong");
	[self stopScan];
	self.discovering = NO;
	void (^timeoutBlock)(NSSet *peripherals) = timer.userInfo[@"callback"];
	timeoutBlock(self.peripherals);
	[timer invalidate];
}

- (KNSPeripheral *)connectWithPeripheral:(CBPeripheral *)peripheral
{
	KNSPeripheral *p =[[KNSPeripheral alloc] initWithPeripheral:peripheral];
	[activePeripherals_ addObject:p];
	[self connectPeripheral:peripheral options:0];
	
	return p;
}

- (KNSPeripheral *)findActivePeripheralWithPeripheral:(CBPeripheral *)peripheral
{
	KNSPeripheral *result = nil;
	for (KNSPeripheral *p in activePeripherals_) {
		if (p.assignedPeripheral == peripheral) {
			result = p;
			break;
		}
	}
	
	return result;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	if (self.handler.didUpdateStateBlock) {
		self.handler.didUpdateStateBlock(central);
	}

	if (self.didUpdateStateBlock) {
		self.didUpdateStateBlock(central);
	}
	if (central.state == CBCentralManagerStatePoweredOn) {
		[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventCentralManagerPowerOnNotification object:nil];
	}
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
	if (self.handler.willRestoreStateBlock) {
		self.handler.willRestoreStateBlock(central, dict);
	}
	
	if (self.willRestoreStateBlock) {
		self.willRestoreStateBlock(central, dict);
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
	if (self.handler.didRetrievePeripheralsBlock) {
		self.handler.didRetrievePeripheralsBlock(central, peripherals);
	}
	
	if (self.didRetrievePeripheralsBlock) {
		self.didRetrievePeripheralsBlock(central, peripherals);
	}
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	if (self.handler.didRetrieveConnectedPeripheralsBlock) {
		self.handler.didRetrieveConnectedPeripheralsBlock(central, peripherals);
	}
	
	if (self.didRetrieveConnectedPeripheralsBlock) {
		self.didRetrieveConnectedPeripheralsBlock(central, peripherals);
	}
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	if (self.handler.didFailToConnectPeripheralBlock) {
		self.handler.didFailToConnectPeripheralBlock(central, peripheral, error);
	}
	
	if (self.didFailToConnectPeripheralBlock) {
		self.didFailToConnectPeripheralBlock(central, peripheral, error);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventDidFailToConnectNotification object:nil userInfo:@{}];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	KNS_LOG(@"New UUID, adding:%@", peripheral.name);
	[peripherals_ addObject:peripheral];
	
	if (self.handler.didDiscoverPeripheralBlock) {
		self.handler.didDiscoverPeripheralBlock(central, peripheral, advertisementData, RSSI);
	}
	
	if (self.didDiscoverPeripheralBlock) {
		self.didDiscoverPeripheralBlock(central, peripheral, advertisementData, RSSI);
	}
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	KNS_LOG(@"Disconnect from the peripheral: %@, error: %@", [peripheral name], error);
	if (self.handler.didDisconnectPeripheralBlock) {
		self.handler.didDisconnectPeripheralBlock(central, peripheral, error);
	}
	KNSPeripheral *p = [self findActivePeripheralWithPeripheral:peripheral];
	if (self.didDisconnectPeripheralBlock) {
		self.didDisconnectPeripheralBlock(central, p, error);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventDisconnectedNotification object:self userInfo:@{KonashiPeripheralKey:p, KonashiErrorKey: error}];
	[connectedPeripherals_ removeObject:peripheral];
	[peripherals_ removeObject:peripheral];
	[activePeripherals_ removeObject:p];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	KNS_LOG(@"Connect to peripheral with UUID : %@ successfull", peripheral.identifier.UUIDString);
	if (self.handler.didConnectPeripheral) {
		self.handler.didConnectPeripheral(central, peripheral);
	}
	
	KNSPeripheral *p = [self findActivePeripheralWithPeripheral:peripheral];
	[p.assignedPeripheral kns_discoverAllServices];
	if (self.didConnectPeripheral) {
		self.didConnectPeripheral(central, p);
	}
	
	[connectedPeripherals_ addObject:peripheral];
}

@end
