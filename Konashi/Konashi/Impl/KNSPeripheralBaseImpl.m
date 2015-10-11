//
//  KNSPeripheralBaseImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/20/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSPeripheralBaseImpl.h"
#import "KonashiUtils.h"

// This UUID is defined by Bluetooth SIG
// see also this page.
// https://developer.bluetooth.org/gatt/services/Pages/ServiceViewer.aspx?u=org.bluetooth.service.device_information.xml
static NSString *const kDeviceInformationServiceUUIDString = @"180a";

// This UUID is defined by Bluetooth SIG
// see also this page.
// https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.software_revision_string.xml
static NSString *const kSoftwareRevisionStringCharacteristiceUUIDString = @"2a28";

@implementation KNSPeripheralBaseImpl

- (instancetype)initWithPeripheral:(CBPeripheral *)p
{
	self = [super init];
	if (self) {
		_peripheral = p;
		_peripheral.delegate = self;
		[self discoverCharacteristics];
		
		// Digital PIO
		pioSetting = 0;
		pioPullup = 0;
		pioInput = 0;
		pioOutput = 0;
		
		// PWM
		pwmSetting = 0;
		for (NSInteger i = 0; i < 8; i++) {
			pwmPeriod[i] = 0;
			pwmDuty[i] = 0;
		}
		
		// Analog IO
		for (NSInteger i = 0; i < 3; i++) {
			analogValue[i] = 0;
		}
		
		//I2C
		i2cSetting = KonashiI2CModeDisable;
		i2cReadDataLength = 0;
		i2cReadAddress = 0;
		
		// UART
		uartSetting = KonashiUartModeDisable;
		uartBaudrate = KonashiUartBaudrateRate9K6;
		
		// RSSI
		rssi = 0;
		
		// others
		_ready = NO;
		isCallFind = NO;
	}
	
	return self;
}

#pragma mark -

- (void)writeData:(NSData *)data serviceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

- (void)readDataWithServiceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@\r\n", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral readValueForCharacteristic:characteristic];
}

- (void)notificationWithServiceUUID:(CBUUID*)serviceUUID characteristicUUID:(CBUUID*)characteristicUUID on:(BOOL)on
{
    CBService *service = [self.peripheral kns_findServiceFromUUID:serviceUUID];

    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    CBCharacteristic *characteristic = [service kns_findCharacteristicFromUUID:characteristicUUID];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [characteristicUUID kns_dataDescription], [serviceUUID kns_dataDescription], self.peripheral.identifier.UUIDString);
        return;
    }
    [self.peripheral setNotifyValue:on forCharacteristic:characteristic];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
	KNS_LOG(@"peripheralDidUpdateRSSI");
	rssi = [peripheral.RSSI intValue];
	
	if (self.handlerManager.signalStrengthDidUpdateHandler) {
		self.handlerManager.signalStrengthDidUpdateHandler(rssi);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventSignalStrengthDidUpdateNotification object:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	if (!error) {
		KNS_LOG(@"Characteristics of service with UUID : %@ found", [service.UUID kns_dataDescription]);
		
#ifdef KONASHI_DEBUG
		for(int i=0; i < service.characteristics.count; i++) {
			CBCharacteristic *c = [service.characteristics objectAtIndex:i];
			KNS_LOG(@"Found characteristic %@\nvalue: %@\ndescriptors: %@\nproperties: %@\nisNotifying: %d\n",
					[c.UUID kns_dataDescription], c.value, c.descriptors, NSStringFromCBCharacteristicProperty(c.properties), c.isNotifying);
		}
#endif
		
		CBService *s = [peripheral.services lastObject];
		if([service.UUID kns_isEqualToUUID:s.UUID]) {
			KNS_LOG(@"Finished discovering all services' characteristics");
			// set konashi property
			if (self.handlerManager.readyHandler) {
				self.handlerManager.readyHandler();
			}			
			//read software revision string
			[self readDataWithServiceUUID:[CBUUID UUIDWithString:kDeviceInformationServiceUUIDString] characteristicUUID:[CBUUID UUIDWithString:kSoftwareRevisionStringCharacteristiceUUIDString]];
			
			// Enable PIO input notification
			[self enablePIOInputNotification];
			
			// Enable UART RX notification
			[self enableUART_RXNotification];
		}
	}
	else {
		KNS_LOG(@"ERROR: Characteristic discorvery unsuccessfull!");
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	KNS_LOG(@"didUpdateValueForCharacteristic");
	
	if (!error) {
		if ([characteristic.UUID kns_isEqualToUUID:[[self class] pioInputNotificationUUID]]) {
			[self digitalIODidUpdate:characteristic.value];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] analogReadUUIDWithPinNumber:0]]) {
			[self analogIODidUpdate:characteristic.value pin:0];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] analogReadUUIDWithPinNumber:1]]) {
			[self analogIODidUpdate:characteristic.value pin:1];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] analogReadUUIDWithPinNumber:2]]) {
			[self analogIODidUpdate:characteristic.value pin:2];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] i2cReadUUID]]) {
			[self i2cDataDidUpdate:characteristic.value];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] uartRX_NotificationUUID]]) {
			[self uartDataDidUpdate:characteristic.value];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[[self class] levelServiceUUID]]) {
			[self batteryLevelDataDidUpdate:characteristic.value];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:[CBUUID UUIDWithString:kSoftwareRevisionStringCharacteristiceUUIDString]]) {
			[self didReceiveSoftwareRevisionStringData:characteristic.value];
		}
	}
}

