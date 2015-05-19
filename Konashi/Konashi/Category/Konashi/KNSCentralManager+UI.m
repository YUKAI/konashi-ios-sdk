//
//  KNSCentralManager+UI.m
//  Konashi
//
//  Created by Akira Matsuda on 12/4/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "KNSCentralManager+UI.h"
#import "KonashiConstant.h"

@implementation KNSCentralManager (UI)

- (void)showPeripherals
{
	[self discover:^(CBPeripheral *peripheral, BOOL *stop) {
	} completionBlock:^(NSSet *peripherals, BOOL timeout) {
		if ([peripherals count] > 0) {
			[self showModulePickerWithPeripherals:[self.peripherals allObjects]];
		}
	} timeoutInterval:KonashiFindTimeoutInterval];
}

static NSArray *peripheralArray;

- (void)showModulePickerWithPeripherals:(NSArray *)peripherals
{
	peripheralArray = peripherals;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Module" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	for (CBPeripheral *p in peripherals) {
		NSString *name = p.name;
		name = [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] ? name : @"Unknown";
		[actionSheet addButtonWithTitle:name];
	}
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = peripherals.count;
	actionSheet.delegate = self;
	[actionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
}

#pragma mark -
#pragma mark - Konashi module picker methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger selectedIndex = buttonIndex;
	if (buttonIndex == [actionSheet cancelButtonIndex]) {
		selectedIndex = -1;
		[self actionSheetCancel:actionSheet];
	}
	else {
		CBPeripheral *peripheral = peripheralArray[buttonIndex];
		[[KNSCentralManager sharedInstance] connectWithPeripheral:peripheral];
#ifdef KONASHI_DEBUG
		KNS_LOG(@"Connecting %@(UUID: %@)", peripheral.name, peripheral.identifier.UUIDString);
#endif
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventPeripheralSelectorDidSelectNotification object:@(selectedIndex)];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[[NSNotificationCenter defaultCenter] postNotificationName:KonashiEventPeripheralSelectorDismissedNotification object:nil];
}


@end
