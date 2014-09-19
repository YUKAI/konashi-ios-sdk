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

- (void)showModulePicker
{
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
	if (buttonIndex == [actionSheet cancelButtonIndex]) {
		[self actionSheetCancel:actionSheet];
	}
	else {
		KNS_LOG(@"Select %@", [[peripherals objectAtIndex:buttonIndex] name]);
		CBPeripheral *peripheral = peripherals[buttonIndex];
		[cm connectPeripheral:peripheral options:nil];
#ifdef KONASHI_DEBUG
		NSString* name = peripheral.name;
		KNS_LOG(@"Connecting %@(UUID: %@)", name, NSStringFromCFUUIDRef(peripheral.UUID));
#endif
	}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[self performSelector:@selector(postNotification:) withObject:KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED];
}

@end
