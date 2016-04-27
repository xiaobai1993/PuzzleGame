//
//  BlockPic.h
//  智能拼图
//
//  Created by 王国栋 on 15/9/17.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockItem : UIButton

@property (assign,nonatomic) int cur_pos;//记录当前位置

//提示 3 秒
-(void) showTipsThreeSec;
@end
