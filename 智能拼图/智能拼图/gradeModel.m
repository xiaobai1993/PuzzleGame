//
//  gradeModel.m
//  智能拼图
//
//  Created by Ceasar on 16/3/12.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "gradeModel.h"

@implementation gradeModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
