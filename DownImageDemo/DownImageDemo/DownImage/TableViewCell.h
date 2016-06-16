//
//  TableViewCell.h
//  DownImageDemo
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end
