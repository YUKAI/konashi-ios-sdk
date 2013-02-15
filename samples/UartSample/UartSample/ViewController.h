//
//  ViewController.h
//  UartSample
//
//  Copyright (c) 2013 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *statusMessage;

- (IBAction)find:(id)sender;
- (IBAction)send:(id)sender;

@end
