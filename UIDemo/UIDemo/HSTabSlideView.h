//
//  HSTabSlideView.h
//  UIDemo
//
//  Created by huangshan on 16/4/25.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HSSlideStyle) {
    
    HSSlideStyleZoom,          // 点击放大
    
    HSSlideStyleLine,        // 底部下划线
    
    HSSlideStyleShadow,     // 底部阴影图片
};

typedef void(^SelectBlock)(NSInteger);

typedef void(^ItemClickBlock)(NSInteger);


@interface HSTabItemView : UIView

/** 选择的item的文字的颜色 */
@property (nonatomic, strong) UIColor *selectItemColor;

/** 正常的item的文字的颜色 */
@property (nonatomic, strong) UIColor *normalItemColor;

/** 数据源数组 */
@property (nonatomic, strong) NSArray *dataArray;

/** 选择的index */
@property (nonatomic, assign) NSInteger selectIndex;

/** 选择的block */
@property (nonatomic, copy) SelectBlock selectBlock;

/** 点击的block */
@property (nonatomic, copy) ItemClickBlock itemClickBlock;

/** 初始化 */
-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)style;

@end


@interface HSTabContainView : UIView

@end



@class HSTabSlideView;

@protocol HSTabSlideViewDelegate <NSObject>

/** 每个item下的View */
-(UIView *)tabSlideView:(HSTabSlideView *)slideView viewForItemAtIndex:(NSInteger)index;

/** 总共的item的个数 */
-(NSInteger)numberOfItemsInSlideView:(HSTabSlideView *)slideView;

/** item的title文字 */
-(NSString *)tabSlideView:(HSTabSlideView *)slideView titleForItemAtIndex:(NSInteger)index;

@optional

/** 选择了哪个item */
- (void)tabSlideView:(HSTabSlideView *)slideView didSelectItemAtIndex:(NSInteger)index;

/** 哪个item的高度 */
- (CGFloat)tabSlideView:(HSTabSlideView *)slideView heightForItemAtIndex:(NSInteger)index;

/** 头部的栏目button点击 */
- (void)tabSlideView:(HSTabSlideView *)slideView didClickItemAtIndex:(NSInteger)index didClickItemView:(UIView *)view;

@end

@interface HSTabSlideView : UIView

@property (nonatomic, assign) id<HSTabSlideViewDelegate> delegate;

/** 是否循环播放，默认YES */
@property (nonatomic, assign) BOOL isCycle;

-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)slideStyle;

- (NSInteger)getCurrentIndex;

- (UIView *)getViewAtIndex:(NSInteger)index;

- (UIView *)getCurrentView;

-(void)reloadData;

@end
