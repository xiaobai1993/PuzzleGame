//
//  BlockPic.h
//  智能拼图
//
//  Created by 王国栋 on 15/9/17.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleItemCtrlModel.h"
@interface PuzzleBlockItem : UIImageView
/**
 *  控制模型
 */

@property (nonatomic,strong) PuzzleItemCtrlModel * puzzleModel;


+(instancetype)puzzleBlockWithModel:(PuzzleItemCtrlModel*)puzzleModel;
//提示 3 秒
-(void) showTipsThreeSec;
/**
 *  @return 是否在目标位置
 */
-(BOOL) isAtObjIdx;
-(void)showRealImage;
@end
