//
//  Node.h
//  智能拼图
//
//  Created by Ceasar on 16/4/14.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpringLink.h"
#import "status.h"

//定义状态图中节点的数据结构
@interface Node : NSObject
//{
//    status* data;//结点所存储的状态
//    Node *parent;//指向结点的父亲结点
//    SpringLink *child;//指向结点的后继结点
//    Node *next;//指向open或者closed表中的后一个结点
//    int fvalue;//结点的总的路径
//    int gvalue;//结点的实际路径
//    int hvalue;//结点的到达目标的苦难程度
//}
//
@property (nonatomic,strong) status * data;
@property (nonatomic,strong) Node * parent;
@property (nonatomic,strong) Node *next;
@property (nonatomic,strong) SpringLink * child;
@property (nonatomic,assign) int fvalue;
@property (nonatomic,assign) int gvalue;
@property (nonatomic,assign) int hvalue;

//两个结点是否有相同的状态

-(BOOL)hasSameStatus:(Node*)otherNode;





@end
