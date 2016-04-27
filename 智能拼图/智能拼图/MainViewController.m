//
//  ViewController.m
//  智能拼图
//
//  Created by 王国栋 on 15/itemSum/16.
//  Copyright (c) 2015年 xiaobai. All rights reserved.
//

#import "MainViewController.h"
#import "BlockItem.h"
#include "autoComplete.h"
static int itemSum=16;
@interface MainViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CGFloat gradeTime;
    
    int lastItemCount;
}

@property (strong, nonatomic) IBOutlet UIButton *bgImage;

@property (strong, nonatomic) IBOutlet UIButton *btn_start;

@property (strong,nonatomic) NSMutableArray *ArrItem;//保存拼图对象

@property (strong,nonatomic)NSMutableArray *ArrNum;//保存拼图块的编号

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
@synthesize bgImage,ArrItem,ArrNum,blank_pos;


- (void)viewDidLoad {
    

      //AStar();
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

- (IBAction)beginGame:(id)sender
{
    step=0;
    self.setpnums.text=@"步数:0";
    
    if (self.timer==nil) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:nil  repeats:YES];
    }

    gradeTime=0;

    
    [self.bgImage setBackgroundImage:self.originalPic.image forState:UIControlStateNormal];
    //动态创建控件的
    ArrItem = [NSMutableArray array];
    ArrNum = [NSMutableArray array];
    blank_pos=itemSum;
    //每次都要把所有的原来创建的按钮移除，否则再次点击开始的时候会有影响
    for (int i=1; i<=itemSum; i++) {
        UIButton *btn =(UIButton*)[bgImage viewWithTag:i];
        if (btn!=nil) {
            [btn removeFromSuperview];
        }
    }
    for (int i=1; i<=(itemSum>lastItemCount?itemSum:lastItemCount);i++ )
    {
        CGRect r=[self FrameForIndex:i];
        //对原图进行切割
        UIImage *ima = [self getPartOfImage:bgImage.currentBackgroundImage rect:r];
        //根据范围添加拼图和确定背景图的内容
        BlockItem *Block_Item = [[BlockItem alloc]initWithFrame:r];
        [Block_Item setBackgroundImage:ima forState:UIControlStateNormal];
        Block_Item.layer.borderColor = [[UIColor blackColor]CGColor];
        Block_Item.layer.borderWidth=1;
        [Block_Item addTarget:self action:@selector(TouchForMove:) forControlEvents:UIControlEventTouchUpInside];
        [Block_Item setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [Block_Item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //设置目标位置
        Block_Item.tag=i;
        [ArrItem addObject:Block_Item];//添加到数组里面
    }
    [self ChoticBlocks];
}
/**
 *  计算每个小图片的位置的位置
 */
-(CGRect)FrameForIndex:(int)i
{
    i-=1;
    CGFloat x,y,height,width ;
    int rowNum = (int)sqrt(itemSum);
    x=i%rowNum*bgImage.frame.size.width/sqrt(itemSum);
    y=i/rowNum*bgImage.frame.size.height/sqrt(itemSum);
    width=bgImage.frame.size.width/sqrt(itemSum);
    height=bgImage.frame.size.height/sqrt(itemSum);
    CGRect r =CGRectMake(x, y, width, height);
    return r;
}
-(void)ChoticBlocks
{
    blank_pos=itemSum;
    
    ArrNum = [NSMutableArray arrayWithArray:[self randNum:itemSum-1]] ;//生成1到itemSum -1的随机数，存放在数组里面
    [self.bgImage setBackgroundImage:nil forState:UIControlStateNormal];
    for (int i=1; i<=itemSum-1; i++) {
        CGRect r =[self FrameForIndex:i];
        BlockItem *bp;
        int idx = [ArrNum[i-1]intValue];
        for (int j=0; j<itemSum; j++) {
            bp =ArrItem[j];
            if (bp.tag == idx) {
                break;
            }
        }
        bp.frame=r;
        bp.cur_pos=i;
        [self.bgImage addSubview:bp];
    }
  
}
//1 获取图片的某一部分区域
- (UIImage *)getPartOfImage:(UIImage *)img rect:(CGRect)partRect
{
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}
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

-(void)TouchForMove:(BlockItem *)sender;
{
    
    self.setpnums.text = [NSString stringWithFormat:@"步数:%d",step++];
    int rowNum = (int)sqrt(itemSum);
    BOOL f1 = (sender.cur_pos+rowNum==blank_pos)||(sender.cur_pos-rowNum==blank_pos);
    
    BOOL f2 = (sender.cur_pos%rowNum==1)&&(sender.cur_pos-rowNum==blank_pos);
    
    BOOL f3=  (sender.cur_pos%rowNum==0)&&(sender.cur_pos+1==blank_pos);
    
    BOOL f4 =(sender.cur_pos+1==blank_pos)||(sender.cur_pos-1==blank_pos);
    
    NSLog(@"%d %d %d %d",f1,f2,f3,f4);
    //如果满足条件就直接交换和空格位置
    if (f1||((!(f2||f3))&&f4))
    {
        int tem =sender.cur_pos;
        sender.frame =[self FrameForIndex:blank_pos];
        sender.cur_pos=blank_pos;
        blank_pos=tem;
    
    }
    [self check_pass];//检验是否结束
    
}
-(NSMutableArray *)randNum:(int )sum
{
    NSMutableArray *arr=[NSMutableArray array];
    srand((unsigned)time(NULL));
    int n;
    while ([arr count]!=sum)
    {
        int i=0;
        n=rand()%sum+1;
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
    for (i=1; i<=itemSum-1; i++)
    {
        BlockItem * blkPic= ArrItem[i];
        NSLog(@"%zd %zd",blkPic.cur_pos,blkPic.tag);
        if (blkPic.cur_pos!=blkPic.tag) {
            break;
        }
    }
    if (i == itemSum -1 ) {
        
        [self.bgImage addSubview:ArrItem[itemSum-1]];
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
        if (bestTime==0||gradeTime<bestTime) {
            [standard setFloat:gradeTime forKey:level];
            [standard synchronize];
        }
        //成功后按钮不在响应用户事件
        [ArrItem makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:@(NO)];
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
//用照片做头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    
    aImage = [self LoadImage:aImage];
    [self.originalPic setImage:aImage];
    [self.bgImage setBackgroundImage:self.originalPic.image forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
    
}
- (IBAction)makeTips:(id)sender {
    
    [ArrItem makeObjectsPerformSelector:@selector(showTipsThreeSec)];
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
