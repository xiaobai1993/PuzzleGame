//
//  PuzzleTools.h
//  智能拼图
//
//  Created by Ceasar on 16/4/29.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PuzzleItemCtrlModel.h"
#import "PuzzleBlockItem.h"
@interface PuzzleTools : NSObject
+(void)saveBackImage:(UIImage *) backImage;
+(UIImage*)getBackImage;
+(void)CtrlPuzzleMove:(PuzzleBlockItem*)thePuzzleBlock withDragDirection:(int*)Direct;
/**
 *  拼图的所有的数组
 */
+(void)setPuzzleGroup:(NSMutableArray *) groupArr;
+(void)exchangePuzzleWithBank:(PuzzleBlockItem *)thePuzzleBlock;
@end
