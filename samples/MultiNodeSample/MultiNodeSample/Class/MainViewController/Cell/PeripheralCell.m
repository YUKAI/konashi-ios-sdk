//
//  PeripheralCell.m
//  MultiNodeSample
//
//  Created by Akira Matsuda on 12/2/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "PeripheralCell.h"

@implementation PeripheralCell

- (void)setPeripheral:(KNSPeripheral *)peripheral
{
	_peripheral = peripheral;
	_titleLabel.text = peripheral.peripheral.name;
	
	__weak typeof(self) bself = self;
	_peripheral.signalStrengthDidUpdateHandler = ^(int value) {
		NSLog(@"RSSI did update:%d", value);
		if(value > 100.0){
			value = 100.0;
		}
		bself.rssiProgressView.progress = (CGFloat)value / 100 * -1;
	};
	_peripheral.batteryLevelDidUpdateHandler = ^(int value) {
		NSLog(@"battery level did update:%d", value);
		if(value > 100.0){
			value = 100.0;
		}
		bself.batteryProgressView.progress = (CGFloat)value / 100;
	};
}

@end
