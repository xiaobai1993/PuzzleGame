//
//  BlockPic.m
//  智能拼图
//
//  Created by 王国栋 on 15/9/17.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import "BlockItem.h"

@interface BlockItem ()


@end
@implementation BlockItem
-(void) showTipsThreeSec
{
    self.userInteractionEnabled = NO;
    
        [UIView animateWithDuration:3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
         //   self.transform = CGAffineTransformIdentity;
            self.titleLabel.alpha = 1;
        } completion:^(BOOL finshed){
         
             self.userInteractionEnabled = YES;
            self.titleLabel.alpha = 0;
        }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.alpha = 0;
    }
    return self;
}

@end
