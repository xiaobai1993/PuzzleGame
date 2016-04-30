//
//  ViewController.m
//  智能拼图
//
//  Created by 王国栋 on 15/itemSum/16.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import "MainViewController.h"
#import "PuzzleBlockItem.h"
#include "autoComplete.h"
#import "MJExtension.h"
static int itemSum=16;
@interface MainViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CGFloat gradeTime;
    int lastItemCount;
}

@property (strong, nonatomic) IBOutlet UIButton *bgImage;

@property (strong, nonatomic) IBOutlet UIButton *btn_start;

@property (strong,nonatomic)NSMutableArray *PuzzleItemArr;//保存拼图块的编号

@property (assign,nonatomic)int  blank_pos;//空白的

@property (strong, nonatomic) IBOutlet UIImageView *originalPic;
@property (strong, nonatomic) IBOutlet UIButton *btn_selPic;
@property (strong, nonatomic) IBOutlet UILabel *setpnums;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@property (nonatomic,strong) NSTimer * timer;

@end
static int step =0;



@implementation MainViewController
//@synthesize bgImage,ArrItem,ArrNum,blank_pos;

-(NSMutableArray*)PuzzleItemArr
{
    
    if (_PuzzleItemArr==nil) {
        
        _PuzzleItemArr = [[NSMutableArray alloc]init];
    }
    return _PuzzleItemArr;
}


- (void)viewDidLoad {
    
     [super viewDidLoad];
     [self.bgImage setBackgroundColor:[UIColor grayColor]];
     self.originalPic.image =[UIImage imageNamed:@"bg2"];
     [self.bgImage setBackgroundImage:self.originalPic.image forState:UIControlStateNormal];
     self.view.backgroundColor = [UIColor lightGrayColor];
     _mainViewHeight.constant = self.bgImage.frame.size.width;
     [self.view layoutIfNeeded];
    
}
                   
-(void)updateTime
{
    gradeTime+=0.1;
    self.timeLable.text = [NSString stringWithFormat:@"时间:%.0f",gradeTime];
}
/**
 *  选择图片
 */
- (IBAction)selectBgImage:(id)sender {
    [self select_img];
}

-(void)initVar
{
    step=0;
    self.setpnums.text=@"步数:0";
    
    if (self.timer==nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil  repeats:YES];
    }
    gradeTime=0;
    //每次都要把所有的原来创建的按钮移除，否则再次点击开始的时候会有影响
    for (int i=1; i<=itemSum; i++) {
        PuzzleBlockItem * blockItem =(PuzzleBlockItem*)[self.bgImage viewWithTag:i];
        if (blockItem!=nil) {
            [blockItem removeFromSuperview];
            blockItem = nil;
        }
    }
    [self.PuzzleItemArr removeAllObjects];
    [self.bgImage setBackgroundImage:self.originalPic.image forState:UIControlStateNormal];

}
- (IBAction)beginGame:(id)sender
{
    [self initVar];
    //创建拼图
    for (int i=0; i< itemSum;i++)
    {
        CGRect itemRect= [self FrameForIndex:i];
        NSDictionary * dict = @{
                                @"itemRect":[NSValue valueWithCGRect:itemRect],
                                @"maxIdx":@(itemSum),
                                @"objIdx":@(i),
                                @"curIdx":@(i),
                                };
        PuzzleItemCtrlModel * puzzleCtrlModel = [PuzzleItemCtrlModel mj_objectWithKeyValues:dict];
        PuzzleBlockItem * puzzItem = [PuzzleBlockItem puzzleBlockWithModel:puzzleCtrlModel];
        [self.bgImage addSubview:puzzItem];
        [self.PuzzleItemArr addObject:puzzItem];
    }
    [self ChoticBlocks];
}

/**
 *  计算每个小图片的位置的位置
 */
-(void)ChoticBlocks
{
    //blank_pos=itemSum;
    
    [self.bgImage setBackgroundImage:nil forState:UIControlStateNormal];//清空背景图
    
    NSMutableArray * randArr = [self randNum:itemSum-1];//最后一位是空格，所以要自己加入
    
    [randArr addObject:[NSString stringWithFormat:@"%d",itemSum-1]];
    for (int i = 0; i<self.PuzzleItemArr.count; i++) {
        
        PuzzleBlockItem * puzzleItem = self.PuzzleItemArr[i];
        PuzzleItemCtrlModel * ctrlModel = puzzleItem.puzzleModel;
        ctrlModel.curIdx = [randArr[i]intValue];
        puzzleItem.puzzleModel = ctrlModel;
    }
}
-(void)calculateMoveMsg
{
//    -(void)TouchForMove:(PuzzleBlockItem *)sender;
//    {
//        
//        self.setpnums.text = [NSString stringWithFormat:@"步数:%d",step++];
//        int rowNum = (int)sqrt(itemSum);
//        BOOL f1 = (sender.cur_pos+rowNum==blank_pos)||(sender.cur_pos-rowNum==blank_pos);
//        
//        BOOL f2 = (sender.cur_pos%rowNum==1)&&(sender.cur_pos-rowNum==blank_pos);
//        
//        BOOL f3=  (sender.cur_pos%rowNum==0)&&(sender.cur_pos+1==blank_pos);
//        
//        BOOL f4 =(sender.cur_pos+1==blank_pos)||(sender.cur_pos-1==blank_pos);
//        
//        NSLog(@"%d %d %d %d",f1,f2,f3,f4);
    
       for (int i = 0; i<self.PuzzleItemArr.count; i++) {
        
           PuzzleBlockItem * puzzleItem = self.PuzzleItemArr[i];
           PuzzleItemCtrlModel * ctrlModel = puzzleItem.puzzleModel;
           puzzleItem.puzzleModel = ctrlModel;
           
       }

    
    
}
//1 获取图片的某一部分区域
//2 把一个图片按照尺寸进行放大或缩小,这个例子是按照40*40
- (UIImage*)LoadImage:(UIImage*)aImage
{
    
    CGRect rect = CGRectMake(0, 0, 280 , 280);//创建矩形框
    UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境
    CGContextClipToRect(currentContext, rect);//设置当前绘图环境到矩形框
    [aImage drawInRect:rect];
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();//获得图片
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    return cropped;
}

