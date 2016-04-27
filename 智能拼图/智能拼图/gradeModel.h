//
//  gradeModel.h
//  智能拼图
//
//  Created by Ceasar on 16/3/12.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gradeModel : NSObject
@property (nonatomic,strong) NSString * time;//时间,比赛时间

@property (nonatomic,strong) NSString * name;//比赛者姓名.

@property (nonatomic,strong) NSString * level;//难度等级

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
