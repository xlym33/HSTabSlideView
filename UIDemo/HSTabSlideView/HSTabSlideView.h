//
//  HSTabSlideView.h
//  UIDemo
//
//  Created by huangshan on 16/4/25.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HSSlideStyle) {
    
    HSSlideStyleZoom,        // 点击放大
    
    HSSlideStyleLine,        // 底部下划线
    
    HSSlideStyleLineAdaptText,   // 底部下划线适应文字宽度

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

/** 选择的block */
@property (nonatomic, copy) SelectBlock selectBlock;

/** 点击的block */
@property (nonatomic, copy) ItemClickBlock itemClickBlock;

/** 初始化 */
-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)style;

/** 设置选中的index */
- (void)configSelectIndex:(NSInteger)index;

@end

@interface HSTabItemCollectionCell : UICollectionViewCell

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 类型 */
@property (nonatomic, assign) HSSlideStyle style;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 选择的item的文字的颜色 */
@property (nonatomic, strong) UIColor *selectItemColor;

/** 正常的item的文字的颜色 */
@property (nonatomic, strong) UIColor *normalItemColor;

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

/** 是否循环播放，默认YES，当item的个数为1时不循环 */
@property (nonatomic, assign) BOOL isCycle;

/** 文字之间的间隔 */
@property (nonatomic, assign) CGFloat margin;

/** 头部文字的insets */
@property (nonatomic, assign) UIEdgeInsets insets;

/** 每一页的最大的显示个数 */
@property (nonatomic, assign) NSInteger maxCount;

/** 初始化，加上style */
-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)slideStyle;

- (NSInteger)getCurrentIndex;

- (UIView *)getViewAtIndex:(NSInteger)index;

- (UIView *)getCurrentView;

- (void)reloadData;

@end
