//
//  AutoComplete.m
//  智能拼图
//
//  Created by Ceasar on 16/4/15.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "AutoComplete.h"
#import "Node.h"
#import "SpringLink.h"

@interface AutoComplete ()
{
    
    Node * open;
    Node *closed;
}


@property (nonatomic,strong) status * originStatus;
@property (nonatomic,strong) status * objStatus;

@end
@implementation AutoComplete

-(instancetype) initWithOriginStatus:(status *) origin andWithObjStatus:(status*) obj
{
    if (self = [super init]) {
        
        self.objStatus = obj;
        self.originStatus = origin;
    
        [self AStar];
    }
    return self;

}
//初始化一个空的链表
-(void)initLink:(Node *) header
{
    header=[[Node alloc]init];
    header.next = nil;
}
//判断链表是否为空
-(BOOL)isEmpty:(Node*)header
{
    if (header.next==nil) {
        
        return YES;
    }
    return NO;
}
//从链表中拿出一个数据
-(void)popNode:(Node*)FNode fromHeader:(Node *)header
{
    if ([self isEmpty:header]) {
        FNode=nil;
        return;
    }
    FNode = header.next;
    header.next =  header.next.next;
    FNode.next = nil;
}
 //向结点的最终后继结点链表中添加新的子结点
-(void) addSpringNode:(Node *) nData toHeader:(Node*)header
{
    SpringLink * newNode = [[SpringLink alloc]init];
    newNode.pointData=nData;
    newNode.next=header.child;
    header.child=newNode;
}
//释放状态图中存放结点后继结点地址的空间
- (void)freeSpringLink:(SpringLink*)header
{
    SpringLink * tmp;
    while (header!=nil) {
        tmp=header;
        header=header.next;
        tmp=nil;
    }
}

//释放open表与closed表中的资源
-(void)freeLink:(Node *)header
{
    Node * tmp=header;
    header=header.next;
    tmp=nil;
    while (header!=nil) {
        
        [self freeSpringLink:header.child];
        tmp=header;
        header=header.next;
        tmp=nil;
    }
}
//向普通链表中添加一个结点
-(void)addNode:(Node *)newNode toHeader:(Node *)header
{
    newNode.next = header.next;
    header.next = newNode;
}
//向非递减排列的链表中添加一个结点
-(void) addAscNode:(Node *)newNode toHeader:(Node *)header
{
    Node * P=header.next;
    Node * Q=header;
    while (P!=nil&&P.fvalue<newNode.fvalue) {
        
        Q=P;
        P=P.next;
    }
    newNode.next = Q.next;
    Q.next = newNode;
}

//初始化函数，进行算法初始条件的设置
-(void)Init
{
    //[self initLink:open];
    //[self initLink:closed];
    open = [[Node alloc]init];
    closed = [[Node alloc]init];
    
    Node * Start = [[Node alloc]init];
    Start.data=self.originStatus;
    
    [self computeAllValue:Start andNode:nil];
    [self addAscNode:Start toHeader:open];
}


//计算本结点的f，g，h值
-(void)computeAllValue:(Node *)theNode andNode:(Node *)parentNode
{
    if (parentNode==nil) {
        theNode.gvalue=0;
    }
    else
    {
        theNode.gvalue=parentNode.gvalue+1;
    }
    theNode.hvalue = [self computeHValue:theNode];
    theNode.fvalue = theNode.gvalue+theNode.hvalue;
}

//计算节点的H值
-(int)computeHValue :(Node*)theNode
{
    int num = 0;
    for (int i =0; i<theNode.data.statusArr.count; i++) {
        
        int theH = [theNode.data.statusArr[i]intValue];
        int tarH = [self.objStatus.statusArr[i]intValue];
        if (theH!=tarH) {
            num++;
        }
    }
    return num;
}


-(BOOL) isInLink:(Node *)spciNode TheLink:(Node *)theLink TheNodeLink:(Node *)theNodeLink PreNode:(Node *) preNode
{
    
    preNode = theLink;
    theLink=theLink.next;
    while (theLink!=nil) {
        
        if ([spciNode hasSameStatus:theLink]) {
            
            theNodeLink = theLink;
            return YES;
        }
        preNode = theLink;
        theLink = theLink.next;
    }
    return NO;
}
//结点与其祖先结点是否有相同的状态
-(BOOL)hasAnceSameStatus:(Node *)originNode andWithOther:(Node*)AnceNode
{
    while (AnceNode!=nil) {
        if ([originNode hasSameStatus:AnceNode]) {
            return YES;
        }
        AnceNode=AnceNode.parent;
    }
    return NO;
}

