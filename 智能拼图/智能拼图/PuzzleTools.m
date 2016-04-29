//
//  PuzzleTools.m
//  智能拼图
//
//  Created by Ceasar on 16/4/29.
//  Copyright © 2016年 xiaobai. All rights reserved.
//

#import "PuzzleTools.h"

@implementation PuzzleTools
+(void)saveBackImage:(UIImage *) backImage
{
    NSString * imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    imagePath = [imagePath stringByAppendingPathComponent:@"backImage"];
    
    [UIImagePNGRepresentation(backImage)writeToFile: imagePath atomically:YES];

}


+(UIImage*)getBackImage
{
    NSString * imagePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    imagePath = [imagePath stringByAppendingPathComponent:@"backImage"];
    NSData * data = [NSData dataWithContentsOfFile:imagePath];
    UIImage * image = [UIImage imageWithData:data];
    if (image==nil) {
        
        image = [UIImage imageNamed:@"bg2"];
        [PuzzleTools saveBackImage:image];
    }
    return image;
}
@end



