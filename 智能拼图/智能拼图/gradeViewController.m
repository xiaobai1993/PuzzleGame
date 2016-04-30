//
//  gradeViewController.m
//  智能拼图
//
//  Created by Ceasar on 16/4/14.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "gradeViewController.h"

@interface gradeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lowLevel;

@property (strong, nonatomic) IBOutlet UILabel *midLevel;

@property (strong, nonatomic) IBOutlet UILabel *highLevel;
@end

@implementation gradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults * standard = [NSUserDefaults standardUserDefaults];
    CGFloat garde = [standard floatForKey:@"low"];
    if (garde!=0) {
        
        self.lowLevel.text = [NSString stringWithFormat:@"低等级: %.f",garde];
    }
    else
    {
         self.lowLevel.text =@"低等级: 暂无";
    }
    
    garde = [standard floatForKey:@"mid"];
    if (garde!=0) {
        
        self.midLevel.text = [NSString stringWithFormat:@"中等级: %.f",garde];
    }
    else
    {
        self.midLevel.text =@"中等级: 暂无";
    }
    garde = [standard floatForKey:@"high"];
    if (garde!=0) {
        
        self.highLevel.text = [NSString stringWithFormat:@"高等级: %.f",garde];
    }
    else
    {
        self.highLevel.text =@"高等级: 暂无";
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