//产生结点的后继结点(与祖先状态不同)链表
-(void)SpringLink:(Node *) theNode theLink:(Node *) spring
{
    
        CGPoint row_col = [theNode.data getBankPosition];
        if (row_col.y!=2) {
    
            Node * rlNewNode = [[Node alloc]init];
            rlNewNode.data = theNode.data;
            [rlNewNode.data bankMoveLeft];
            //与父辈节点相同就丢弃
            if ([self hasAnceSameStatus:rlNewNode andWithOther:theNode.parent]) {
    
                rlNewNode=nil;
            }
            else
            {
                rlNewNode.parent  = theNode;
                rlNewNode.child = nil;
                rlNewNode.next =nil;
                [self computeAllValue:rlNewNode andNode:theNode];
                //讲本节点加入后继节点链表
                [self addNode:rlNewNode toHeader:spring];
            }
        }
        if (row_col.y!=0) {
    
            Node * rlNewNode = [[Node alloc]init];
            rlNewNode.data = theNode.data;
            [rlNewNode.data bankMoveRight];
            //与父辈节点相同就丢弃
            if ([self hasAnceSameStatus:rlNewNode andWithOther:theNode.parent]) {
    
                rlNewNode=nil;
            }
            else
            {
                rlNewNode.parent  = theNode;
                rlNewNode.child = nil;
                rlNewNode.next =nil;
                [self computeAllValue:rlNewNode andNode:theNode];
                //讲本节点加入后继节点链表
                [self addNode:rlNewNode toHeader:spring];
            }
        }
        //向下移动
        if (row_col.x!=0) {
    
            Node * udNewNode = [[Node alloc]init];
            udNewNode.data = theNode.data;
            [udNewNode.data bankMoveDown];
            if ([self hasAnceSameStatus:udNewNode andWithOther:theNode.parent]) {
    
                udNewNode=nil;
            }
            else
            {
                udNewNode.parent  = theNode;
                udNewNode.child = nil;
                udNewNode.next =nil;
                [self computeAllValue:udNewNode andNode:theNode];
                //讲本节点加入后继节点链表
                [self addNode:udNewNode toHeader:spring];
            }
    
        }
        if (row_col.x!=2) {
    
            Node * udNewNode = [[Node alloc]init];
            udNewNode.data = theNode.data;
            [udNewNode.data bankMoveDown];
            if ([self hasAnceSameStatus:udNewNode andWithOther:theNode.parent]) {
    
                udNewNode=nil;
            }
            else
            {
                udNewNode.parent  = theNode;
                udNewNode.child = nil;
                udNewNode.next =nil;
                [self computeAllValue:udNewNode andNode:theNode];
                //讲本节点加入后继节点链表
                [self addNode:udNewNode toHeader:spring];
            }
        }
}
//输出最佳的路径
-(void)outputBestRoad:(Node *)goal
{
    int deepnum = goal.gvalue;
    if(goal.parent != NULL)
    {
        [self outputBestRoad:goal.parent];
    }
    NSLog(@"第 %d 层的状态",deepnum);
    [goal.data outputStatus];

}

-(void) AStar
{
    Node * tmpNode;
    Node * spring;
    Node * tmpLNode;
    Node * tmpChartNode;
    Node * thePreNode;
    BOOL getGoal = NO;
//    long numcount = 1;
    
    [self Init];//函数初始化
    [self initLink:spring];
    tmpChartNode=nil;
    
    while (open!=nil) {
        
        NSLog(@"---");
        open=open.next;
    }
    
    NSLog(@"从open表中拿出的结点的状态及相应的值");
    
        //while(![self isEmpty:open])
        while(open.next==nil)

        {
           // 从open表中拿出f值最小的元素,并将拿出的元素放入closed表中
            [self popNode:tmpNode fromHeader:open];
            [self addNode:tmpNode toHeader:closed];

            //如果拿出的元素是目标状态则跳出循环
            if([self computeHValue:tmpNode] == 0)
            {
                getGoal = YES;
                break;
            }
    
            //产生当前检测结点的后继(与祖先不同)结点列表，产生的后继结点的parent属性指向当前检测的结点
           // SpringLink(tmpNode , spring);
    
            [self SpringLink:tmpNode theLink:spring];
            //遍历检测结点的后继结点链表
            while(spring.next!=nil)
            {
                [self popNode:tmpNode fromHeader:spring];
                //状态在open表中已经存在，thePreNode参数在这里并不起作用
                
                if ([self isInLink:tmpNode TheLink:open TheNodeLink:tmpChartNode PreNode:thePreNode]) {
                    
                    [self addSpringNode:tmpNode toHeader:tmpChartNode];
                    if (tmpNode.gvalue<tmpChartNode.gvalue) {
                        
                        tmpChartNode.parent = tmpLNode.parent;
                        tmpChartNode.gvalue = tmpLNode.gvalue;
                        tmpChartNode.fvalue = tmpLNode.fvalue;
                    }
                    tmpLNode=nil;
                }
                else if([self isInLink:tmpNode TheLink:closed TheNodeLink:tmpChartNode PreNode:thePreNode])
                {
                    
                    [self addSpringNode:tmpLNode toHeader:tmpChartNode];
                    if (tmpLNode.gvalue < tmpChartNode.gvalue) {
                        Node * commu;
                        tmpChartNode.parent = tmpLNode.parent;
                        tmpChartNode.gvalue = tmpLNode.gvalue;
                        tmpChartNode.fvalue = tmpLNode.fvalue;
                        [self freeSpringLink:tmpChartNode.child];
                        tmpChartNode.child =nil;
                        [self popNode:commu fromHeader:thePreNode];
                        [self addAscNode:commu toHeader:open];
                    }
                    tmpLNode=nil;
                }
                else
                {
                    [self addSpringNode:tmpLNode toHeader:tmpNode];
                    [self addAscNode:tmpLNode toHeader:open];
                }
        }
        //目标可达的话，输出最佳的路径
        if(getGoal)
        {
            [self outputBestRoad:tmpNode];
        }
        [self freeLink:open];
        [self freeLink:closed];
        }
}





@end
