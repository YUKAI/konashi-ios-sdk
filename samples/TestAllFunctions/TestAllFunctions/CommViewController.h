//
//  CommViewController.h
//  TestAllFunctions
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *uartSetting;
@property (weak, nonatomic) IBOutlet UILabel *uartBaudrateLabel;
@property (weak, nonatomic) IBOutlet UITextField *uartSendText;
@property (weak, nonatomic) IBOutlet UITextView *uartRecvText;
- (IBAction)uartSend:(id)sender;
- (IBAction)changeBaudrate:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *i2cSetting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *i2cSpeed;
@property (weak, nonatomic) IBOutlet UITextView *i2cRecvText;
- (IBAction)i2cSend:(id)sender;
- (IBAction)i2cRecv:(id)sender;

@end
