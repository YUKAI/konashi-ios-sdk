//
//  Konashi.m
//
//  Copyright (c) 2012 YUKAI Engineering. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Konashi.h"
#import "KonashiDb.h"

@implementation Konashi

#pragma mark -
#pragma mark - Singleton

+ (Konashi *) shared
{
    static Konashi *_konashi = nil;
    
    @synchronized (self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            _konashi = [[Konashi alloc] init];
        });
    }
    
    return _konashi;
}




#pragma mark -
#pragma mark - Konashi control public methods

+ (int) initialize
{
    return [[Konashi shared] _initializeKonashi];
}

+ (int) find
{
    return [[Konashi shared] _findModule:2];
}

+ (int) findWithName:(NSString*)name
{
    return [[Konashi shared] _findModuleWithName:name timeout:2];
}

+ (int) disconnect
{
    return [[Konashi shared] _disconnectModule];
}

+ (BOOL) isConnected
{
    return [[Konashi shared] _isConnected];
}

+ (BOOL) isReady
{
    return [[Konashi shared] _isReady];
}



#pragma mark -
#pragma mark - Konashi PIO public methods

+ (int) pinMode:(int)pin mode:(int)mode
{    
    return [[Konashi shared] _pinMode:pin mode:mode];
}

+ (int) pinModeAll:(int)mode
{
    return [[Konashi shared] _pinModeAll:mode];
}

+ (int) pinPullup:(int)pin mode:(int)mode
{
    return [[Konashi shared] _pinPullup:pin mode:mode];
}

+ (int) pinPullupAll:(int)mode
{
    return [[Konashi shared] _pinPullupAll:mode];
}

+ (int) digitalRead:(int)pin
{
    return [[Konashi shared] _digitalRead:pin];
}

+ (int) digitalReadAll
{
    return [[Konashi shared] _digitalReadAll];
}

+ (int) digitalWrite:(int)pin value:(int)value
{
    return [[Konashi shared] _digitalWrite:pin value:value];
}

+ (int) digitalWriteAll:(int)value
{
    return [[Konashi shared] _digitalWriteAll:value];
}




#pragma mark -
#pragma mark - Konashi PWM public methods

+ (int) pwmMode:(int)pin mode:(int)mode
{
    return [[Konashi shared] _pwmMode:pin mode:mode];
}

+ (int) pwmPeriod:(int)pin period:(unsigned int)period
{
    return [[Konashi shared] _pwmPeriod:pin period:period];
}

+ (int) pwmDuty:(int)pin duty:(unsigned int)duty
{
    return [[Konashi shared] _pwmDuty:pin duty:duty];
}

+ (int) pwmLedDrive:(int)pin dutyRatio:(int)ratio
{
    return [[Konashi shared] _pwmLedDrive:pin dutyRatio:ratio];
}




#pragma mark -
#pragma mark - Konashi analog IO public methods

+ (int) analogReference
{
    return KONASHI_ANALOG_REFERENCE;
}

+ (int) analogReadRequest:(int)pin
{
    return [[Konashi shared] _analogReadRequest:pin];
}

+ (int) analogRead:(int)pin
{
    return [[Konashi shared] _analogRead:pin];
}

+ (int) analogWrite:(int)pin milliVolt:(int)milliVolt
{
    return [[Konashi shared] _analogWrite:pin milliVolt:(int)milliVolt];
}




#pragma mark -
#pragma mark - Konashi I2C public methods

+ (int) i2cMode:(int)mode
{
    return [[Konashi shared] _i2cMode:mode];
}

+ (int) i2cStartCondition
{
    return [[Konashi shared] _i2cSendCondition:KONASHI_I2C_START_CONDITION];
}

+ (int) i2cRestartCondition
{
    return [[Konashi shared] _i2cSendCondition:KONASHI_I2C_RESTART_CONDITION];
}

+ (int) i2cStopCondition
{
    return [[Konashi shared] _i2cSendCondition:KONASHI_I2C_STOP_CONDITION];
}

+ (int) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
    return [[Konashi shared] _i2cWrite:length data:data address:address];
}

+ (int) i2cReadRequest:(int)length address:(unsigned char)address
{
    return [[Konashi shared] _i2cReadRequest:length address:address];
}

+ (int) i2cRead:(int)length data:(unsigned char*)data
{
    return [[Konashi shared] _i2cRead:length data:data];
}




#pragma mark -
#pragma mark - Konashi UART public methods

