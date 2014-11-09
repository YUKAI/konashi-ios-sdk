//
//  Konashi+LegacyAPI.h
//  Konashi
//
//  Created by Akira Matsuda on 11/9/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi.h"

@interface Konashi (LegacyAPI)

/**
 *  指定したPIOの値を取得します。
 *
 *  @param pin PIOの番号
 *
 *  @return 指定したPIOの値。KonashiLevelHigh及びKonashiLevelLow。
 *	@warning このメソッドは非推奨です。 [Konashi digitalInputDidChangeValueHandler] 及び [Konashi digitalOutputDidChangeValueHandler] を用いて値を取得してください。
 */
+ (KonashiLevel) digitalRead:(KonashiDigitalIOPin)pin NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  PIOの値を取得します。
 *
 *  @return PIOの状態。各bitにおいてHighの場合は1、Lowの場合は0がセットされている。
 *	@warning このメソッドは非推奨です。 [Konashi digitalInputDidChangeValueHandler] 及び [Konashi digitalOutputDidChangeValueHandler] を用いて値を取得してください。
 */
+ (int) digitalReadAll NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  AIOの値を取得します。 [Konashi analogReadRequest:] を用いてAIOの値の要求後に正しい値を取得可能です。
 *
 *  @param pin AIOの番号
 *
 *  @return AIOの値。
 *	@warning このメソッドは非推奨です。 [Konashi analogPinDidChangeValueHandler] を用いて値の取得をしてください。
 */
+ (int) analogRead:(KonashiAnalogIOPin)pin NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  I2Cで接続されたモジュールから得られるデータを取得します。[Konashi i2cReadRequest:address:] を用いてデータの要求後に正しいデータを取得可能です。
 *
 *  @param length データの長さ(byte)
 *  @param data 格納する変数
 *
 *  @return 値の取得に成功した場合はKonashiResultSuccess、失敗した場合はKonashiResultFailure。
 *	@warning このメソッドは非推奨です。 [Konashi i2cReadCompleteHandler] を用いてデータの取得をしてください。
 */
+ (KonashiResult) i2cRead:(int)length data:(unsigned char*)data NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  uartの値を取得します。
 *
 *  @return 取得した値。
 *	@warning このメソッドは非推奨です。 [Konashi uartRxCompleteHandler] を用いて値を取得してください。
 */
+ (unsigned char) uartRead NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  バッテリーの残量を取得します。
 *
 *  @return バッテリーの残量(%)
 *	@warning このメソッドは非推奨です。 [Konashi batteryLevelDidUpdateHandler] を用いて残量を取得してください。
 */
+ (int) batteryLevelRead NS_DEPRECATED(NA, NA, 5_0, 8_0);

/**
 *  RSSIの値を取得します。
 *
 *  @return RSSIの値。
 *	@warning このメソッドは非推奨です。 [Konashi signalStrengthDidUpdateHandler] を用いてRSSIを取得してください。
 */
+ (int) signalStrengthRead NS_DEPRECATED(NA, NA, 5_0, 8_0);

@end
