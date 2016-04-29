//
//  PuzzleItemCtrlModel.h
//  智能拼图
//
//  Created by Ceasar on 16/4/28.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 控制移动方向
 */
typedef enum
{
    PuzzleItemCtrlDirectNone=0,//不移动
    PuzzleItemCtrlDirectLeft=1,
    PuzzleItemCtrlDirectRight=2,
    PuzzleItemCtrlDirectUp=3,
    PuzzleItemCtrlDirectDown=4,
    
}PuzzleItemCtrlDirect;

//用来控制拼图的行动和状态
@interface PuzzleItemCtrlModel : NSObject

@property (nonatomic,assign)PuzzleItemCtrlDirect direct;
/**
 *  大小
 */
@property (nonatomic,assign) CGRect itemRect;
/**
 *  目标位置
 */
@property (nonatomic,assign) int objIdx;
/**
 *  当前位置
 */
@property (nonatomic,assign) int curIdx;
/**
 *  最大的位置，用来计算坐标的x,y值
 */
@property (nonatomic,assign) int maxIdx;

//@property (nonatomic,strong) UIImage * puzzleImage;

@end






