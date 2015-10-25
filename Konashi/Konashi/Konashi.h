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
#import "KNSPeripheral.h"
#import "KNSCentralManager.h"
#import "KNSCentralManager+UI.h"
#import "KonashiJavaScriptBindingsProtocol.h"

@class KNSHandlerManager;
@interface Konashi : NSObject <CBPeripheralDelegate, KonashiJavaScriptBindings>

@property (nonatomic, readonly) KNSPeripheral *activePeripheral;

/// ---------------------------------
/// @name Event handler
/// ---------------------------------

/**
 *  このHandlerはKonashiが接続された際に呼び出されます。
 */
@property (nonatomic, copy) void (^connectedHandler)();

/**
 *  このHandlerはKonashiが切断された際に呼び出されます。
 */
@property (nonatomic, copy) void (^disconnectedHandler)();

/**
 *  このHandlerはKonashiが使用可能状態になった際に呼び出されます。
 */
@property (nonatomic, copy) void (^readyHandler)();

/**
 *  このHandlerはKonashiPinModeInputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^digitalInputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);

/**
 *  このHandlerはKonashiPinModeOutputに設定されているPIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^digitalOutputDidChangeValueHandler)(KonashiDigitalIOPin pin, int value);

/**
 *  このHandlerはAIOの値が変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^analogPinDidChangeValueHandler)(KonashiAnalogIOPin pin, int value);

/**
 *  このHandlerはUartで値を受信した際に呼び出されます。
 */
@property (nonatomic, copy) void (^uartRxCompleteHandler)(NSData *data);

/**
 *  このHandlerはI2Cで接続されたモジュールからデータを読みだした際に呼び出されます。
 */
@property (nonatomic, copy) void (^i2cReadCompleteHandler)(NSData *data);

/**
 *  このHandlerはバッテリー残量の値を取得した際に呼び出されます。
 */
@property (nonatomic, copy) void (^batteryLevelDidUpdateHandler)(int value);

/**
 *  このHandlerはRSSIが変化した際に呼び出されます。
 */
@property (nonatomic, copy) void (^signalStrengthDidUpdateHandler)(int value);

/**
 *  このHandlerはSPI経由でのデータ書き込み完了時に呼び出されます。呼びだされた瞬間からSPIモジュールから受け取るデータを取得することができます。
 * @note このHanderはSPI機能が追加されたファームウェアを搭載したkoshianでのみ呼びだされます。 +spiReadRequest メソッドを呼び出すことでkoshianからデータを読み出すことが可能です。
 */
@property (nonatomic, copy) void (^spiWriteCompleteHandler)();

/**
 *  このHandlerは +spiReadRequest メソッドを用いてデータを受信した時に呼び出されます。
 * @param data 受信したデータ
 * @note このHanderはSPI機能が追加されたファームウェアを搭載したkoshianでのみ呼びだされます。
 */
@property (nonatomic, copy) void (^spiReadCompleteHandler)(NSData *data);

/// ---------------------------------
/// @name Basic method
/// ---------------------------------

/**
 *  シングルトンを取得します。
 *
 *  @return Konashiのインスタンス。
 */
+ (Konashi *) shared;

/**
 *  iPhone周辺のkonashiを探します。
 *	この関数を実行した後、周りにあるkonashiのリストが出現します。リストに列挙されているkonashiのひとつをクリックすると、konashiに自動的に接続されます。その後、 KonashiEventConnectedNotification と KonashiEventReadyToUseNotification が発行されます。
 *
 *	@warning 本来、KonashiEventCentralManagerPowerOnNotification のイベント以前に find を実行しても無効ですが、この場合に限り、KonashiEventCentralManagerPowerOnNotification のイベント後に自動的に find が遅延実行されるように調整されています。
 *
 *  @return 探索が開始された場合は KonashiResultSuccess 、既に接続されている場合は KonashiResultFailure 。
 */
+ (KonashiResult) find;