-(void)TouchForMove:(PuzzleBlockItem *)sender;
{
    [self check_pass];//检验是否结束
}
/**
 *生成0到sum-1的随机数
 */
-(NSMutableArray *)randNum:(int )sum
{
    NSMutableArray *arr=[NSMutableArray array];
    srand((unsigned)time(NULL));
    int n;
    while ([arr count]!=sum)
    {
        int i=0;
        n=rand()%sum;
        for (i=0; i<[arr count]; i++)
        {
            if (n==[[arr objectAtIndex:i]intValue]) {
                break;
            }
        }
        if ([arr count]==i)
        {
            [arr addObject:[NSString stringWithFormat:@"%d",n]];
        }
    }
   //逆序数必须是偶数才可以拼出来
    int count = 0;
    for (int i = 1; i < arr.count; i++)
    {
        for (int j = 0; j < i; j++)
        {
            if ([arr[j]integerValue] > [arr[i]integerValue])
            {
                count++;
            }
        }
    }
    //交换两个数的顺序逆序数奇偶性改变
    if (count%2!=0) {
        
            NSInteger idx1=[arr indexOfObject:@"8"];
            NSInteger idx2=[arr indexOfObject:@"7"];
            [arr replaceObjectAtIndex:idx1 withObject:@"7"];
            [arr replaceObjectAtIndex:idx2 withObject:@"8"];
    }
    return  arr;
}
-(void)check_pass
{
    int i;
    if (i == itemSum -1 ) {
        
        UIAlertView *GamePassAlert = [[UIAlertView alloc]initWithTitle:@"通关提示" message:@"恭喜你成功通关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
              [GamePassAlert show];
        //存储成绩
        NSUserDefaults * standard = [NSUserDefaults standardUserDefaults];
        NSString * level;
        switch (itemSum) {
            case 9:
                level=@"low";
                break;
            case 16:
                level=@"mid";
                break;
            default:
                level=@"high";
                break;
        }
        [self.timer invalidate];
        self.timer = nil;
        CGFloat bestTime = [standard floatForKey:level];
        //存储成绩
        if (bestTime==0||gradeTime<bestTime) {
            [standard setFloat:gradeTime forKey:level];
            [standard synchronize];
        }
        //成功后按钮不在响应用户事件
        [self.PuzzleItemArr makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(NO)];
    }
}
//选择系统照片
-(void)select_img
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
//用照片做拼图
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    
    aImage = [self LoadImage:aImage];
    [self.originalPic setImage:aImage];
    [self.bgImage setBackgroundImage:self.originalPic.image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)makeTips:(id)sender {
    
    [self.PuzzleItemArr makeObjectsPerformSelector:@selector(showTipsThreeSec)];
}
-(CGRect)FrameForIndex:(int)i
{
    CGFloat x,y,height,width ;
    int rowNum = (int)sqrt(itemSum);
    x=i%rowNum*self.bgImage.frame.size.width/sqrt(itemSum);
    y=i/rowNum*self.bgImage.frame.size.height/sqrt(itemSum);
    width=self.bgImage.frame.size.width/sqrt(itemSum);
    height=self.bgImage.frame.size.height/sqrt(itemSum);
    CGRect r =CGRectMake(x, y, width, height);
    return r;
}
//设置难度等级
- (IBAction)selectLevel:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"难度等级" message:@"请选择难度等级" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * actionLow = [UIAlertAction actionWithTitle:@"低" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lastItemCount=itemSum;
        itemSum = 9;
        [self beginGame:sender];
    }];
    [alert addAction:actionLow];
    UIAlertAction * actionMid= [UIAlertAction actionWithTitle:@"中" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         lastItemCount=itemSum;
         itemSum = 16;
         [self beginGame:sender];
    }];
    [alert addAction:actionMid];
    UIAlertAction * actionHigh = [UIAlertAction actionWithTitle:@"高" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lastItemCount=itemSum;
        itemSum = 25;
         [self beginGame:sender];
    }];
    [alert addAction:actionHigh];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
