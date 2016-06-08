//
//  PuzzleTools.m
//  智能拼图
//
//  Created by Ceasar on 16/4/29.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "PuzzleTools.h"
#import "PuzzleBlockItem.h"
static NSArray * puzzleGroup;
@implementation PuzzleTools
+(void)saveBackImage:(UIImage *) backImage
{
    NSString * imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    imagePath = [imagePath stringByAppendingPathComponent:@"backImage"];
    
    [UIImagePNGRepresentation(backImage)writeToFile: imagePath atomically:YES];

}
+(void)CtrlPuzzleMove:(PuzzleBlockItem*)thePuzzleBlock withDragDirection:(int*)Direct;
{
    //取模型
    PuzzleItemCtrlModel * thePuzzleModel = thePuzzleBlock.puzzleModel;
    if (puzzleGroup.count==0) {
        return ;
    }
    PuzzleBlockItem * bankItem;
    PuzzleItemCtrlModel * bankCtrlModel;
    for (id obj in puzzleGroup) {
        
        if (![obj isKindOfClass:[PuzzleBlockItem class]]) {
            return ;
        }
        PuzzleBlockItem * puzzleBlock = (PuzzleBlockItem*)obj;
        if (puzzleBlock.puzzleModel.objIdx == puzzleGroup.count -1 ) {
            bankCtrlModel = puzzleBlock.puzzleModel;
            bankItem = puzzleBlock;
        }
    }

    int rowNum = (int)sqrt(puzzleGroup.count);
    

//    //条件1 上下可以交换
//    BOOL f1 = (thePuzzleModel.curIdx+rowNum==bankCtrlModel.curIdx)||(thePuzzleModel.curIdx-rowNum==bankCtrlModel.curIdx);
//    //条件2
//    BOOL f2 = ((thePuzzleModel.curIdx+1)%rowNum==1)&&(thePuzzleModel.curIdx-1==bankCtrlModel.curIdx);
//    BOOL f3=  ((thePuzzleModel.curIdx+1)%rowNum==0)&&(thePuzzleModel.curIdx+1==bankCtrlModel.curIdx);
//    //左右相邻的可以交换
//    BOOL f4 = (thePuzzleModel.curIdx+1==bankCtrlModel.curIdx)||(thePuzzleModel.curIdx-1==bankCtrlModel.curIdx);
    
    
    //f1||((!(f2||f3))&&f4
    int curX = thePuzzleModel.curIdx/rowNum;
    int curY = thePuzzleModel.curIdx%rowNum;
    int blankX = bankCtrlModel.curIdx/rowNum;
    int blankY = bankCtrlModel.curIdx%rowNum;
    

        //如果满足条件就直接交换和空格位置
    if ((curX==blankX&&abs(curY-blankY)==1)||((int)abs(curX-blankX)==1&&curY==blankY))
    {
        if (Direct==NULL) {
            //交换空格和拼图的的当前位置
            int tmpIdx = bankCtrlModel.curIdx;
            bankCtrlModel.curIdx = thePuzzleModel.curIdx;
            thePuzzleModel.curIdx = tmpIdx;
            thePuzzleBlock.puzzleModel = thePuzzleModel;
            bankItem.puzzleModel = bankCtrlModel;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hasMove" object:nil];
        }
        else
        {
            int xOff=0,yOff=0;
            xOff = bankCtrlModel.itemRect.origin.x - thePuzzleModel.itemRect.origin.x;
            yOff = bankCtrlModel.itemRect.origin.y - thePuzzleModel.itemRect.origin.y;
            if (xOff>0) {
                *Direct  = PuzzleItemCtrlDirectRight;
            }
            else if(xOff<0)
            {
                *Direct = PuzzleItemCtrlDirectLeft;
            }
            else if (yOff>0) {
                *Direct = PuzzleItemCtrlDirectDown;
            }
            else
            {
                *Direct = PuzzleItemCtrlDirectUp;
            }
        }
    }
    [PuzzleTools check_pass];
}
+(void)setPuzzleGroup:(NSMutableArray *)groupArr
{
    puzzleGroup = groupArr;
}

+(UIImage*)getBackImage
{
    NSString * imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    imagePath = [imagePath stringByAppendingPathComponent:@"backImage"];
    NSData * data = [NSData dataWithContentsOfFile:imagePath];
    UIImage * image = [UIImage imageWithData:data];
    if (image==nil) {
        
        image = [UIImage imageNamed:@"bg2"];
        [PuzzleTools saveBackImage:image];
    }
    return image;
}
+(void)exchangePuzzleWithBank:(PuzzleBlockItem *)thePuzzleBlock
{
    
    PuzzleBlockItem * bankItem;
    PuzzleItemCtrlModel * bankCtrlModel;
    for (id obj in puzzleGroup) {
        PuzzleBlockItem * puzzleBlock = (PuzzleBlockItem*)obj;
        if (puzzleBlock.puzzleModel.objIdx == puzzleGroup.count -1 ) {
            bankCtrlModel = puzzleBlock.puzzleModel;
            bankItem = puzzleBlock;
        }
    }
    
    PuzzleItemCtrlModel * thePuzzleModel = thePuzzleBlock.puzzleModel;
    int tmpIdx = bankCtrlModel.curIdx;
    bankCtrlModel.curIdx = thePuzzleModel.curIdx;
    thePuzzleModel.curIdx = tmpIdx;
    thePuzzleBlock.puzzleModel = thePuzzleModel;
    bankItem.puzzleModel = bankCtrlModel;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hasMove" object:nil];
    [PuzzleTools check_pass];

}
+(void)check_pass
{
    
    int t=0;
    
    PuzzleBlockItem * puzzle;
    for (int i=0; i<puzzleGroup.count; i++) {
        
        PuzzleBlockItem * block = puzzleGroup[i];
        if (block.puzzleModel.curIdx==block.puzzleModel.objIdx) {
            t++;
        }
        puzzle = block;
    }
    if (t == puzzleGroup.count) {
        [puzzle showRealImage];
        UIAlertView *GamePassAlert = [[UIAlertView alloc]initWithTitle:@"通关提示" message:@"恭喜你成功通关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [GamePassAlert show];
        //成功后按钮不在响应用户事件
        [puzzleGroup makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(NO)];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"success" object:nil];
    }
}

@end