/**
 *  konashiの名前を指定して接続します。
 *	find の場合はkonashiのリストが出現しますが、findWithName を実行した場合はリストが出ずに自動的に接続されます。
 *	名前に関しては、find を実行することによって下から出現するリストでリストアップされる konashi#4-0452 などの文字列です。konashi#*-**** の*部分の数字は、konashiの緑色チップのシール上に記載されている番号と同じです。
 *	もし、指定した名前が見つからない場合は KonashiEventPeripheralNotFoundNotification が発行されます。
 *
 *	@warning 本来、 KonashiEventCentralManagerPowerOnNotification のイベント以前に findWithName を実行しても無効ですが、この場合に限り、 KonashiEventCentralManagerPowerOnNotification のイベント後に自動的に findWithName が遅延実行されるように調整されています。
 *
 *  @param name 接続したいkonashiの名前。例："konashi#4-0452"
 *
 *  @return 探索が開始された場合は KonashiResultSuccess 、既に接続されている場合は KonashiResultFailure 。
 */
+ (KonashiResult) findWithName:(NSString*)name;

/**
 *  ファームウェアのバージョンを返します。
 *
 *  @return ファームウェアのバージョン文字列。
 */
+ (NSString *)softwareRevisionString;

/**
 *  konashiとの接続を解除します。
 *
 *  @return 切断した場合は KonashiResultSuccess 、すでに切断されている及び何らかの原因で失敗した場合は KonashiResultFailure 。
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

/// ---------------------------------
/// @name Digital I/O (PIO)
/// ---------------------------------

/**
 *  PIOのピンを入力として使うか、出力として使うかの設定を行います。
 *
 *  @param pin  設定するPIOのピン名。
 *  @param mode ピンに設定するモード。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pinMode:(KonashiDigitalIOPin)pin mode:(KonashiPinMode)mode;

/**
 *  PIOのピンを入力として使うか、出力として使うかの設定を行います。
 *	それぞれのビットでは、入力設定を0、出力設定を1として表現します。
 *	この関数での引数は、PIO0〜PIO7の入出力設定を8bit(1byte)で表現します。
 *
 *  @param mode PIO0 〜 PIO7 の計8ピンの設定。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pinModeAll:(int)mode;

/**
 *  PIOのピンをプルアップするかの設定を行います。
 *	初期状態では、PIOはプルアップされていません(NO_PULLS)。
 *
 *  @param pin  設定するPIOのピン名。
 *  @param mode ピンをプルアップするかの設定。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
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

/**
 *  PIOの特定のピンの出力状態を設定します。
 *
 *  @param pin   PIOのピン名。
 *  @param value 設定するPIOの出力状態。 KonashiLevelHigh もしくは KonashiLevelLow が指定可能です。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) digitalWrite:(KonashiDigitalIOPin)pin value:(KonashiLevel)value;

/**
 *  PIOの特定のピンの出力状態を設定します。
 *	この関数での引数は、PIO0〜PIO7の出力状態が8bit(1byte)で表現されます。bitとピンの対応は以下です。
 *
 *  @param value PIO0〜PIO7の出力に設定する値。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) digitalWriteAll:(int)value;

/**
 *  指定したPIOの値を取得します。
 *
 *  @param pin PIOの番号
 *
 *  @return 指定したPIOの値。 KonashiLevelHigh 及び KonashiLevelLow 。
 */
+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin;

/**
 *  PIOの値を取得します。
 *
 *  @return PIOの状態。各bitにおいてHighの場合は1、Lowの場合は0がセットされている。
 */
+ (int) digitalReadAll;

/// ---------------------------------
/// @name PWM
/// ---------------------------------

/**
 *  PIO の指定のピンを PWM として使用する/しないかを設定します。
 *	PIO のいずれのピンも PWMモード に設定できます。
 *
 *  @param pin  PWMモードの設定をするPIOのピン名。
 *  @param mode 設定するPWMのモード。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pwmMode:(KonashiDigitalIOPin)pin mode:(KonashiPWMMode)mode;

/**
 *  指定のピンのPWM周期を設定します。
 *	周期の単位はマイクロ秒(us)で指定してください。
 *
 *  @param pin    PIOのピン名。
 *  @param period 周期。単位はマイクロ秒(us)で32bitで指定してください。最大2^32us = 71.5分です。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pwmPeriod:(KonashiDigitalIOPin)pin period:(unsigned int)period;

/**
 *  指定のピンのPWMのデューティ(ONになっている時間)を設定します。
 *	単位はマイクロ秒(us)で指定してください。
 *
 *  @param pin  PIOのピン名。
 *  @param duty デューティ。単位はマイクロ秒(us)で32bitで指定してください。最大2^32us = 71.5分です。
 *
 *  @return 設定に成功した場合は  KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pwmDuty:(KonashiDigitalIOPin)pin duty:(unsigned int)duty;

/**
 *  指定のピンのLEDの明るさを0%〜100%で指定します。
 *	pwmLedDrive 関数を使うには pwmMode で KonashiPWMModeEnableLED を指定してください。
 *
 *  @param pin   PIOのピン名。
 *  @param ratio LEDの明るさ。0〜100 をしてしてください。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) pwmLedDrive:(KonashiDigitalIOPin)pin dutyRatio:(int)ratio;

/// ---------------------------------
/// @name Analog I/O (AIO)
/// ---------------------------------

/**
 *  アナログ入出力の基準電圧を返します。
 *
 *  @return アナログ入出力の基準電圧(mV)。
 */