#pragma mark - KNSPeripheralImplProtocol

- (void)discoverCharacteristics
{
	[self.peripheral kns_discoverAllCharacteristics];
}

- (NSInteger)uartDataMaxLength
{
	return 1;
}

+ (NSInteger)i2cDataMaxLength
{
	return 0;
}

+ (NSInteger)levelServiceReadLength
{
	return 1;
}

+ (NSInteger)pioInputNotificationReadLength
{
	return 1;
}

+ (NSInteger)analogReadLength
{
	return 2;
}

+ (NSInteger)uartRX_NotificationReadLength
{
	return 1;
}

+ (NSInteger)hardwareLowBatteryNotificationReadLength
{
	return 1;
}

// UUID
+ (CBUUID *)batteryServiceUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)levelServiceUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)powerStateUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)serviceUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pioSettingUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pioPullupUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pioOutputUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pioInputNotificationUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pwmConfigUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pwmParamUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)pwmDutyUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)analogDriveUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)analogReadUUIDWithPinNumber:(NSInteger)pin
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)i2cConfigUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)i2cStartStopUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)i2cWriteUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)i2cReadParamUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)i2cReadUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)uartConfigUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)uartBaudrateUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)uartTX_UUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)uartRX_NotificationUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)hardwareResetUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (CBUUID *)lowBatteryNotificationUUID
{
	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	return nil;
}

+ (int) analogReference
{
	return 1300;
}

- (CBPeripheralState)state
{
	return self.peripheral.state;
}

#pragma mark - Digital

- (KonashiResult) writeValuePioSetting
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		KNS_LOG(@"PioSetting: %d", pioSetting);
		
		Byte t = (Byte)pioSetting;
		NSData *d = [[NSData alloc] initWithBytes:&t length:1];
		[self writeData:d serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pioSettingUUID]];
		
		return KonashiResultSuccess;
	} else {
		return KonashiResultFailure;
	}
}

- (KonashiResult) writeValuePioPullup
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		KNS_LOG(@"PioPullup: %d", pioPullup);
		
		Byte t = (Byte)pioPullup;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pioPullupUUID]];
		
		return KonashiResultSuccess;
	} else {
		return KonashiResultFailure;
	}
}

- (KonashiResult) writeValuePioOutput
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		KNS_LOG(@"PioOutput: %d", pioOutput);
		
		Byte t = (Byte)pioOutput;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pioOutputUUID]];
		
		return KonashiResultSuccess;
	} else {
		return KonashiResultFailure;
	}
}

