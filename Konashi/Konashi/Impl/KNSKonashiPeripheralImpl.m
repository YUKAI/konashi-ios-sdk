//
//  KonashiPeripheralImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/19/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSKonashiPeripheralImpl.h"
#import "KonashiDb.h"
#import "KonashiUtils.h"

@implementation KNSKonashiPeripheralImpl

#pragma mark - KonashiPeripheralImplProtocol

- (CBPeripheralState)state
{
	return self.peripheral.state;
}

- (NSString *)findName
{
	return self.peripheral.name;
}

- (int) writeValuePioSetting
{
    if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        KNS_LOG(@"PioSetting: %d", pioSetting);
        
        Byte t = (Byte)pioSetting;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
		[self writeData:d serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_SETTING_UUID];
		
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}

- (int) writeValuePioPullup
{
    if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        KNS_LOG(@"PioPullup: %d", pioPullup);
		
        Byte t = (Byte)pioPullup;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_PULLUP_UUID];
		
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}

- (int) writeValuePioOutput
{
    if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        KNS_LOG(@"PioOutput: %d", pioOutput);
        
        Byte t = (Byte)pioOutput;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_OUTPUT_UUID];
		
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}

- (int) pinMode:(int)pin mode:(int)mode
{
	if(pin >= PIO0 && pin <= PIO7 && (mode == OUTPUT || mode == INPUT)){
        // Set value
        if(mode == OUTPUT){
            pioSetting |= 0x01 << pin;
        }
        else{
            pioSetting &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        return [self writeValuePioSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pinModeAll:(int)mode
{
	if(mode >= 0x00 && mode <= 0xFF){
        // Set value
        pioSetting = mode;
        
        // Write value
        return [self writeValuePioSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pinPullup:(int)pin mode:(int)mode
{
	if(pin >= PIO0 && pin <= PIO7 && (mode == PULLUP || mode == NO_PULLS)){
        // Set value
        if(mode == PULLUP){
            pioPullup |= 0x01 << pin;
        } else {
            pioPullup &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        return [self writeValuePioPullup];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pinPullupAll:(int)mode
{
	if(mode >= 0x00 && mode <= 0xFF){
        // Set value
        pioPullup = mode;
        
        // Write value
        return [self writeValuePioPullup];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) digitalRead:(int)pin
{
	if(pin >= PIO0 && pin <= PIO7){
        return (pioInput >> pin) & 0x01;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) digitalReadAll
{
	return pioInput;
}

- (int) digitalWrite:(int)pin value:(int)value
{
	if(pin >= PIO0 && pin <= PIO7 && (value == HIGH || value == LOW)){
        // Set value
        if(value == HIGH){
            pioOutput |= 0x01 << pin;
        }
        else{
            pioOutput &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        return [self writeValuePioOutput];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) digitalWriteAll:(int)value
{
	if(value >= 0x00 && value <= 0xFF){
        // Set value
        pioOutput = value;
        
        // Write value
        return [self writeValuePioOutput];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) writeValuePwmSetting
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        KNS_LOG(@"PwmSetting: %d", pwmSetting);
        
        Byte t = (Byte)pwmSetting;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_CONFIG_UUID];
		
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}

- (int) writeValuePwmPeriod:(int)pin
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        Byte t[] = {pin,
			(unsigned char)((pwmPeriod[pin] >> 24) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 16) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 8) & 0xFF),
			(unsigned char)((pwmPeriod[pin] >> 0) & 0xFF)};
        
        [self writeData:[NSData dataWithBytes:t length:5] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_PARAM_UUID];
        KNS_LOG(@"PwmPeriod: %d", pwmPeriod[pin]);
		
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) writeValuePwmDuty:(int)pin
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        Byte t[] = {pin,
            (unsigned char)((pwmDuty[pin] >> 24) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 16) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 8) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 0) & 0xFF)};
		
		[self writeData:[NSData dataWithBytes:t length:5] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_DUTY_UUID];
        KNS_LOG(@"pwmDuty: %d", pwmDuty[pin]);
		
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pwmMode:(int)pin mode:(int)mode
{
	if(pin >= PIO0 && pin <= PIO7 && (mode == KONASHI_PWM_DISABLE || mode == KONASHI_PWM_ENABLE || mode == KONASHI_PWM_ENABLE_LED_MODE )){
        // Set value
        if(mode == KONASHI_PWM_ENABLE || mode == KONASHI_PWM_ENABLE_LED_MODE){
            pwmSetting |= 0x01 << pin;
        }
        else{
            pwmSetting &= ~(0x01 << pin) & 0xFF;
        }
        
        if (mode == KONASHI_PWM_ENABLE_LED_MODE){
            [self pwmPeriod:pin period:KONASHI_PWM_LED_PERIOD];
            [self pwmLedDrive:pin dutyRatio:0.0];
        }
        
        // Write value
        return [self writeValuePwmSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pwmPeriod:(int)pin period:(unsigned int)period
{
	if(pin >= PIO0 && pin <= PIO7 && pwmDuty[pin] <= period){
        pwmPeriod[pin] = period;
        return [self writeValuePwmPeriod:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pwmDuty:(int)pin duty:(unsigned int)duty
{
	if(pin >= PIO0 && pin <= PIO7 && duty <= pwmPeriod[pin]){
        pwmDuty[pin] = duty;
        return [self writeValuePwmDuty:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio
{
	int duty;
    
    if(ratio < 0.0){
        ratio = 0.0;
    }
    if(ratio > 100.0){
        ratio = 100.0;
    }
    
    duty = (int)(KONASHI_PWM_LED_PERIOD * ratio / 100);
    
    return [self pwmDuty:pin duty:duty];
}

- (int) readValueAio:(int)pin
{
    CBUUID *uuid;
	
    if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        if(pin==AIO0){
            uuid = KONASHI_ANALOG_READ0_UUID;
        }
        else if(pin==AIO1){
            uuid = KONASHI_ANALOG_READ1_UUID;
        }
        else{   // AIO2
            uuid = KONASHI_ANALOG_READ2_UUID;
        }
        
		[self readDataWithServiceUUID:KONASHI_SERVICE_UUID characteristicUUID:uuid];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
	
}

- (int) analogReference
{
	return KONASHI_ANALOG_REFERENCE;
}

- (int) analogReadRequest:(int)pin
{
	if(pin >= AIO0 && pin <= AIO2){
        return [self readValueAio:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) analogRead:(int)pin
{
	if(pin >= AIO0 && pin <= AIO2){
        return analogValue[pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) analogWrite:(int)pin milliVolt:(int)milliVolt
{
	if(pin >= AIO0 && pin <= AIO2 && milliVolt >= 0 && milliVolt <= KONASHI_ANALOG_REFERENCE &&
       self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        Byte t[] = {pin, (milliVolt>>8)&0xFF, milliVolt&0xFF};
		[self writeData:[NSData dataWithBytes:t length:3] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_ANALOG_DRIVE_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) i2cMode:(int)mode
{
	if((mode == KONASHI_I2C_DISABLE || mode == KONASHI_I2C_ENABLE ||
		mode == KONASHI_I2C_ENABLE_100K || mode == KONASHI_I2C_ENABLE_400K) &&
       self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        i2cSetting = mode;
        
        Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_CONFIG_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int)i2cSendCondition:(int)condition
{
	if((condition == KONASHI_I2C_START_CONDITION || condition == KONASHI_I2C_RESTART_CONDITION ||
		condition == KONASHI_I2C_STOP_CONDITION) && self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        Byte t = condition;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_START_STOP_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) i2cStartCondition
{
	return [self i2cSendCondition:KONASHI_I2C_START_CONDITION];
}

- (int) i2cRestartCondition
{
	return [self i2cSendCondition:KONASHI_I2C_RESTART_CONDITION];
}

- (int) i2cStopCondition
{
	return [self i2cSendCondition:KONASHI_I2C_STOP_CONDITION];
}

- (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
	int i;
    unsigned char t[KONASHI_I2C_DATA_MAX_LENGTH];
    
    if(length > 0 && (i2cSetting == KONASHI_I2C_ENABLE || i2cSetting == KONASHI_I2C_ENABLE_100K || i2cSetting == KONASHI_I2C_ENABLE_400K) &&
       self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        t[0] = length+1;
        t[1] = (address << 1) & 0b11111110;
        for(i=0; i<length; i++){
            t[i+2] = data[i];
        }
        
		[self writeData:[NSData dataWithBytes:t length:length + 2] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_WRITE_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) i2cReadRequest:(int)length address:(unsigned char)address
{
	if(length > 0 && (i2cSetting == KONASHI_I2C_ENABLE || i2cSetting == KONASHI_I2C_ENABLE_100K || i2cSetting == KONASHI_I2C_ENABLE_400K) &&
       self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        
        // set variables
        i2cReadAddress = (address<<1)|0x1;
        i2cReadDataLength = length;
        
        // Set read params
        Byte t[] = {length, i2cReadAddress};
		[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_PARAM_UIUD];
        
        // Request read i2c value
		[self readDataWithServiceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) i2cRead:(int)length data:(unsigned char*)data
{
	int i;
	
    if(length==i2cReadDataLength){
        for(i=0; i<i2cReadDataLength;i++){
            data[i] = i2cReadData[i];
        }
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) uartMode:(int)mode
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected &&
       ( mode == KONASHI_UART_DISABLE || mode == KONASHI_UART_ENABLE ) ){
        Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_CONFIG_UUID];
        uartSetting = mode;
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) uartBaudrate:(int)baudrate
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KONASHI_UART_DISABLE){
        if(baudrate == KONASHI_UART_RATE_2K4 ||
           baudrate == KONASHI_UART_RATE_9K6
		   ){
            Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
            [self writeData:[NSData dataWithBytes:t length:2] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_BAUDRATE_UUID];
            uartBaudrate = baudrate;
            
            return KONASHI_SUCCESS;
        }
        else{
            return KONASHI_FAILURE;
        }
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) uartWrite:(unsigned char)data
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KONASHI_UART_ENABLE){
		[self writeData:[NSData dataWithBytes:&data length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_TX_UUID];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (unsigned char) uartRead
{
	return uartRxData;
}

- (int) reset
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        Byte t = 1;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_HARDWARE_RESET_UUID];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) batteryLevelReadRequest
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        [self readDataWithServiceUUID:KONASHI_BATT_SERVICE_UUID characteristicUUID:KONASHI_LEVEL_SERVICE_UUID];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) batteryLevelRead
{
	return batteryLevel;
}

- (int) signalStrengthReadRequest
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
        [self.peripheral readRSSI];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) signalStrengthRead
{
	return rssi;
}

- (void)enablePIOInputNotification
{
	[self notificationWithServiceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_INPUT_NOTIFICATION_UUID on:YES];
}

- (void)enableUART_RXNotification
{
	[self notificationWithServiceUUID:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_RX_NOTIFICATION_UUID on:YES];
}

// override
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

    // konashi needs to sleep to get I2C right
    [NSThread sleepForTimeInterval:0.03];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	unsigned char byte[32];
	
	KNS_LOG(@"didUpdateValueForCharacteristic");
	
	if (!error) {
		if ([characteristic.UUID kns_isEqualToUUID: KONASHI_PIO_INPUT_NOTIFICATION_UUID]) {
			[characteristic.value getBytes:&byte length:KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN];
			pioInput = byte[0];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_PIO_INPUT object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_ANALOG_READ0_UUID]) {
			[characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
			analogValue[0] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_ANALOG_READ1_UUID]) {
			[characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
			analogValue[1] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_ANALOG_READ2_UUID]) {
			[characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
			analogValue[2] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_I2C_READ_UUID]) {
			[characteristic.value getBytes:i2cReadData length:i2cReadDataLength];
			// [0]: MSB
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_I2C_READ_COMPLETE object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_UART_RX_NOTIFICATION_UUID]) {
			[characteristic.value getBytes:&uartRxData length:1];
			// [0]: MSB
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UART_RX_COMPLETE object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID: KONASHI_LEVEL_SERVICE_UUID]) {
			[characteristic.value getBytes:&byte length:KONASHI_LEVEL_SERVICE_READ_LEN];
			batteryLevel = byte[0];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_BATTERY_LEVEL object:nil];
		}
	}
}

@end
