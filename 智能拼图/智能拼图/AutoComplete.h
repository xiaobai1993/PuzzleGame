//
//  AutoComplete.h
//  智能拼图
//
//  Created by Ceasar on 16/4/15.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "status.h"
@interface AutoComplete : NSObject

-(instancetype) initWithOriginStatus:(status *) origin andWithObjStatus:(status*) obj;

@end
