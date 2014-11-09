/* ========================================================================
 * Konashi.h
 *
 * http://konashi.ux-xu.com
 * ========================================================================
 * Copyright 2013 Yukai Engineering Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================================== */


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "KonashiConstant.h"
#import "KNSPeripheralImpls.h"
#import "KNSPeripheral.h"
#import "KNSHandlerManager.h"

// Konashi interface
@interface Konashi : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	NSString *findName;
	BOOL isReady;
	BOOL isCallFind;
    NSMutableArray *peripherals;
    CBCentralManager *cm;
	
	KNSHandlerManager *handlerManager;
}

@property (nonatomic, readonly) KNSPeripheral *activePeripheral;

/**
 *  このHandlerはKonashiが接続された際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler connectedHandler;

/**
 *  このHandlerはKonashiが切断された際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler disconnectedHandler;

/**
 *  このHandlerはKonashiが使用可能状態になった際に呼び出されます。
 */
@property (nonatomic, copy) KonashiEventHandler readyHandler;

/**
 *  このHandlerはKonashiPinModeInputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalInputDidChangeValueHandler;

/**
 *  このHandlerはKonashiPinModeOutputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiDigitalPinDidChangeValueHandler digitalOutputDidChangeValueHandler;

/**
 *  このHandlerはAIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiAnalogPinDidChangeValueHandler analogPinDidChangeValueHandler;

/**
 *  このHandlerはUartで値を受信した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiUartRxCompleteHandler uartRxCompleteHandler;

/**
 *  このHandlerはI2Cで接続されたモジュールからデータを読みだした際に呼び出されます。
 */
@property (nonatomic, copy) KonashiI2CReadCompleteHandler i2cReadCompleteHandler;

/**
 *  このHandlerはバッテリー残量の値を取得した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiBatteryLevelDidUpdateHandler batteryLevelDidUpdateHandler;

/**
 *  このHandlerはRSSIが変化した際に呼び出されます。
 */
@property (nonatomic, copy) KonashiSignalStrengthDidUpdateHandler signalStrengthDidUpdateHandler;

// Singleton
+ (Konashi *) shared;

/**
 *  konashiの初期化を行います。
 *
 *	@warning 一番最初に表示されるViewControllerのviewDidLoadなど、konashiを使う前に必ず initialize をしてください。
 *
 *  @return 初期化した場合はKonashiResultSuccess、既に初期化されていた場合はKonashiResultFailure。
 */
+ (KonashiResult) initialize;

/**
 *  iPhone周辺のkonashiを探します。
 *	この関数を実行した後、周りにあるkonashiのリストが出現します。リストに列挙されているkonashiのひとつをクリックすると、konashiに自動的に接続されます。その後、KonashiEventConnectedNotification と KonashiEventReadyToUseNotification のイベントが発行されます。
 *
 *	@warning 本来、KonashiEventCentralManagerPowerOnNotification のイベント以前に find を実行しても無効ですが、この場合に限り、KonashiEventCentralManagerPowerOnNotification のイベント後に自動的に find が遅延実行されるように調整されています。
 *
 *  @return 探索が開始された場合はKonashiResultSuccess、既に接続されている場合はKonashiResultFailure。
 */
+ (KonashiResult) find;

/**
 *  konashiの名前を指定して接続します。
 *	find の場合はkonashiのリストが出現しますが、findWithName を実行した場合はリストが出ずに自動的に接続されます。
 *	名前に関しては、find を実行することによって下から出現するリストでリストアップされる konashi#4-0452 などの文字列です。konashi#*-**** の*部分の数字は、konashiの緑色チップのシール上に記載されている番号と同じです。
 *	もし、指定した名前が見つからない場合は KonashiEventPeripheralNotFoundNotification が発行されます。
 *
 *	@warning 本来、KonashiEventCentralManagerPowerOnNotification のイベント以前に findWithName を実行しても無効ですが、この場合に限り、KonashiEventCentralManagerPowerOnNotification のイベント後に自動的に findWithName が遅延実行されるように調整されています。
 *
 *  @param name 接続したいkonashiの名前。例："konashi#4-0452"
 *
 *  @return 探索が開始された場合はKonashiResultSuccess、既に接続されている場合はKonashiResultFailure。
 */