+ (int) uartMode:(int)mode
{
    return [[Konashi shared] _uartMode:mode];
}

+ (int) uartBaudrate:(int)baudrate
{
    return [[Konashi shared] _uartBaudrate:baudrate];
}

+ (int) uartWrite:(unsigned char)data
{
    return [[Konashi shared] _uartWrite:data];
}

+ (unsigned char) uartRead
{
    return [[Konashi shared] _uartRead];
}




#pragma mark -
#pragma mark - Konashi hardware public methods

+ (int) reset
{
    return [[Konashi shared] _resetModule];
}

+ (int) batteryLevelReadRequest
{
    return [[Konashi shared] _batteryLevelReadRequest];
}

+ (int) batteryLevelRead
{
    return [[Konashi shared] _batteryLevelRead];
}

+ (int) signalStrengthReadRequest
{
    return [[Konashi shared] _signalStrengthReadRequest];
}

+ (int) signalStrengthRead
{
    return [[Konashi shared] _signalStrengthRead];
}





#pragma mark -
#pragma mark - Konashi public event methods

+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:notificationObserver selector:notificationSelector name:notificationName object:nil];
}

+ (void) removeObserver:(id)notificationObserver
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:notificationObserver];
}

#pragma mark -
#pragma mark - Konashi private event methods

- (void) postNotification:(NSString*)notificationName
{
    NSNotification *n = [NSNotification notificationWithName:notificationName object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}




#pragma mark -
#pragma mark - Konashi control private methods

- (int) _initializeKonashi
{
    cm = [[CBCentralManager alloc] initWithDelegate:[Konashi shared] queue:nil];
    
    [self _initializeKonashiVariables];
    
    return KONASHI_SUCCESS;
}

- (void) _initializeKonashiVariables
{
    int i;
    
    // Digital PIO
    pioSetting = 0;
    pioPullup = 0;
    pioInput = 0;
    pioOutput = 0;
    
    // PWM
    pwmSetting = 0;
    for(i=0; i<8; i++){
        pwmPeriod[i] = 0;
        pwmDuty[i] = 0;
    }
    
    // Analog IO
    for(i=0; i<3; i++){
        analogValue[i] = 0;
    }
    
    // I2C
    i2cSetting = KONASHI_I2C_DISABLE;
    for(i=0; i<KONASHI_I2C_DATA_MAX_LENGTH; i++){
        i2cReadData[i] = 0;
    }
    i2cReadDataLength = 0;
    i2cReadAddress = 0;
    
    // UART
    uartSetting = KONASHI_UART_DISABLE;
    uartBaudrate = KONASHI_UART_RATE_9K6;
    
    // RSSI
    rssi = 0;
    
    // others
    isReady = NO;
}

- (int) _findModule:(int) timeout
{
    if(activePeripheral && activePeripheral.isConnected){
        [cm cancelPeripheralConnection:activePeripheral];
    }
    if(peripherals) peripherals = nil;
    
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %d (%@)", cm.state, [self centralManagerStateToString:cm.state]);
        return KONASHI_FAILURE;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModule:) userInfo:nil repeats:NO];
    
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KONASHI_SUCCESS;
}

- (int) _findModuleWithName:(NSString*)name timeout:(int)timeout{
    if(activePeripheral && activePeripheral.isConnected){
        [cm cancelPeripheralConnection:activePeripheral];
    }
    if(peripherals) peripherals = nil;
    
    if (cm.state  != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %d (%@)", cm.state, [self centralManagerStateToString:cm.state]);
        return KONASHI_FAILURE;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModuleWithName:) userInfo:name repeats:NO];

        
    [cm scanForPeripheralsWithServices:nil options:0];
    
    return KONASHI_SUCCESS;
}

- (void) finishScanModuleWithName:(NSTimer *)timer
{
    [cm stopScan];
    NSString *targetname = [timer userInfo];
    KNS_LOG(@"Peripherals: %d", [peripherals count]);
    BOOL targetIsExist = NO;
    int indexOfTarget = 0;
    if ( [peripherals count] > 0 ) {
        for (int i = 0; i < [peripherals count]; i++) {
            if ([[[peripherals objectAtIndex:i] name] isEqualToString:targetname]) {
                targetIsExist = YES;
                indexOfTarget = i;
            }
        }
    }
    if (targetIsExist) {
        [self connectTargetPeripheral:indexOfTarget];
    }
}