+ (int) analogReference;

/**
 *  AIO の指定のピンの入力電圧を取得するリクエストを konashi に送ります。
 *	入力電圧の取得が完了した際は KonashiEventAnalogIODidUpdateNotification が発行されます。
 *
 *  @param pin AIOのピン名。
 *	@bug koshianでは正確な値を取得することができません。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) analogReadRequest:(KonashiAnalogIOPin)pin;

/**
 *  AIO の指定のピンに任意の電圧を出力します。
 *
 *  @param pin       AIOのピン名。
 *  @param milliVolt 設定する電圧をmVで指定します。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) analogWrite:(KonashiAnalogIOPin)pin milliVolt:(int)milliVolt;

/**
 *  AIOの値を取得します。 [Konashi analogReadRequest:] を用いてAIOの値の要求後に正しい値を取得可能です。
 *
 *  @param pin AIOの番号
 *
 *  @return AIOの値。
 */
+ (int) analogRead:(KonashiAnalogIOPin)pin;

/// ---------------------------------
/// @name I2C
/// ---------------------------------

/**
 *  I2C を有効/無効を設定します。
 *
 *  @param mode 設定するI2Cのモード。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cMode:(KonashiI2CMode)mode;

/**
 *  I2C のスタートコンディションを発行します。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cStartCondition;

/**
 *  I2C のリスタートコンディションを発行します。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cRestartCondition;

/**
 *  I2C のストップコンディションを発行します。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cStopCondition;

/**
 *  I2C で指定したアドレスにデータを書き込みます。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @param data    書き込むデータ
 *  @param address 書き込み先アドレス
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult)i2cWriteData:(NSData *)data address:(unsigned char)address;

/**
 *  I2C で指定したアドレスに文字列を書き込みます。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @param data    書き込む文字列
 *  @param address 書き込み先アドレス
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cWriteString:(NSString *)data address:(unsigned char)address;

/**
 *  I2C で指定したアドレスからデータを読み込むリクエストを行います。
 *	この関数はリクエストを行うだけでデータは取得できません。
 *
 *  @param length  読み込むデータの長さ
 *  @param address 読み込み先のアドレス
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) i2cReadRequest:(int)length address:(unsigned char)address;

/**
 *	I2Cで接続されたモジュールから得られるデータを取得します。[Konashi i2cReadRequest:address:] を用いてデータの要求後に正しいデータを取得可能です。
 *
 *  @return 取得したデータ
 */
+ (NSData *)i2cReadData;

/// ---------------------------------
/// @name UART
/// ---------------------------------

/**
 *  UART の有効/無効を設定します。
 *	有効にする前に、uartBaudrate でボーレートを設定しておいてください。
 *
 *  @param mode 設定するUARTのモード。
 *  @param baudrate 設定するUARTのボーレート。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) uartMode:(KonashiUartMode)mode baudrate:(KonashiUartBaudrate)baudrate;

/**
 *  UART でデータを送信します。
 *
 *  @param data 送信するデータ。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) uartWriteData:(NSData *)data;

/**
 *  UART で文字列を送信します。
 *
 *  @param string 送信する文字列
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) uartWriteString:(NSString *)string;

/**
 *  uartの値を取得します。
 *
 *  @return 取得した値。
 */
+ (NSData *) readUartData;

/// ---------------------------------
/// @name SPI
/// ---------------------------------

/**
 *  SPIのモードを設定します。
 *
 *  @param mode     動作モード
 *  @param speed    動作速度
 *  @param bitOrder ビットオーダー
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 *  @note SPI機能が追加されたファームウェアを搭載したkoshianでのみ実行可能です。
 */
+ (KonashiResult)spiMode:(KonashiSPIMode)mode speed:(KonashiSPISpeed)speed bitOrder:(KonashiSPIBitOrder)bitOrder;

