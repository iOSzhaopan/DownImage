//
//  ViewController.m
//  DownImageDemo
//
//  Created by miaolin on 16/6/16.
//  Copyright © 2016年 赵攀. All rights reserved.
//

#import "ViewController.h"
#import "ImageController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)down:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[[ImageController alloc] init] animated:YES];
}

@end
