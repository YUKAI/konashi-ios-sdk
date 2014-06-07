//
//  ViewController.h
//  ACDriveExtension
//
//  Created by yukai on 2013/10/07.
//  Copyright (c) 2013年 YUKAI Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

- (IBAction)find:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
