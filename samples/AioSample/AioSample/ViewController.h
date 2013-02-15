//
//  ViewController.h
//  AioSample
//
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UILabel *adcValue;

- (IBAction)find:(id)sender;
- (IBAction)requestReadAio0:(id)sender;
- (IBAction)setVoltage1000:(id)sender;

@end
