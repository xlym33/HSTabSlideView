//
//  CustomCell.m
//  UIDemo
//
//  Created by huangshan on 16/4/25.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 30)];
        self.titleLabel.textColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {

    if (_title != title){
    
        _title = title;
        
        self.titleLabel.text = title;
    }
}

@end
