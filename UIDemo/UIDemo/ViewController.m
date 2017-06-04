//
//  ViewController.m
//  UIDemo
//
//  Created by huangshan on 16/4/23.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "HSTabSlideView.h"

#import "CustomCell.h"

@interface ViewController ()<HSTabSlideViewDelegate>

@property (nonatomic, strong) UIView *aView;

@property (nonatomic, strong) HSTabSlideView *slideView;

@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.titleArray = @[@"图集", @"哈哈"];
    
    [self demo10];
    
//    [self.slideView reloadData];
    
    
}


-(void)demo10
{
    
    self.navigationController.navigationBarHidden = YES;
    
    self.slideView = [[HSTabSlideView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) slideStyle:HSSlideStyleLineAdaptText];
    
    //设置是否可以循环
    self.slideView.isCycle = YES;
    
    [self.view addSubview:self.slideView];
    
    //设置代理
    self.slideView.delegate = self;
    
//    //设置重新加载数据
//    [self.slideView reloadData];
    
}

#pragma mark - slideView的代理方法

-(UIView *)tabSlideView:(HSTabSlideView *)slideView viewForItemAtIndex:(NSInteger)index
{
    CustomCell *cell = [[CustomCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cell.backgroundColor = [UIColor blueColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
    view.backgroundColor = [UIColor colorWithRed:rand() % 256 / 255.0 green:rand() % 256 / 255.0 blue:rand() % 256 / 255.0 alpha:1.0f];

    if (index == 0){
    
        view.backgroundColor = [UIColor orangeColor];

    }
    else if (index == 1){
    
        view.backgroundColor = [UIColor yellowColor];

    }
    else if (index == 2){
    
        view.backgroundColor = [UIColor blueColor];

    }
    else if (index == 3){
    
        view.backgroundColor = [UIColor cyanColor];

    }
    
    return view;
}


-(NSInteger)numberOfItemsInSlideView:(HSTabSlideView *)slideView
{
    return self.titleArray.count;
}


-(NSString *)tabSlideView:(HSTabSlideView *)slideView titleForItemAtIndex:(NSInteger)index
{
    return self.titleArray[index];
}


- (void)tabSlideView:(HSTabSlideView *)slideView didSelectItemAtIndex:(NSInteger)index
{
    //选择了某个item
}

- (CGFloat)tabSlideView:(HSTabSlideView *)slideView heightForItemAtIndex:(NSInteger)index
{
    return 200.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
