//
//  HomeViewController.h
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

- (IBAction)find:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)howto:(id)sender;

- (IBAction)getBattery:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UIProgressView *dbBar;
@property (weak, nonatomic) IBOutlet UIProgressView *batteryBar;
@property (weak, nonatomic) IBOutlet UILabel *softwareRevisionString;



@end
