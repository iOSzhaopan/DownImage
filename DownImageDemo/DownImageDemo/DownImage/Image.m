//
//  Image.m
//  DownImageDemo
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import "Image.h"

@implementation Image

+ (NSArray<Image *> *)imagesWithArray:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arr addObject:[self imageWithDict:dict]];
    }
    return arr;
}

+ (instancetype)imageWithDict:(NSDictionary *)dict {
    Image *image = [[self alloc] init];
    [image setValuesForKeysWithDictionary:dict];
    return image;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
