//
//  MainViewController.m
//  MultiNodeSample
//
//  Created by Akira Matsuda on 12/2/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import "MainViewController.h"
#import "Konashi.h"
#import "KNSCentralManager+UI.h"
#import "PeripheralCell.h"

@interface MainViewController ()
{
	NSOperationQueue *queue;
	NSArray *peripherals;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	queue = [NSOperationQueue new];
	
	UIBarButtonItem *discoverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(discover)];
	self.navigationItem.rightBarButtonItem = discoverButton;
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(blinkPeripheralLED) userInfo:nil repeats:YES];
	[[NSNotificationCenter defaultCenter] addObserverForName:KonashiEventReadyToUseNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
		KNSPeripheral *p = note.userInfo[KonashiPeripheralKey];
		[p pinMode:KonashiDigitalIO1 mode:KonashiPinModeOutput];
		peripherals = [[KNSCentralManager sharedInstance].activePeripherals allObjects];
		[self.tableView reloadData];
	}];
	
	UIBarButtonItem *uartTestButton = [[UIBarButtonItem alloc] initWithTitle:@"Uart" style:UIBarButtonItemStylePlain target:self action:@selector(showTestViewController:)];
	self.navigationItem.leftBarButtonItem = uartTestButton;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"PeripheralCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readPeripheralDeviceValue) userInfo:nil repeats:YES];
}

- (void)discover
{
	[[KNSCentralManager sharedInstance] showPeripherals];
}

BOOL flag = NO;

- (void)blinkPeripheralLED
{
	BOOL f = flag;
	[[KNSCentralManager sharedInstance].activePeripherals enumerateObjectsUsingBlock:^(KNSPeripheral *p, BOOL *stop) {
		[queue addOperationWithBlock:^{
			KonashiLevel l = f ? KonashiLevelLow : KonashiLevelHigh;
			[p digitalWrite:KonashiDigitalIO1 value:l];
		}];
	}];
	flag = !flag;
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *const reuseIdentifier = @"Cell";
	PeripheralCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
	KNSPeripheral *p = peripherals[indexPath.row];
	cell.peripheral = p;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - 

- (void)readPeripheralDeviceValue
{
	[[KNSCentralManager sharedInstance].activePeripherals enumerateObjectsUsingBlock:^(KNSPeripheral *p, BOOL *stop) {
		[p signalStrengthReadRequest];
		[p batteryLevelReadRequest];
	}];
}

- (void)showTestViewController:(id)sender
{
	UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
