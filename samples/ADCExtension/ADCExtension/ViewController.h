//
//  ViewController.h
//  ADCExtension
//
//  Created by yukai on 2013/10/08.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UILabel *adcValueLabel;

- (IBAction)find:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
