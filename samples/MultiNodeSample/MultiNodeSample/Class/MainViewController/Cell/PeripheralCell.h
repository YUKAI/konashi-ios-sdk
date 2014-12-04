//
//  PeripheralCell.h
//  MultiNodeSample
//
//  Created by Akira Matsuda on 12/2/14.
//  Copyright (c) 2014 Akira Matsuda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Konashi.h"

@interface PeripheralCell : UITableViewCell

@property (strong, nonatomic) KNSPeripheral *peripheral;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *batteryProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *rssiProgressView;

@end
