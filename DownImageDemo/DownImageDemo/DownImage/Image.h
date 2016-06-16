//
//  Image.h
//  DownImageDemo
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

/** 图片地址 */
@property (nonatomic, copy) NSString *class_pic;
/** 名字 */
@property (nonatomic, copy) NSString *course_name;

+ (NSArray <Image *> *)imagesWithArray:(NSArray *)array;

@end