+ (KonashiResult) findWithName:(NSString*)name;

/**
 *  konashiとの接続を解除します。
 *
 *  @return 切断した場合はKonashiResultSuccess、すでに切断されている及び何らかの原因で失敗した場合はKonashiResultFailure。
 */
+ (KonashiResult) disconnect;

/**
 *  konashiと接続中かを返します。
 *
 *  @return 接続されている場合はYES、されていない場合はNO。
 */
+ (BOOL) isConnected;

/**
 *  konashiに接続完了しているかを返します。
 *
 *  @return 接続完了している場合はYES、していない場合はNO.
 */
+ (BOOL) isReady;

/**
 *  接続中のkonashiの名前を返します。
 *	konashiに接続していない状態で peripheralName を実行すると空文字 @"" が返ります。
 *
 *  @return 接続しているkonashiの名前。
 */
+ (NSString *)peripheralName;

/**
 *  PIOのピンを入力として使うか、出力として使うかの設定を行います。
 *
 *  @param pin  設定するPIOのピン名。
 *  @param mode ピンに設定するモード。
 *
 *  @return 設定に成功した場合はKonashiResultSuccess、何らかの原因で失敗した場合はKonashiResultFailure。
 */
+ (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;

/**
 *  PIOのピンを入力として使うか、出力として使うかの設定を行います。
 *	それぞれのビットでは、入力設定を0、出力設定を1として表現します。
 *	この関数での引数は、PIO0〜PIO7の入出力設定を8bit(1byte)で表現します。
 *
 *  @param mode PIO0 〜 PIO7 の計8ピンの設定。
 *
 *  @return 設定に成功した場合はKonashiResultSuccess、何らかの原因で失敗した場合はKonashiResultFailure。
 */
+ (KonashiResult) pinModeAll:(int)mode;

/**
 *  PIOのピンをプルアップするかの設定を行います。
 *	初期状態では、PIOはプルアップされていません(NO_PULLS)。
 *
 *  @param pin  設定するPIOのピン名。
 *  @param mode ピンをプルアップするかの設定。
 *
 *  @return 設定に成功した場合はKonashiResultSuccess、何らかの原因で失敗した場合はKonashiResultFailure。
 */
+ (KonashiResult) pinPullup:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;

/**
 *  PIOのピンをプルアップするかの設定を行います。
 *	この関数での引数は、PIO0〜PIO7のプルアップ設定を8bit(1byte)で表現します。
 *
 *  @param mode 設定するPIOのピン名。
 *
 *  @return PIO0 〜 PIO7 の計8ピンのプルアップの設定。
 */
+ (KonashiResult) pinPullupAll:(int)mode;

// PWM methods
+ (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;
+ (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;
+ (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;
+ (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

// Analog IO methods
+ (int) analogReference;
+ (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;
+ (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;

// I2C methods
+ (KonashiResult) i2cMode:(KonashiI2CMode)mode;
+ (KonashiResult) i2cStartCondition;
+ (KonashiResult) i2cRestartCondition;
+ (KonashiResult) i2cStopCondition;
+ (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address;
+ (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;

// UART methods
+ (KonashiResult) uartMode:(KonashiUartMode)mode;
+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate;
+ (KonashiResult) uartWrite:(unsigned char)data;

// Konashi hardware methods
+ (KonashiResult) reset;
+ (KonashiResult) batteryLevelReadRequest;
+ (KonashiResult) signalStrengthReadRequest;

// Konashi event methods
+ (void) addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString*)notificationName;
+ (void) removeObserver:(id)notificationObserver;

@end
