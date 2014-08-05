//
//  Konashi+UI.m
//  Konashi
//
//  Created by Akira Matsuda on 8/6/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "Konashi+UI.h"

@interface Konashi () <UIActionSheetDelegate>

- (void)connectTargetPeripheral:(int)indexOfTarget;

@end

@implementation Konashi (UI)

- (KonashiResult)connectWithUserInterface
{
    return [self findModule:KonashiFindTimeoutInterval];
}

- (KonashiResult)findModule:(NSTimeInterval)timeout
{
	if (activePeripheral && activePeripheral.state == CBPeripheralStateConnected) {
        return KonashiResultFailed;
    }
	
    if (c.state != CBCentralManagerStatePoweredOn) {
        KNS_LOG(@"CoreBluetooth not correctly initialized !");
        KNS_LOG(@"State = %ld (%@)", (long)cm.state, [self centralManagerStateToString:cm.state]);
        
        findMethodCalled = YES;
        
        return KonashiResultSuccess;
    }
    
    if (peripherals) {
		peripherals = nil;
	}
    
    [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(finishScanModule:) userInfo:nil repeats:NO];
    
    [c scanForPeripheralsWithServices:nil options:0];
    
    return KonashiResultSuccess;
}

- (void)finishScanModule:(NSTimer *)timer
{
    [c stopScan];
    
    KNS_LOG(@"Peripherals: %lu", (unsigned long)[peripherals count]);
    
    if ([peripherals count] > 0) {
		[self performSelector:@selector(postNotification:) withObject:KONASHI_EVENT_PERIPHERAL_FOUND];
		[self showModulePicker];
    }
	else {
		[self performSelector:@selector(postNotification:) withObject:KONASHI_EVENT_NO_PERIPHERALS_AVAILABLE];
    }
}

#pragma mark -
#pragma mark - Konashi module picker methods

- (void)showModulePicker
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Module" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	for (CBPeripheral *p in peripherals) {
		[actionSheet addButtonWithTitle:p.name];
	}
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = peripherals.count;
	actionSheet.delegate = self;
	[actionSheet showInView:[[[UIApplication sharedApplication] delegate] window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [actionSheet cancelButtonIndex]) {
		[self actionSheetCancel:actionSheet];
	}
	else {
		KNS_LOG(@"Select %@", [[peripherals objectAtIndex:selectedIndex] name]);
		[self performSelector:@selector(connectTargetPeripheral:) withObject:@(buttonIndex)];
	}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[self performSelector:@selector(postNotification:) withObject:KONASHI_EVENT_PERIPHERAL_SELECTOR_DISMISSED];
}

@end
