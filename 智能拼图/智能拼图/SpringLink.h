//
//  SpringLink.h
//  智能拼图
//
//  Created by Ceasar on 16/4/14.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Node;
@interface SpringLink : NSObject
//{
//    Node  * pointData;//指向节点的指针
//    SpringLink * next;//指向兄弟节点
//}

@property (nonatomic,strong) Node *pointData;
@property (nonatomic,strong)  SpringLink * next;
@end
