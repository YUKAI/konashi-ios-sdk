//
//  Konashi+UI.m
//  GettingStarted
//
//  Created by Akira Matsuda on 9/2/14.
//  Copyright (c) 2014 Yukai Engineering. All rights reserved.
//

#import "Konashi+UI.h"

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
#ifdef KONASHI_DEBUG
		CBPeripheral *p = [peripherals objectAtIndex:buttonIndex];
		KNS_LOG(@"Connecting %@", p);
#endif
		CBPeripheral *peripheral = peripherals[buttonIndex];
		activePeripheral = peripheral;
		activePeripheral.delegate = self;
		[cm connectPeripheral:activePeripheral options:nil];
	}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[self performSelector:@selector(postNotification:) withObject:KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED];
}

@end