- (void) finishScanModule:(NSTimer *)timer
{
    [cm stopScan];
    
    KNS_LOG(@"Peripherals: %d", [peripherals count]);
    
    if ( [peripherals count] > 0 ) {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            [self showModulePickeriPad];    //iPad
        } else {
            [self showModulePicker];        //else
        }
    }
}

- (void) connectPeripheral:(CBPeripheral *)peripheral
{
#ifdef KONASHI_DEBUG
    NSString* name = peripheral.name;
    KNS_LOG(@"Connecting %@(UUID: %@)", name, [self UUIDToString:peripheral.UUID]);
#endif
    
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    [cm connectPeripheral:activePeripheral options:nil];
}

- (void) readyModule
{
    CBPeripheral *p = activePeripheral;
    
    // set konashi property
    isReady = YES;
    
    [[Konashi shared] postNotification:KONASHI_EVENT_READY];
    
    // Enable PIO input notification
    [self notification:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PIO_INPUT_NOTIFICATION_UUID p:p on:YES];
    
    // Enable UART RX notification
    [self notification:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_RX_NOTIFICATION_UUID p:p on:YES];
}

- (int) _disconnectModule
{
    if(activePeripheral && activePeripheral.isConnected){
        [cm cancelPeripheralConnection:activePeripheral];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (BOOL) _isConnected
{
    return (activePeripheral && activePeripheral.isConnected);
}

- (BOOL) _isReady
{
    return isReady;
}



#pragma mark -
#pragma mark - Konashi PIO private methods

- (int) _pinMode:(int)pin mode:(int)mode
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
        return [self _writeValuePioSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _pinModeAll:(int)mode
{
    if(mode >= 0x00 && mode <= 0xFF){
        // Set value
        pioSetting = mode;
        
        // Write value
        return [self _writeValuePioSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePioSetting
{
    if(activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PioSetting: %d", pioSetting);
        
        Byte t = (Byte)pioSetting;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_SETTING_UUID
                       p:activePeripheral
                    data:d];
                
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}


- (int) _pinPullup:(int)pin mode:(int)mode
{
    if(pin >= PIO0 && pin <= PIO7 && (mode == PULLUP || mode == NO_PULLS)){
        // Set value
        if(mode == PULLUP){
            pioPullup |= 0x01 << pin;
        } else {
            pioPullup &= ~(0x01 << pin) & 0xFF;
        }
        
        // Write value
        return [self _writeValuePioPullup];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _pinPullupAll:(int)mode
{
    if(mode >= 0x00 && mode <= 0xFF){
        // Set value
        pioPullup = mode;
        
        // Write value
        return [self _writeValuePioPullup];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePioPullup
{
    if(activePeripheral && activePeripheral.isConnected){
        KNS_LOG(@"PioPullup: %d", pioPullup);

        Byte t = (Byte)pioPullup;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_PULLUP_UUID
                       p:activePeripheral
                    data:d];
                
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}


- (int) _digitalRead:(int)pin
{
    if(pin >= PIO0 && pin <= PIO7){
        return (pioInput >> pin) & 0x01;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _digitalReadAll
{
    return pioInput;
}


- (int) _digitalWrite:(int)pin value:(int)value
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
        return [self _writeValuePioOutput];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _digitalWriteAll:(int)value
{
    if(value >= 0x00 && value <= 0xFF){
        // Set value
        pioOutput = value;
        
        // Write value
        return [self _writeValuePioOutput];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePioOutput
{
    if(activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PioOutput: %d", pioOutput);
        
        Byte t = (Byte)pioOutput;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PIO_OUTPUT_UUID
                       p:activePeripheral
                    data:d];
                
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}




#pragma mark -
#pragma mark - Konashi PWM private methods

- (int) _pwmMode:(int)pin mode:(int)mode
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
            [self _pwmPeriod:pin period:KONASHI_PWM_LED_PERIOD];
            [self _pwmLedDrive:pin dutyRatio:0.0];
        }
        
        // Write value
        return [[Konashi shared] _writeValuePwmSetting];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePwmSetting
{
    if(activePeripheral && activePeripheral.isConnected) {
        KNS_LOG(@"PwmSetting: %d", pwmSetting);
        
        Byte t = (Byte)pwmSetting;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_PWM_CONFIG_UUID
                       p:activePeripheral
                    data:d];
                
        return KONASHI_SUCCESS;
    } else {
        return KONASHI_FAILURE;
    }
}


- (int) _pwmPeriod:(int)pin period:(unsigned int)period
{
    if(pin >= PIO0 && pin <= PIO7 && pwmDuty[pin] <= period){
        pwmPeriod[pin] = period;
        return [self _writeValuePwmPeriod:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePwmPeriod:(int)pin
{
    if(activePeripheral && activePeripheral.isConnected) {
        Byte t[] = {pin,
                    (unsigned char)((pwmPeriod[pin] >> 24) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 16) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 8) & 0xFF),
                    (unsigned char)((pwmPeriod[pin] >> 0) & 0xFF)};
        
        NSData *d = [[NSData alloc] initWithBytes:t length:5];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_PARAM_UUID p:activePeripheral data:d];
        
        KNS_LOG(@"PwmPeriod: %d", pwmPeriod[pin]);

        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}


- (int) _pwmDuty:(int)pin duty:(unsigned int)duty
{
    if(pin >= PIO0 && pin <= PIO7 && duty <= pwmPeriod[pin]){
        pwmDuty[pin] = duty;
        return [self _writeValuePwmDuty:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _writeValuePwmDuty:(int)pin
{
    if(activePeripheral && activePeripheral.isConnected) {
        Byte t[] = {pin,
            (unsigned char)((pwmDuty[pin] >> 24) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 16) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 8) & 0xFF),
            (unsigned char)((pwmDuty[pin] >> 0) & 0xFF)};

        NSData *d = [[NSData alloc] initWithBytes:t length:5];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_PWM_DUTY_UUID p:activePeripheral data:d];
        
        KNS_LOG(@"pwmDuty: %d", pwmDuty[pin]);

        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _pwmLedDrive:(int)pin dutyRatio:(float)ratio
{
    int duty;
    
    if(ratio < 0.0){
        ratio = 0.0;
    }
    if(ratio > 100.0){
        ratio = 100.0;
    }
    
    duty = (int)(KONASHI_PWM_LED_PERIOD * ratio / 100);
    
    return [self _pwmDuty:pin duty:duty];
}




#pragma mark -
#pragma mark - Konashi analog IO private methods

- (int) _analogReadRequest:(int)pin
{    
    if(pin >= AIO0 && pin <= AIO2){
        return [self _readValueAio:pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _readValueAio:(int)pin
{
    int uuid;

    if(activePeripheral && activePeripheral.isConnected) {
        if(pin==AIO0){
            uuid = KONASHI_ANALOG_READ0_UUID;
        }
        else if(pin==AIO1){
            uuid = KONASHI_ANALOG_READ1_UUID;
        }
        else{   // AIO2
            uuid = KONASHI_ANALOG_READ2_UUID;
        }
        
        [self readValue:KONASHI_SERVICE_UUID characteristicUUID:uuid p:activePeripheral];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }

}

- (int) _analogRead:(int)pin
{
    if(pin >= AIO0 && pin <= AIO2){
        return analogValue[pin];
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _analogWrite:(int)pin milliVolt:(int)milliVolt
{
    if(pin >= AIO0 && pin <= AIO2 && milliVolt >= 0 && milliVolt <= KONASHI_ANALOG_REFERENCE &&
       activePeripheral && activePeripheral.isConnected){
        Byte t[] = {pin, (milliVolt>>8)&0xFF, milliVolt&0xFF};
        NSData *d = [[NSData alloc] initWithBytes:t length:3];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_ANALOG_DRIVE_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}




#pragma mark -
#pragma mark - Konashi I2C private methods

- (int) _i2cMode:(int)mode
{
    if((mode == KONASHI_I2C_DISABLE || mode == KONASHI_I2C_ENABLE ||
       mode == KONASHI_I2C_ENABLE_100K || mode == KONASHI_I2C_ENABLE_400K) &&
       activePeripheral && activePeripheral.isConnected){
        i2cSetting = mode;
        
        Byte t = mode;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_CONFIG_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _i2cSendCondition:(int)condition
{
    if((condition == KONASHI_I2C_START_CONDITION || condition == KONASHI_I2C_RESTART_CONDITION ||
       condition == KONASHI_I2C_STOP_CONDITION) && activePeripheral && activePeripheral.isConnected){
        Byte t = condition;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_START_STOP_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address
{
    int i;
    unsigned char t[KONASHI_I2C_DATA_MAX_LENGTH];
    
    if(length > 0 && (i2cSetting == KONASHI_I2C_ENABLE || i2cSetting == KONASHI_I2C_ENABLE_100K || i2cSetting == KONASHI_I2C_ENABLE_400K) &&
       activePeripheral && activePeripheral.isConnected){
        t[0] = length+1;
        t[1] = (address << 1) & 0b11111110;
        for(i=0; i<length; i++){
            t[i+2] = data[i];
        }
        
        NSData *d = [[NSData alloc] initWithBytes:t length:length+2];
        
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_WRITE_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _i2cReadRequest:(int)length address:(unsigned char)address
{
    if(length > 0 && (i2cSetting == KONASHI_I2C_ENABLE || i2cSetting == KONASHI_I2C_ENABLE_100K || i2cSetting == KONASHI_I2C_ENABLE_400K) &&
       activePeripheral && activePeripheral.isConnected){
        
        // set variables
        i2cReadAddress = (address<<1)|0x1;
        i2cReadDataLength = length;
        
        // Set read params
        Byte t[] = {length, i2cReadAddress};
        NSData *d = [[NSData alloc] initWithBytes:t length:2];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_PARAM_UIUD p:activePeripheral data:d];
        
        // Request read i2c value
        [self readValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_I2C_READ_UUID p:activePeripheral];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _i2cRead:(int)length data:(unsigned char*)data
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




#pragma mark -
#pragma mark - Konashi UART private methods


- (int) _uartMode:(int)mode
{
    if(activePeripheral && activePeripheral.isConnected &&
       ( mode == KONASHI_UART_DISABLE || mode == KONASHI_UART_ENABLE ) ){
        Byte t = mode;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID
      characteristicUUID:KONASHI_UART_CONFIG_UUID
                       p:activePeripheral
                    data:d];
        
        uartSetting = mode;
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _uartBaudrate:(int)baudrate
{
    if(activePeripheral && activePeripheral.isConnected && uartSetting==KONASHI_UART_DISABLE){
        if(baudrate == KONASHI_UART_RATE_2K4 ||
           baudrate == KONASHI_UART_RATE_9K6
        ){
            Byte t[] = {(baudrate>>8)&0xff, baudrate&0xff};
            NSData *d = [[NSData alloc] initWithBytes:t length:2];
            [self writeValue:KONASHI_SERVICE_UUID
          characteristicUUID:KONASHI_UART_BAUDRATE_UUID
                           p:activePeripheral
                        data:d];
            
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

- (int) _uartWrite:(unsigned char)data
{    
    if(activePeripheral && activePeripheral.isConnected && uartSetting==KONASHI_UART_ENABLE){
        
        NSData *d = [[NSData alloc] initWithBytes:&data length:1];
        
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_UART_TX_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (unsigned char) _uartRead
{
    return uartRxData;
}




#pragma mark -
#pragma mark - Konashi hardware private methods

- (int) _resetModule
{
    if(activePeripheral && activePeripheral.isConnected){
        Byte t = 1;
        NSData *d = [[NSData alloc] initWithBytes:&t length:1];
        [self writeValue:KONASHI_SERVICE_UUID characteristicUUID:KONASHI_HARDWARE_RESET_UUID p:activePeripheral data:d];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _batteryLevelReadRequest
{
    if(activePeripheral && activePeripheral.isConnected){
        [self readValue:KONASHI_BATT_SERVICE_UUID characteristicUUID:KONASHI_LEVEL_SERVICE_UUID p:activePeripheral];
        
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _batteryLevelRead
{
    return batteryLevel;
}

- (int) _signalStrengthReadRequest
{
    if(activePeripheral && activePeripheral.isConnected){
        [activePeripheral readRSSI];
        return KONASHI_SUCCESS;
    }
    else{
        return KONASHI_FAILURE;
    }
}

- (int) _signalStrengthRead
{
    return rssi;
}






#pragma mark -
#pragma mark - Konashi module picker methods

- (void) showModulePicker
{    
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Select Module"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
    
    // Add the picker
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[toolBar sizeToFit];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = @"Select";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:24];
    [label sizeToFit];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushPickerCancel)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPickerDone)];
	
    NSArray *items = [NSArray arrayWithObjects:cancel, spacer, title, spacer, done, nil];
	[toolBar setItems:items animated:YES];
    
    [pickerViewPopup addSubview:toolBar];
    [pickerViewPopup addSubview:picker];
    [pickerViewPopup showInView:rootView];
    
    [pickerViewPopup setBounds:CGRectMake(0, 0, 320, 464)];
}


#pragma mark -
#pragma mark - Konashi module picker methods

- (void) showModulePickeriPad
{
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    
    // Add the picker
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[toolBar sizeToFit];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = @"Select";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    
	UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pushPickerCancel_pad)];
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacer.width=60;
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushPickerDone_pad)];
	
    NSArray *items = [NSArray arrayWithObjects:cancel, spacer, title, spacer, done, nil];
	[toolBar setItems:items animated:YES];
    [toolBar sizeToFit];
    
    UIViewController *pickerViewController;
    pickerViewController=[[UIViewController alloc] init];
    [pickerViewController.view addSubview:toolBar];
    [pickerViewController.view addSubview:picker.viewForBaselineLayout];
    
    pickerViewPopup_pad = [[UIPopoverController alloc] initWithContentViewController: pickerViewController];
    
    [pickerViewPopup_pad presentPopoverFromRect:CGRectMake(0, 0, 10, 10) inView:rootView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [peripherals count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *module[64];
    
    for(int i = 0; i < peripherals.count; i++) {
        CBPeripheral *p = [peripherals objectAtIndex:i];
        module[i] = p.name;
    }
    
    return module[row];
}

- (void) pushPickerCancel
{
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)connectTargetPeripheral:(int)indexOfTarget{
    

    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:indexOfTarget] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:indexOfTarget]];
}

- (void) pushPickerDone
{
    [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    
    NSInteger selectedIndex = [picker selectedRowInComponent:0];
    
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:selectedIndex] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:selectedIndex]];
}

- (void) pushPickerCancel_pad
{
    [pickerViewPopup_pad dismissPopoverAnimated:YES];
}

- (void) pushPickerDone_pad
{
    [pickerViewPopup_pad dismissPopoverAnimated:YES];
    
    NSInteger selectedIndex = [picker selectedRowInComponent:0];
    
    KNS_LOG(@"Select %@", [[peripherals objectAtIndex:selectedIndex] name]);
    
    [self connectPeripheral:[peripherals objectAtIndex:selectedIndex]];
}


#pragma mark -
#pragma mark - Konashi BLE methods

- (NSString*) centralManagerStateToString: (int)state
{
    switch(state) {
        case CBCentralManagerStateUnknown:
            return @"State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return @"State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return @"State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return @"State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return @"State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return @"State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return @"State unknown";
    }
    
    return @"Unknown state";
}


-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    [NSThread sleepForTimeInterval:0.03];
}

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@\r\n", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
}

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
        
    if (!service) {
        KNS_LOG(@"Could not find service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        KNS_LOG(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", [self CBUUIDToString:cu], [self CBUUIDToString:su], [self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    KNS_LOG(@"Status of CoreBluetooth central manager changed %d (%@)\r\n", central.state, [self centralManagerStateToString:central.state]);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    KNS_LOG(@"didDiscoverPeripheral");

    if (!peripherals){
        peripherals = [NSMutableArray array];
    }
    
    for(int i = 0; i < peripherals.count; i++) {
        CBPeripheral *p = [peripherals objectAtIndex:i];
        
        if ([self UUIDSAreEqual:p.UUID u2:peripheral.UUID]) {
            [peripherals replaceObjectAtIndex:i withObject:peripheral];
            KNS_LOG(@"Duplicate UUID found updating ...");
            return;
        }
    }

    [self->peripherals addObject:peripheral];    
    KNS_LOG(@"New UUID, adding:%@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    KNS_LOG(@"Connect to peripheral with UUID : %@ successfull", [self UUIDToString:peripheral.UUID]);
    
    activePeripheral = peripheral;
    
    [[Konashi shared] postNotification:KONASHI_EVENT_CONNECTED];

    [activePeripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    KNS_LOG(@"Disconnect from the peripheral: %@", [peripheral name]);
    
    [[Konashi shared] _initializeKonashiVariables];
    
    [[Konashi shared] postNotification:KONASHI_EVENT_DISCONNECTED];
}

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2
{
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}

-(void) getAllServicesFromMoudle:(CBPeripheral *)p
{
    [p discoverServices:nil]; // Discover all services without filter
}

-(void) getAllCharacteristicsFromMoudle:(CBPeripheral *)p
{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        KNS_LOG(@"Fetching characteristics for service with UUID : %@", [self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}

- (NSString*) CBUUIDToString:(CBUUID *) UUID
{
    return [UUID.data description];
}

- (NSString*) UUIDToString:(CFUUIDRef)UUID
{
    if (!UUID) return @"NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return (__bridge NSString *)s;
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

- (int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2
{
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}

- (UInt16) CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

- (CBUUID*) IntToCBUUID:(UInt16)UUID
{
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}

- (CBService*) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil;
}

- (CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil;
}

- (UInt16) swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        KNS_LOG(@"Characteristics of service with UUID : %@ found", [self CBUUIDToString:service.UUID]);

#ifdef KONASHI_DEBUG
        for(int i=0; i < service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            KNS_LOG(@"Found characteristic %@", [self CBUUIDToString:c.UUID]);
        }
#endif
        
        CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
        if([self compareCBUUID:service.UUID UUID2:s.UUID]) {
            KNS_LOG(@"Finished discovering all services' characteristics");
            [self readyModule];
        }
    }
    else {
        KNS_LOG(@"ERROR: Characteristic discorvery unsuccessfull!");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        KNS_LOG(@"Services of peripheral with UUID : %@ found", [self UUIDToString:peripheral.UUID]);
        [self getAllCharacteristicsFromMoudle:peripheral];
    }
    else {
        KNS_LOG(@"Service discovery was unsuccessfull !");
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{    
    KNS_LOG(@"didUpdateNotificationStateForCharacteristic");
    
    if (!error) {
        KNS_LOG(@"Updated notification state for characteristic with UUID %@ on service with  UUID %@ on peripheral with UUID %@",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID], [self UUIDToString:peripheral.UUID]);
    }
    else {
        KNS_LOG(@"Error in setting notification state for characteristic with UUID %@ on service with  UUID %@ on peripheral with UUID %@",[self CBUUIDToString:characteristic.UUID], [self CBUUIDToString:characteristic.service.UUID], [self UUIDToString:peripheral.UUID]);
        KNS_LOG(@"Error code was %@", [error description]);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    unsigned char byte[32];
    
    KNS_LOG(@"didUpdateValueForCharacteristic");
    
    if (!error) {
        switch(characteristicUUID){
            case KONASHI_PIO_INPUT_NOTIFICATION_UUID:
            {
                [characteristic.value getBytes:&byte length:KONASHI_PIO_INPUT_NOTIFICATION_READ_LEN];
                pioInput = byte[0];
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_PIO_INPUT];
                
                break;
            }

            case KONASHI_ANALOG_READ0_UUID:
            {
                [characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
                analogValue[0] = byte[0]<<8 | byte[1];
                
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO0];
                
                break;
            }
                
            case KONASHI_ANALOG_READ1_UUID:
            {
                [characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
                analogValue[1] = byte[0]<<8 | byte[1];
                
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO1];
                
                break;
            }
                
                
            case KONASHI_ANALOG_READ2_UUID:
            {
                [characteristic.value getBytes:&byte length:KONASHI_ANALOG_READ_LEN];
                analogValue[2] = byte[0]<<8 | byte[1];
                
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE];
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_ANALOG_VALUE_AIO2];
                
                break;
            }
                
            case KONASHI_I2C_READ_UUID:
            {
                [characteristic.value getBytes:i2cReadData length:i2cReadDataLength];
                 // [0]: MSB
                                
                [[Konashi shared] postNotification:KONASHI_EVENT_I2C_READ_COMPLETE];
                
                break;
            }
                
            case KONASHI_UART_RX_NOTIFICATION_UUID:
            {
                [characteristic.value getBytes:&uartRxData length:1];
                // [0]: MSB
                
                [[Konashi shared] postNotification:KONASHI_EVENT_UART_RX_COMPLETE];
                
                break;
            }
                
            case KONASHI_LEVEL_SERVICE_UUID:
            {
                [characteristic.value getBytes:&byte length:KONASHI_LEVEL_SERVICE_READ_LEN];
                batteryLevel = byte[0];
                
                [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_BATTERY_LEVEL];
                
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    KNS_LOG(@"didUpdateValueForDescriptor");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    KNS_LOG(@"didWriteValueForCharacteristic");
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    KNS_LOG(@"didWriteValueForDescriptor");
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //KNS_LOG(@"peripheralDidUpdateRSSI");
    
    rssi = [peripheral.RSSI intValue];
    
    [[Konashi shared] postNotification:KONASHI_EVENT_UPDATE_SIGNAL_STRENGTH];
}




@end