/**
 *  SPI経由でデータを書き込みます。
 *
 *  @param data 書き込むデータ。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 *  @note SPI機能が追加されたファームウェアを搭載したkoshianでのみ実行可能です。
 */
+ (KonashiResult)spiWrite:(NSData *)data;

/**
 *  SPI経由で取得したデータを読み込むリクエストを行います。koshianからiOSデバイスにデータを転送します。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 *  @note SPI機能が追加されたファームウェアを搭載したkoshianでのみ実行可能です。
 */
+ (KonashiResult)spiReadRequest;

/**
 *  SPI経由で読み込んだデータを取得します。
 *
 *  @return 読み込んだデータ。
 *  @note SPI機能が追加されたファームウェアを搭載したkoshianでのみ実行可能です。
 */
+ (NSData *)spiReadData;

/// ---------------------------------
/// @name Hardware Control
/// ---------------------------------

/**
 *  konashi を再起動します。
 *	konashi が再起動すると、自動的にBLEのコネクションは切断されてしまいます。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) reset;

/**
 *  konashi のバッテリ残量を取得するリクエストを konashi に送ります。
 *	値の取得が成功した際には KonashiEventBatteryLevelDidUpdateNotification が発行されます。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) batteryLevelReadRequest;

/**
 *  konashi の電波強度を取得するリクエストを行います。
 *	値の取得が成功した際には KonashiEventSignalStrengthDidUpdateNotification が発行されます。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) signalStrengthReadRequest;

/**
 *  バッテリーの残量を取得します。
 *
 *  @return バッテリーの残量(%)
 */
+ (int) batteryLevelRead;

/**
 *  RSSIの値を取得します。
 *
 *  @return RSSIの値。
 */
+ (int) signalStrengthRead;

#pragma mark - Deprecated

/// ---------------------------------
/// @name I2C(Deprecated)
/// ---------------------------------

/**
 *  I2C で指定したアドレスにデータを書き込みます。
 *	事前に i2cMode で I2C を有効にしておいてください。
 *
 *  @param length  書き込むデータの長さ(byte)
 *  @param data    書き込むデータ
 *  @param address 書き込み先アドレス
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 *	@warning このメソッドは非推奨です。 [Konashi i2cWriteData:address] を用いてデータの書き込んでください。
 */
+ (KonashiResult) i2cWrite:(int)length data:(unsigned char*)data address:(unsigned char)address __attribute__ ((deprecated));

/**
 *  I2Cで接続されたモジュールから得られるデータを取得します。[Konashi i2cReadRequest:address:] を用いてデータの要求後に正しいデータを取得可能です。
 *
 *  @param length データの長さ(byte)
 *  @param data 格納する変数
 *
 *  @return 値の取得に成功した場合は KonashiResultSuccess 、失敗した場合は KonashiResultFailure 。
 *	@warning このメソッドは非推奨です。 [Konashi i2cReadCompleteHandler] を用いてデータの取得をしてください。
 */
+ (KonashiResult) i2cRead:(int)length data:(unsigned char*)data __attribute__ ((deprecated));

/// ---------------------------------
/// @name UART(Deprecated)
/// ---------------------------------

/**
 *  UART の有効/無効を設定します。
 *	有効にする前に、uartBaudrate でボーレートを設定しておいてください。
 *
 *  @param mode 設定するUARTのモード。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) uartMode:(KonashiUartMode)mode __attribute__ ((deprecated));

/**
 *  UART の通信速度を設定します。
 *
 *  @param baudrate UARTの通信速度。
 *
 *  @return 設定に成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 */
+ (KonashiResult) uartBaudrate:(KonashiUartBaudrate)baudrate __attribute__ ((deprecated));

/**
 *  UART でデータを送信します。
 *
 *  @param data 送信するデータ。
 *
 *  @return 成功した場合は KonashiResultSuccess 、何らかの原因で失敗した場合は KonashiResultFailure 。
 *	@warning このメソッドは非推奨です。 [Konashi uartWriteData:] を用いでデータを送信してください。
 */
+ (KonashiResult) uartWrite:(unsigned char)data __attribute__ ((deprecated));

/**
 *  uartの値を取得します。
 *
 *  @return 取得した値。
 *	@warning このメソッドは非推奨です。 [Konashi uartRxCompleteHandler] 及び [Konashi readUartData] を用いて値を取得してください。
 */
+ (unsigned char) uartRead __attribute__ ((deprecated));

@end
