//
//  status.h
//  智能拼图
//
//  Created by Ceasar on 16/4/15.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface status : NSObject

@property (nonatomic,strong) NSMutableArray * statusArr;

//打印自身
- (void)outputStatus;
//获得空格的位置
- (CGPoint)getBankPosition;

//空格左移动
-(void)bankMoveLeft;
//空格右移动
-(void)bankMoveRight;
//空格上移动
-(void)bankMoveUp;
//空格下移动
-(void)bankMoveDown;

@end
