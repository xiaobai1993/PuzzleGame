//
//  status.m
//  智能拼图
//
//  Created by Ceasar on 16/4/15.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "status.h"

@implementation status


- (void)outputStatus
{
    NSLog(@"当前的状态是:-------");
    for (int i =0 ; i< self.statusArr.count; i++) {
        
        int pos = [self.statusArr[i]intValue];
        
        printf("%d ",pos);
        if (i%(int)sqrt(self.statusArr.count)==0) {
            
            printf("\n");
        }
    }
    
}
- (CGPoint)getBankPosition;{
    
    for (int i =0 ; i< self.statusArr.count; i++) {
        int pos = [self.statusArr[i]intValue];
        if (pos == 0) {
            CGPoint bankPoint = CGPointMake(i/(int)sqrt(self.statusArr.count), i%(int)sqrt(self.statusArr.count));
            return bankPoint;
        }
    }
    NSLog(@"没有找到空格.");
    return CGPointMake(-1, -1);//这里是出错的
}

//空格左移动
-(void)bankMoveLeft
{
    CGPoint bankPos = [self getBankPosition];
    
    int idx = bankPos.x * (int)sqrt(self.statusArr.count)+bankPos.y;
    if (bankPos.x!=0) {
        [self.statusArr exchangeObjectAtIndex:idx withObjectAtIndex:idx-1];
    }
}
//空格右移动
-(void)bankMoveRight
{
    CGPoint bankPos = [self getBankPosition];
    int idx = bankPos.x * (int)sqrt(self.statusArr.count)+bankPos.y;
    if (bankPos.x!=(int)sqrt(self.statusArr.count)) {
        [self.statusArr exchangeObjectAtIndex:idx withObjectAtIndex:idx+1];
    }
}
//空格上移动
-(void)bankMoveUp
{
    CGPoint bankPos = [self getBankPosition];
    
    int idx = bankPos.x * (int)sqrt(self.statusArr.count)+bankPos.y;
    if (bankPos.y!=0) {
        
        //差一个行距
        [self.statusArr exchangeObjectAtIndex:idx withObjectAtIndex:idx-(int)sqrt(self.statusArr.count)];
    }

}
//空格下移动
-(void)bankMoveDown
{
    CGPoint bankPos = [self getBankPosition];
    
    int idx = bankPos.x * (int)sqrt(self.statusArr.count)+bankPos.y;
    if (self.statusArr.count- idx>=(int)sqrt(self.statusArr.count)) {
        //差一个行距
        [self.statusArr exchangeObjectAtIndex:idx withObjectAtIndex:idx+(int)sqrt(self.statusArr.count)];
    }
}
@end
