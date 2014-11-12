//
//  Konashi+UI.m
//  GettingStarted
//
//  Created by Akira Matsuda on 9/2/14.
//  Copyright (c) 2014 Yukai Engineering. All rights reserved.
//

#import "Konashi+UI.h"
#import "KonashiUtils.h"

@implementation Konashi (UI)

static NSArray *peripherals_;

- (void)showModulePickerWithPeripherals:(NSArray *)peripherals
{
	peripherals_ = peripherals;
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
		CBPeripheral *peripheral = peripherals_[buttonIndex];
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
