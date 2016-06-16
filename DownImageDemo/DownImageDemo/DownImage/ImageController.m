//
//  ImageController.m
//  DownImageDemo
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import "ImageController.h"
#import "Image.h"
#import "TableViewCell.h"

@interface ImageController ()
/** 模型数组 */
@property (nonatomic, strong) NSArray <Image *> *imageModels;

/** 缓存图片的字典 */
@property (nonatomic, strong) NSMutableDictionary *imageDict;
/** 下载操作的数组 */
@property (nonatomic, strong) NSMutableDictionary *operationDict;

/** 下载队列 */
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ImageController

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        //设置最大并发数
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSArray<Image *> *)imageModels {
    if (!_imageModels) {
        _imageModels = [Image imagesWithArray:[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image.plist" ofType:nil]]];
    }
    return _imageModels;
}

static NSString *ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 200;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.nameLable.text = self.imageModels[indexPath.row].course_name;
    //拿出url字符串
    NSString *urlStr = self.imageModels[indexPath.row].class_pic;
    //拿出url最后一部分作为文件名
    NSString *fileName = [urlStr lastPathComponent];
    //下载图片的主要代码
    
    //先尝试取内存的图片
    __block UIImage *image = self.imageDict[urlStr];
    if (image) { //如果图片不为空 直接设置图片
        cell.titleImage.image = image;
    }else { // 如果缓存中没有，则去沙盒找
        __block NSData *data = [NSData dataWithContentsOfFile:[self cachePahtWithFileName:fileName]];
        if (data) { //如果沙盒能取到图片则设置图片
            image = [UIImage imageWithData:data];
            cell.titleImage.image = image;
            //将图片存到缓存中
            self.imageDict[urlStr] = image;
        }else { // 能来到这证明沙盒没有，并且内存也没有, 只能下载图片
            //从下载操作字典中取出操作
            NSOperation *op = self.operationDict[urlStr];
            if (!op) { //判断操作是否存在，防止重复下载一张图片
                op = [NSBlockOperation blockOperationWithBlock:^{
                    //耗时操作
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                    if (!data) { //如果下载失败，移除操作
                        [self.operationDict removeObjectForKey:urlStr];
                        return;
                    }
                    image = [UIImage imageWithData:data];
//                    cell.titleImage.image = image; 为了修复图片错位的Bug 不采用这种的
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
                    }];
                    //下载完后写入沙盒和内存
                    [data writeToFile:[self cachePahtWithFileName:fileName] atomically:YES];
                    self.imageDict[urlStr] = image;
                    //移除操作
                    [self.operationDict removeObjectForKey:urlStr];
                }];
                //添加操作到队列中
                [self.queue addOperation:op];
                //添加到队列，开始执行操作
                self.operationDict[urlStr] = op;
            }
        }
    }
    return cell;
}

- (NSString *)cachePahtWithFileName:(NSString *)name {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name];
}

@end
