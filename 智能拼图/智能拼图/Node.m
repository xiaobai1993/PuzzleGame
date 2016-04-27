//
//  Node.m
//  智能拼图
//
//  Created by Ceasar on 16/4/14.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "Node.h"

@implementation Node
//两个结点是否有相同的状态
-(BOOL)hasSameStatus:(Node*)otherNode
{
    for (int i=0; i<self.data.statusArr.count;i++) {
        
        int selfStatus = [self.data.statusArr[i]intValue];
        int otherStatus =[otherNode.data.statusArr[i]intValue];
        if (selfStatus!=otherStatus) {
            return NO;
        }
        
    }
    return YES;
}
@end