- (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPinModeOutput || mode == KonashiPinModeInput)){
		// Set value
		if(mode == KonashiPinModeOutput){
			pioSetting |= 0x01 << pin;
		}
		else{
			pioSetting &= ~(0x01 << pin) & 0xFF;
		}
		
		// Write value
		return [self writeValuePioSetting];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pinModeAll:(int)mode
{
	if(mode >= 0x00 && mode <= 0xFF){
		// Set value
		pioSetting = mode;
		
		// Write value
		return [self writeValuePioSetting];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPinModePullup || mode == KonashiPinModeNoPulls)){
		// Set value
		if(mode == KonashiPinModePullup){
			pioPullup |= 0x01 << pin;
		} else {
			pioPullup &= ~(0x01 << pin) & 0xFF;
		}
		
		// Write value
		return [self writeValuePioPullup];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pinPullupAll:(int)mode
{
	if(mode >= 0x00 && mode <= 0xFF){
		// Set value
		pioPullup = mode;
		
		// Write value
		return [self writeValuePioPullup];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7){
		return (pioInput >> pin) & 0x01;
	}
	else{
		return KonashiLevelUnknown;
	}
}

- (int) digitalReadAll
{
	return pioInput;
}

- (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (value == KonashiLevelHigh || value == KonashiLevelLow)){
		// Set value
		if(value == KonashiLevelHigh){
			pioOutput |= 0x01 << pin;
		}
		else{
			pioOutput &= ~(0x01 << pin) & 0xFF;
		}
		
		// Write value
		if (self.handlerManager.digitalOutputDidChangeValueHandler) {
			self.handlerManager.digitalOutputDidChangeValueHandler(pin, value);
		}
		
		return [self writeValuePioOutput];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) digitalWriteAll:(int)value
{
	if(value >= 0x00 && value <= 0xFF){
		// Set value
		int xor = pioOutput ^ value;
		if (self.handlerManager.digitalOutputDidChangeValueHandler) {
			for (int i = 7; i >= 0; i--) {
				if (xor & 1 << i) {
					self.handlerManager.digitalOutputDidChangeValueHandler(i, value);
				}
			}
		}
		
		pioOutput = value;
		// Write value
		return [self writeValuePioOutput];
	}
	else{
		return KonashiResultFailure;
	}
}

- (void)digitalIODidUpdate:(NSData *)data
{
	unsigned char byte[32];
	// byteに更新されたPIOの値を格納する。
	[data getBytes:&byte length:[[self class] pioInputNotificationReadLength]];
	// 更新前の値と最新の値のXORを取り、変化したpinの値を取得(8bitで表現される。変化あり:1/変化なし:0)。
	int xor = (pioByte[0] ^ byte[0]) & (0xff ^ pioSetting);
	// 次回更新時の値と比較するために現在の値はpioByteに格納しておく。
	[data getBytes:&pioByte length:[[self class] pioInputNotificationReadLength]];
	pioInput = byte[0];
	if (self.handlerManager.digitalInputDidChangeValueHandler) {
		for (int i = 7; i >= 0; i--) {
			// 各bitに対して更新されたか確認する。
			if (xor & 1 << i) {
				self.handlerManager.digitalInputDidChangeValueHandler(i, [self digitalRead:i]);
			}
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventDigitalIODidUpdateNotification object:nil];
}

#pragma mark - PWM

- (KonashiResult) writeValuePwmSetting
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		KNS_LOG(@"PwmSetting: %d", pwmSetting);
		
		Byte t = (Byte)pwmSetting;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pwmConfigUUID]];
		
		return KonashiResultSuccess;
	} else {
		return KonashiResultFailure;
	}
}

