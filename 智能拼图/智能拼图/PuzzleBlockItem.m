//
//  BlockPic.m
//  智能拼图
//
//  Created by 王国栋 on 15/9/17.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import "PuzzleBlockItem.h"
#import "PuzzleTools.h"
@interface PuzzleBlockItem ()

//测试下分支程序,再次测试下分支的合并，希望能够如我所愿
/**
 * 提示的序号标签
 */
@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UITapGestureRecognizer * tap;//点击手势

@property (nonatomic,strong) UIPanGestureRecognizer * pan;//拖拽手势

@property (nonatomic,strong) UIImage * showImage;

@property (nonatomic,assign) CGPoint originCenter;

@property (nonatomic,assign) CGPoint preMoveCenter;
@end
@implementation PuzzleBlockItem
/**
 *  展示3秒的提示
 */
-(void )showTipsThreeSec
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.titleLabel.alpha = 1;
    } completion:^(BOOL finshed){
        
        self.userInteractionEnabled = YES;
        self.titleLabel.alpha = 0;
    }];
}

+(instancetype)puzzleBlockWithModel:(PuzzleItemCtrlModel *)puzzleModel
{
    //计算位置
    return [[self alloc]initWithPuzzleModel:puzzleModel];
}

-(instancetype)initWithPuzzleModel:(PuzzleItemCtrlModel *)puzzleModel
{
    if (self = [super init]) {
        
        //计算坐标和大小
        self.userInteractionEnabled=YES;
        self.backgroundColor = [UIColor whiteColor];
        self.frame = puzzleModel.itemRect;
        self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.titleLabel.textColor = [UIColor redColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.alpha = 0;
        [self addSubview:self.titleLabel];
        self.tap = [[UITapGestureRecognizer alloc]init];
        self.pan = [[UIPanGestureRecognizer alloc]init];
        [self.tap addTarget:self action:@selector(tapTarget:)];
        [self.pan addTarget:self action:@selector(panTarget:)];
        self.layer.borderColor = [[UIColor blackColor]CGColor];
        self.layer.borderWidth=1;
        self.titleLabel.userInteractionEnabled=YES;

        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.pan];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%d",puzzleModel.objIdx];
        
        self.image = [self getPartOfImageInRect:puzzleModel.itemRect];//原始的位置
        if (puzzleModel.curIdx == puzzleModel.maxIdx-1) {
            
            self.showImage = self.image;
            self.image= nil;
        }
        
        _puzzleModel = puzzleModel;
    }
    return self;
}

-(void)setPuzzleModel:(PuzzleItemCtrlModel *)puzzleModel
{
    _puzzleModel = puzzleModel;
    self.frame = _puzzleModel.itemRect;
    self.originCenter = self.center;
    self.preMoveCenter = self.center;
}
//点击按钮的事件

-(void)tapTarget:(UITapGestureRecognizer *) tapGesture
{
    [PuzzleTools CtrlPuzzleMove:self withDragDirection:NULL];
}
-(void)panTarget:(UIPanGestureRecognizer *) panGesture
{
    int  moveDirect = PuzzleItemCtrlDirectNone;
    [PuzzleTools CtrlPuzzleMove:self withDragDirection:&moveDirect];
    CGFloat xOffSet=0;
    CGFloat yOffSet=0;
    CGFloat itemW = self.frame.size.width;
    CGFloat itemH = self.frame.size.height;
    switch (moveDirect) {
        case PuzzleItemCtrlDirectUp:
            yOffSet = - itemH;
            break;
        case PuzzleItemCtrlDirectDown:
            yOffSet =itemH;
            break;
        case PuzzleItemCtrlDirectLeft:
            xOffSet = -itemW;
            break;
        case PuzzleItemCtrlDirectRight:
            xOffSet = itemW;
            break;
    }
    CGFloat xMoveOff=0;
    CGFloat yMoveOff=0;
    CGPoint center =[panGesture locationInView:self];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        self.originCenter = center;
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        [self.superview bringSubviewToFront:self];
        if (yOffSet>0) {//向下移动
            yMoveOff=center.y - self.originCenter.y;
            if (yMoveOff>=0) {

                self.center = CGPointMake(self.center.x, self.center.y+yMoveOff);
                if (self.center.y-self.preMoveCenter.y>itemH) {
                    self.center = CGPointMake(self.center.x, self.preMoveCenter.y+itemH);
                }
            }
        }
        else if(yOffSet<0)//向上移动
        {
            yMoveOff=center.y - self.originCenter.y;
            if (yMoveOff<=0) {
                self.center = CGPointMake(self.center.x, self.center.y+yMoveOff);
                if (self.center.y-self.preMoveCenter.y<-itemH) {
                    self.center = CGPointMake(self.center.x, self.preMoveCenter.y-itemH);
                }

            }
        }
        else if (xOffSet>0) {//向右移动
            xMoveOff=center.x - self.originCenter.x;
            if (xMoveOff>=0) {
                self.center = CGPointMake(self.center.x+xMoveOff, self.center.y);
                if (self.center.x-self.preMoveCenter.x>itemW) {
                    self.center = CGPointMake(self.preMoveCenter.x+itemW, self.center.y);
                }
            }
        }
        else if(xOffSet<0)//向左移动
        {
            xMoveOff=center.x - self.originCenter.x;
            if (yMoveOff<=0) {
                self.center = CGPointMake(self.center.x+xMoveOff, self.center.y);
                if (self.center.x-self.preMoveCenter.x<-itemW) {
                    self.center = CGPointMake(self.preMoveCenter.x- itemW, self.center.y);
                }
            }
        }
       
    }
    else if(panGesture.state==UIGestureRecognizerStateEnded)
    {
        BOOL f1 = fabs(fabs(self.center.x-self.preMoveCenter.x)-itemW)<3;
        BOOL f2 = fabs(fabs(self.center.y-self.preMoveCenter.y)-itemH)<3;
        if (f1||f2) {
            
            [PuzzleTools exchangePuzzleWithBank:self];
            //交换和空格的位置，完成调整
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.center = self.preMoveCenter;
            }];
        }
        
    }
    
}
-(BOOL)isAtObjIdx{
    
    return self.puzzleModel.objIdx == self.puzzleModel.curIdx;
}
- (UIImage *)getPartOfImageInRect:(CGRect)partRect
{
    UIImage * img = [PuzzleTools getBackImage];
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}
-(void)showRealImage
{
    self.image = self.showImage;
}
- (void)didMoveToSuperview
{
    // 1.创建动画对象
    CATransition *anim2 = [CATransition animation];
    anim2.type = @"oglFlip";//指明动画的类型
    anim2.subtype = kCATransitionFromLeft;//指明动画的过渡类型或方向
    anim2.duration = 0.5;
    [self.superview.layer addAnimation:anim2 forKey:nil];
}

@end
