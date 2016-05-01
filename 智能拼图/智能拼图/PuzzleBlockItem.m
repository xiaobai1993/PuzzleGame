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


/**
 * 提示的序号标签
 */
@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UITapGestureRecognizer * tap;//点击手势

@property (nonatomic,strong) UIPanGestureRecognizer * pan;//拖拽手势

@property (nonatomic,strong) UIImage * showImage;

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
}
//点击按钮的事件

-(void)tapTarget:(UITapGestureRecognizer *) tapGesture
{
    [PuzzleTools CtrlPuzzleMove:self withDragDirection:NULL];
}
-(void)panTarget:(UIPanGestureRecognizer *) panGesture
{
    PuzzleItemCtrlDirect  moveDirect = PuzzleItemCtrlDirectNone;
    [PuzzleTools CtrlPuzzleMove:self withDragDirection:&moveDirect];
    CGRect  originRect = self.frame;
    int xOffSet=0;
    int yOffSet=0;
    switch (moveDirect) {
        case PuzzleItemCtrlDirectUp:
            yOffSet = - originRect.size.height;
            break;
        case PuzzleItemCtrlDirectDown:
            yOffSet = originRect.size.height;
            break;
        case PuzzleItemCtrlDirectLeft:
            xOffSet = -originRect.size.width;
            break;
        case PuzzleItemCtrlDirectRight:
            xOffSet = originRect.size.width;
            break;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        
    }
    else if(panGesture.state == UIGestureRecognizerStatePossible)
    {
        
    }
    else if(panGesture.state==UIGestureRecognizerStateEnded)
    {
        
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
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    // 2.设置动画对象
//    // keyPath决定了执行怎样的动画, 调整哪个属性来执行动画
//    anim.keyPath = @"transform";
//    //    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, -1, 0)];
//    anim.duration = 2.0;
//    
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
//    
//    // 3.添加动画
//    [self.layer addAnimation:anim forKey:nil];

    
    CATransition *anim2 = [CATransition animation];
    //设置动画类型
    //    pageCurl            向上翻一页
    //    pageUnCurl          向下翻一页
    //    rippleEffect        滴水效果
    //    suckEffect          收缩效果，如一块布被抽走
    //    cube                立方体效果
    //    oglFlip             上下翻转效果
    anim2.type = @"oglFlip";//指明动画的类型
    //subType
    /**
     *
     kCATransitionFade   交叉淡化过渡
     kCATransitionMoveIn 新视图移到旧视图上面
     kCATransitionPush   新视图把旧视图推出去
     kCATransitionReveal 将旧视图移开,显示下面的新视图
     
     kCATransitionFromLeft;
     kCATransitionFromTop;
     kCATransitionFromBottom;
     kCATransitionFromRight;
     */
    
    anim2.subtype = kCATransitionFromLeft;//指明动画的过渡类型或方向
    
    anim2.duration = 0.5;
    [self.superview.layer addAnimation:anim2 forKey:nil];
}

@end
