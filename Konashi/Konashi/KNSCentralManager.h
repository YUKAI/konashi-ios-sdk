//
//  KNSCentralManager.h
//  Konashi
//
//  Created by Akira Matsuda on 11/13/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class KNSPeripheral;
@interface KNSCentralManager : CBCentralManager <CBCentralManagerDelegate>

@property (nonatomic, readonly) NSSet *activePeripherals;
@property (nonatomic, readonly) NSSet *peripherals;
@property (nonatomic, assign) BOOL discovering;
@property (nonatomic, copy) void (^didUpdateStateBlock)(CBCentralManager *central);
@property (nonatomic, copy) void (^willRestoreStateBlock)(CBCentralManager *central, NSDictionary *dict);
@property (nonatomic, copy) void (^didRetrievePeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didRetrieveConnectedPeripheralsBlock)(CBCentralManager *central, NSArray *peripherals);
@property (nonatomic, copy) void (^didFailToConnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);
@property (nonatomic, copy) void (^didDisconnectPeripheralBlock)(CBCentralManager *central, KNSPeripheral *peripheral, NSError *error);
@property (nonatomic, copy) void (^didConnectPeripheral)(CBCentralManager *central, KNSPeripheral *peripheral);

+ (instancetype)sharedInstance;
- (void)discover:(void (^)(CBPeripheral *peripheral, BOOL *stop))discoverBlocks completionBlock:(void (^)(NSSet *peripherals, BOOL timeout))timeoutBlock timeoutInterval:(NSTimeInterval)timeoutInterval;
- (void)connectWithName:(NSString*)name timeout:(NSTimeInterval)timeout connectedHandler:(void (^)(KNSPeripheral *connectedPeripheral))connectedHandler;
- (KNSPeripheral *)connectWithPeripheral:(CBPeripheral *)peripheral;
- (void)connectKonashiPeripheral:(KNSPeripheral *)peripheral;

@end