- (KonashiResult) writeValuePwmPeriod:(KonashiDigitalIOPin)pin
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		Byte t[] = {pin,
			(unsigned char)((pwmPeriod[pin] >> 24) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 16) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 8) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 0) & 0xFF)};
		
		[self writeData:[NSData dataWithBytes:t length:5] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pwmParamUUID]];
		KNS_LOG(@"PwmPeriod: %d", pwmPeriod[pin]);
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) writeValuePwmDuty:(KonashiDigitalIOPin)pin
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		Byte t[] = {pin,
			(unsigned char)((pwmDuty[pin] >> 24) & 0xFF),
			(unsigned char)((pwmDuty[pin] >> 16) & 0xFF),
			(unsigned char)((pwmDuty[pin] >> 8) & 0xFF),
			(unsigned char)((pwmDuty[pin] >> 0) & 0xFF)};
		
		[self writeData:[NSData dataWithBytes:t length:5] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pwmDutyUUID]];
		
		KNS_LOG(@"pwmDuty: %d", pwmDuty[pin]);
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && (mode == KonashiPWMModeDisable || mode == KonashiPWMModeEnable || mode == KonashiPWMModeEnableLED )){
		// Set value
		if(mode == KonashiPWMModeEnable || mode == KonashiPWMModeEnableLED){
			pwmSetting |= 0x01 << pin;
		}
		else{
			pwmSetting &= ~(0x01 << pin) & 0xFF;
		}
		
		if (mode == KonashiPWMModeEnableLED){
			[self pwmPeriod:pin period:KonashiLEDPeriod];
			[self pwmLedDrive:pin dutyRatio:0.0];
		}
		
		// Write value
		return [self writeValuePwmSetting];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && pwmDuty[pin] <= period){
		pwmPeriod[pin] = period;
		return [self writeValuePwmPeriod:pin];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty
{
	if(pin >= KonashiDigitalIO0 && pin <= KonashiDigitalIO7 && duty <= pwmPeriod[pin]){
		pwmDuty[pin] = duty;
		return [self writeValuePwmDuty:pin];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio
{
	int duty;
	
	if(ratio < 0.0){
		ratio = 0.0;
	}
	if(ratio > 100.0){
		ratio = 100.0;
	}
	
	duty = (int)(KonashiLEDPeriod * ratio / 100);
	
	return [self pwmDuty:pin duty:duty];
}

#pragma mark - Analog

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin
{
	CBUUID *uuid;
	
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		uuid = [[self class] analogReadUUIDWithPinNumber:pin];
		[self readDataWithServiceUUID:[[self class] serviceUUID] characteristicUUID:uuid];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin
{
	if(pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2){
		return [self readValueAio:pin];
	}
	else{
		return KonashiResultFailure;
	}
}

- (int) analogRead:(KonashiAnalogIOPin)pin
{
	if(pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2){
		return analogValue[pin];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt
{
	if(pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2 && milliVolt >= 0 && milliVolt <= [[self class] analogReference] &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		Byte t[] = {pin, (milliVolt>>8)&0xFF, milliVolt&0xFF};
		[self writeData:[NSData dataWithBytes:t length:3] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] analogDriveUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (void)analogIODidUpdate:(NSData *)data pin:(KonashiAnalogIOPin)pin
{
	unsigned char byte[32];
	[data getBytes:&byte length:[[self class] analogReadLength]];
	analogValue[pin] = byte[0]<<8 | byte[1];
	
	int value = analogValue[pin];
	if (self.handlerManager.analogPinDidChangeValueHandler) {
		self.handlerManager.analogPinDidChangeValueHandler(pin, value);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventAnalogIODidUpdateNotification object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@[KonashiEventAnalogIO0DidUpdateNotification, KonashiEventAnalogIO1DidUpdateNotification, KonashiEventAnalogIO2DidUpdateNotification][pin] object:nil];
}

#pragma mark - I2C

- (KonashiResult) i2cMode:(KonashiI2CMode)mode
{
	if((mode == KonashiI2CModeDisable || mode == KonashiI2CModeEnable ||
		mode == KonashiI2CModeEnable100K || mode == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		i2cSetting = mode;
		
		Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cConfigUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult)i2cSendCondition:(KonashiI2CCondition)condition
{
	if((condition == KonashiI2CConditionStart || condition == KonashiI2CConditionRestart ||
		condition == KonashiI2CConditionStop) && self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		Byte t = condition;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cStartStopUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) i2cStartCondition
{
	return [self i2cSendCondition:KonashiI2CConditionStart];
}

- (KonashiResult) i2cRestartCondition
{
	return [self i2cSendCondition:KonashiI2CConditionRestart];
}

- (KonashiResult) i2cStopCondition
{
	return [self i2cSendCondition:KonashiI2CConditionStop];
}

- (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	int i;
	// I2Cの仕様で先頭にアドレスとデータ長を付け加えるために、配列の長さを+2する。
	unsigned char t[[[self class] i2cDataMaxLength] + 2];
	
	if(length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		t[0] = length+1;
		t[1] = (address << 1) & 0b11111110;
		for(i=0; i<length; i++){
			t[i+2] = data[i];
		}
		
		[self writeData:[NSData dataWithBytes:t length:length + 2] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cWriteUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult)i2cWriteData:(NSData *)data address:(unsigned char)address
{
	return [self i2cWrite:(int)data.length data:(unsigned char *)[data bytes] address:address];
}

- (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address
{
	if(length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		
		// set variables
		i2cReadAddress = (address<<1)|0x1;
		i2cReadDataLength = length;
		
		// Set read params
		Byte t[] = {length, i2cReadAddress};
		[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cReadParamUUID]];
		
		// Request read i2c value
		[self readDataWithServiceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] i2cReadUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	if(length==i2cReadDataLength){
		[i2cReadData getBytes:data length:length];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (NSData *)i2cReadData
{
	return i2cReadData;
}


- (void)i2cDataDidUpdate:(NSData *)data
{
	i2cReadData = [data copy];
	// [0]: MSB
	if (self.handlerManager.i2cReadCompleteHandler) {
		self.handlerManager.i2cReadCompleteHandler(i2cReadData);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventI2CReadCompleteNotification object:nil];
}

#pragma mark - UART

- (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate
{
	KonashiResult result = KonashiResultFailure;
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		if(KonashiUartBaudrateRate2K4 <= baudrate && baudrate <= KonashiUartBaudrateRate9K6){
			result = KonashiResultSuccess;
		}
		if(mode == KonashiUartModeDisable || mode == KonashiUartModeEnable) {
			result = (result == KonashiResultSuccess) ? KonashiResultSuccess : KonashiResultFailure;
		}
	}
	
	if (result == KonashiResultSuccess) {
		[self writeData:[NSData dataWithBytes:&mode length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartConfigUUID]];
		Byte t[] = {(baudrate >> 8) & 0xff, baudrate & 0xff};
		NSData *baudrateData = [NSData dataWithBytes:t length:2];
		[self writeData:baudrateData serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartBaudrateUUID]];
		
		uartSetting = mode;
		uartBaudrate = baudrate;
	}
	
	return result;
}

- (KonashiResult) uartMode:(KonashiUartMode)mode
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected &&
	   ( mode == KonashiUartModeDisable || mode == KonashiUartModeEnable ) ){
		Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartConfigUUID]];
		uartSetting = mode;
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	KonashiResult result = KonashiResultFailure;
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeDisable){
		if(KonashiUartBaudrateRate2K4 <= baudrate && baudrate <= KonashiUartBaudrateRate9K6){
			result = KonashiResultSuccess;
		}
	}
	
	if (result == KonashiResultSuccess) {
		Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
		NSData *baudrateData = [NSData dataWithBytes:t length:2];
		[self writeData:baudrateData serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartBaudrateUUID]];
		uartBaudrate = baudrate;
	}
	
	return result;
}

- (KonashiResult) uartWrite:(unsigned char)data
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeEnable) {
		[self writeData:[NSData dataWithBytes:&data length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartTX_UUID]];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartWriteData:(NSData *)data
{
	KonashiResult result = KonashiResultFailure;
	
	unsigned char *d = (unsigned char *)[data bytes];
	for (NSInteger i = 0; i < data.length; i++) {
		result = [self uartWrite:d[i]];
		if (result == KonashiResultFailure) {
			break;
		}
	}
	
	return result;
}

- (NSData *) readUartData
{
	return uartRxData;
}

- (void)uartDataDidUpdate:(NSData *)data
{
	uartRxData = [data copy];
	// [0]: MSB
	if (self.handlerManager.uartRxCompleteHandler) {
		self.handlerManager.uartRxCompleteHandler(uartRxData);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventUartRxCompleteNotification object:nil];
}

#pragma mark -

- (void)didReceiveSoftwareRevisionStringData:(NSData *)data
{
	_softwareRevisionString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	_softwareRevisionString = [_softwareRevisionString stringByReplacingOccurrencesOfString:@"\0" withString:@""];
	_ready = YES;
	
	if (self.handlerManager.readyHandler) {
		self.handlerManager.readyHandler();
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventImplReadyToUseNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventDidFindSoftwareRevisionStringNotification object:nil];
}

- (KonashiResult) reset
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		Byte t = 1;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] hardwareResetUUID]];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) batteryLevelReadRequest
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		[self readDataWithServiceUUID:[[self class] batteryServiceUUID] characteristicUUID:[[self class] levelServiceUUID]];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (int) batteryLevelRead
{
	return batteryLevel;
}

- (void)batteryLevelDataDidUpdate:(NSData *)data
{
	unsigned char byte[32];
	[data getBytes:&byte length:[[self class] levelServiceReadLength]];
	batteryLevel = byte[0];
	if (self.handlerManager.batteryLevelDidUpdateHandler) {
		self.handlerManager.batteryLevelDidUpdateHandler(batteryLevel);
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventBatteryLevelDidUpdateNotification object:nil];
}

- (KonashiResult) signalStrengthReadRequest
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		[self.peripheral readRSSI];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (int) signalStrengthRead
{
	return rssi;
}

- (void)enablePIOInputNotification
{
	[self notificationWithServiceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] pioInputNotificationUUID] on:YES];
}

- (void)enableUART_RXNotification
{
	[self notificationWithServiceUUID:[[self class] serviceUUID] characteristicUUID:[[self class] uartRX_NotificationUUID] on:YES];
}

@end
