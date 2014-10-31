//
//  KoshianPeripheralImpl.m
//  Konashi
//
//  Created by Akira Matsuda on 9/18/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSKoshianPeripheralImpl.h"
#import "KoshianDb.h"
#import "KonashiUtils.h"

@implementation KNSKoshianPeripheralImpl

- (CBPeripheralState)state
{
	return self.peripheral.state;
}

- (NSString *)findName
{
	return self.peripheral.name;
}


- (KonashiResult) writeValuePioSetting
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		KNS_LOG(@"PioSetting: %d", pioSetting);
		
		Byte t = (Byte)pioSetting;
		NSData *d = [[NSData alloc] initWithBytes:&t length:1];
		[self writeData:d serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PIO_SETTING_UUID];
		
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
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PIO_PULLUP_UUID];
		
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
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PIO_OUTPUT_UUID];
		
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
		pioOutput = value;
		
		// Write value
		return [self writeValuePioOutput];
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) writeValuePwmSetting
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		KNS_LOG(@"PwmSetting: %d", pwmSetting);
		
		Byte t = (Byte)pwmSetting;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PWM_CONFIG_UUID];
		
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
		
		[self writeData:[NSData dataWithBytes:t length:5] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PWM_PARAM_UUID];
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
		
		[self writeData:[NSData dataWithBytes:t length:5] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PWM_DUTY_UUID];
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

- (KonashiResult) readValueAio:(KonashiAnalogIOPin)pin
{
	CBUUID *uuid;
	
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
		if(pin==KonashiAnalogIO0){
			uuid = KOSHIAN_ANALOG_READ0_UUID;
		}
		else if(pin==KonashiAnalogIO1){
			uuid = KOSHIAN_ANALOG_READ1_UUID;
		}
		else{   // AIO2
			uuid = KOSHIAN_ANALOG_READ2_UUID;
		}
		
		[self readDataWithServiceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:uuid];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
	
}

- (int) analogReference
{
	return KonashiAnalogReference;
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
	if(pin >= KonashiAnalogIO0 && pin <= KonashiAnalogIO2 && milliVolt >= 0 && milliVolt <= KonashiAnalogReference &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		Byte t[] = {pin, (milliVolt>>8)&0xFF, milliVolt&0xFF};
		[self writeData:[NSData dataWithBytes:t length:3] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_ANALOG_DRIVE_UUID];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) i2cMode:(KonashiI2CMode)mode
{
	if((mode == KonashiI2CModeDisable || mode == KonashiI2CModeEnable ||
		mode == KonashiI2CModeEnable100K || mode == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		i2cSetting = mode;
		
		Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PWM_CONFIG_UUID];
		
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
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_I2C_START_STOP_UUID];
		
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
	unsigned char t[KonashiI2CDataMaxLength];
	
	if(length > 0 && (i2cSetting == KonashiI2CModeEnable || i2cSetting == KonashiI2CModeEnable100K || i2cSetting == KonashiI2CModeEnable400K) &&
	   self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		t[0] = length+1;
		t[1] = (address << 1) & 0b11111110;
		for(i=0; i<length; i++){
			t[i+2] = data[i];
		}
		
		[self writeData:[NSData dataWithBytes:t length:length + 2] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_I2C_WRITE_UUID];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
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
		[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_I2C_READ_PARAM_UIUD];
		
		// Request read i2c value
		[self readDataWithServiceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_I2C_READ_UUID];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) i2cRead:(int)length data:(unsigned char*)data
{
	int i;
	
	if(length==i2cReadDataLength){
		for(i=0; i<i2cReadDataLength;i++){
			data[i] = i2cReadData[i];
		}
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartMode:(KonashiUartMode)mode
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected &&
	   ( mode == KonashiUartModeDisable || mode == KonashiUartModeEnable ) ){
		Byte t = mode;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_UART_CONFIG_UUID];
		uartSetting = mode;
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeDisable){
		if(baudrate == KonashiUartBaudrateRate2K4 ||
		   baudrate == KonashiUartBaudrateRate9K6
		   ){
			Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
			[self writeData:[NSData dataWithBytes:t length:2] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_UART_BAUDRATE_UUID];
			uartBaudrate = baudrate;
			
			return KonashiResultSuccess;
		}
		else{
			return KonashiResultFailure;
		}
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) uartWrite:(unsigned char)data
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected && uartSetting==KonashiUartModeEnable){
		[self writeData:[NSData dataWithBytes:&data length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_UART_TX_UUID];
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (unsigned char) uartRead
{
	return uartRxData;
}

- (KonashiResult) reset
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		Byte t = 1;
		[self writeData:[NSData dataWithBytes:&t length:1] serviceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_HARDWARE_RESET_UUID];
		
		return KonashiResultSuccess;
	}
	else{
		return KonashiResultFailure;
	}
}

- (KonashiResult) batteryLevelReadRequest
{
	if(self.peripheral && self.peripheral.state == CBPeripheralStateConnected){
		[self readDataWithServiceUUID:KOSHIAN_BATT_SERVICE_UUID characteristicUUID:KOSHIAN_LEVEL_SERVICE_UUID];
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
	[self notificationWithServiceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_PIO_INPUT_NOTIFICATION_UUID on:YES];
}

- (void)enableUART_RXNotification
{
	[self notificationWithServiceUUID:KOSHIAN_SERVICE_UUID characteristicUUID:KOSHIAN_UART_RX_NOTIFICATION_UUID on:YES];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	unsigned char byte[32];
	
	KNS_LOG(@"didUpdateValueForCharacteristic");
	
	if (!error) {
		if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_PIO_INPUT_NOTIFICATION_UUID]) {
			[characteristic.value getBytes:&byte length:KOSHIAN_PIO_INPUT_NOTIFICATION_READ_LEN];
			pioInput = byte[0];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_PIO_INPUT object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_ANALOG_READ0_UUID]) {
			[characteristic.value getBytes:&byte length:KOSHIAN_ANALOG_READ_LEN];
			analogValue[0] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_ANALOG_READ1_UUID]) {
			[characteristic.value getBytes:&byte length:KOSHIAN_ANALOG_READ_LEN];
			analogValue[1] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_ANALOG_READ2_UUID]) {
			[characteristic.value getBytes:&byte length:KOSHIAN_ANALOG_READ_LEN];
			analogValue[2] = byte[0]<<8 | byte[1];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2 object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_I2C_READ_UUID]) {
			[characteristic.value getBytes:i2cReadData length:i2cReadDataLength];
			// [0]: MSB
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_I2C_READ_COMPLETE object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_UART_RX_NOTIFICATION_UUID]) {
			[characteristic.value getBytes:&uartRxData length:1];
			// [0]: MSB
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UART_RX_COMPLETE object:nil];
		}
		else if ([characteristic.UUID kns_isEqualToUUID:KOSHIAN_LEVEL_SERVICE_UUID]) {
			[characteristic.value getBytes:&byte length:KOSHIAN_LEVEL_SERVICE_READ_LEN];
			batteryLevel = byte[0];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:KONASHI_EVENT_UPDATE_BATTERY_LEVEL object:nil];
		}
	}

}

@end
