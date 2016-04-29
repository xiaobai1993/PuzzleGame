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
        //self.titleLabel.backgroundColor = [UIColor orangeColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.alpha = 0;
        [self addSubview:self.titleLabel];
        self.tap = [[UITapGestureRecognizer alloc]init];
        self.pan = [[UIPanGestureRecognizer alloc]init];
        
        self.layer.borderColor = [[UIColor blackColor]CGColor];
        self.layer.borderWidth=1;

        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.pan];
        
        CATransition *anim = [CATransition animation];
        //设置动画类型
        //    pageCurl            向上翻一页
        //    pageUnCurl          向下翻一页
        //    rippleEffect        滴水效果
        //    suckEffect          收缩效果，如一块布被抽走
        //    cube                立方体效果
        //    oglFlip             上下翻转效果
        anim.type = @"pageCurl";//指明动画的类型
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
        
        anim.subtype = kCATransitionFade;//指明动画的过渡类型或方向
        
        anim.duration = 0.5;
        
        self.titleLabel.text = [NSString stringWithFormat:@"%d",puzzleModel.objIdx];
        if (puzzleModel.curIdx != puzzleModel.maxIdx-1) {
            
            self.image = [self getPartOfImageInRect:puzzleModel.itemRect];//原始的位置
        }
    }
    return self;
}

-(void)setPuzzleModel:(PuzzleItemCtrlModel *)puzzleModel
{
    _puzzleModel = puzzleModel;
    //控制移动
    
    
}
//点击按钮的事件

-(void)tapTarget:(UITapGestureRecognizer *) tapGesture
{
    
    switch (self.puzzleModel.direct) {
        case PuzzleItemCtrlDirectUp:
            
            break;
            case PuzzleItemCtrlDirectDown:
            
            break;
            
            case PuzzleItemCtrlDirectNone:
            
            break;
            
            case PuzzleItemCtrlDirectLeft:
            
            break;
            
            case PuzzleItemCtrlDirectRight:
            
            break;
            
        default:
            break;
    }

}
-(void)panTarget:(UIPanGestureRecognizer *) panGesture
{
    
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



@end
