//
//  SUNSlideSwitchView.h
//  SUNSliderViewDemo
//
//  Created by huangshan on 15/9/17.
//  Copyright (c) 2015年 huangshan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 标签导航栏样式
 */

typedef enum : NSUInteger  {
    
    /**
     *  @brief  选中选项放大样式
     */
    
    SUNSliderViewStyleZoom,
    
    /**
     *  @brief  下划线样式
     */
    
    SUNSliderViewStyleLine,
    
    
    /**
     *  @brief  底部的阴影的图
     */
    SUNSliderViewStyleShadowImage,
    
    
} SUNSliderViewStyle;

@protocol SUNSlideSwitchViewDelegate;

@interface SUNSlideSwitchView : UIView<UIScrollViewDelegate>




/**
 *  @brief  底部主scrollView
 */
@property (nonatomic, strong) UIScrollView *rootScrollView;

/**
 *  @brief  顶部可滑动的scrollView
 */
@property (nonatomic, strong) UIScrollView *topScrollView;

/**
 *  @brief  顶部scrollView下面的线条
 */
@property (nonatomic, strong) UIView *bottomLineView;

/**
 *  @brief  rootScrollView的滑动偏移X
 */
@property (nonatomic, assign) CGFloat userContentOffsetX;

/**
 *  @brief  点击按钮选择的ID
 */
@property (nonatomic, assign) NSInteger userSelectedChannelID;


@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;

/**
 *  @brief  代理
 */
@property (nonatomic, weak ) id<SUNSlideSwitchViewDelegate> slideSwitchViewDelegate;

/**
 *  @brief  没有选中的颜色
 */
@property (nonatomic, strong) UIColor *tabItemNormalColor;

/**
 *  @brief  选中的颜色
 */
@property (nonatomic, strong) UIColor *tabItemSelectedColor;

/**
 *  @brief  没有选中的背景色
 */
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;

/**
 *  @brief  选中的背景色
 */
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;

/**
 *  @brief  tab底部的阴影图
 */
@property (nonatomic, strong) UIImage *shadowImage;

/**
 *  @brief  tab底部的阴影ImageView
 */
@property (nonatomic, strong) UIImageView *shadowImageView;

/**
 *  @brief  rootScrollView上的View数组
 */
@property (nonatomic, strong) NSMutableArray *viewArray;


/**
 *  @brief  右侧滑动的按钮
 */
@property (nonatomic, strong) UIButton *rigthSideButton;

/**
 *  @brief  topScrollView距离左边的距离
 */
@property (nonatomic, assign) CGFloat leftMargin;


/**
 *  @brief  topScrollView距离右边的距离
 */
@property (nonatomic, assign) CGFloat rightMargin;


/**
 *  @brief  每个tab的宽度
 */
@property (nonatomic, assign) CGFloat tabItemWidth;

/**
 *  @brief  每个tabTitle的font
 */
@property (nonatomic, strong) UIFont *tabTitleFont;

/**
 *  @brief  tabBar的样式
 */
@property (nonatomic, assign) SUNSliderViewStyle sliderStyle;


/**
 *  @brief  移动的下划线
 */
@property (nonatomic, strong) UIView *moveLineView;

/**
 *  @brief  移动的下划线颜色
 */
@property (nonatomic, strong) UIColor *moveLineViewColor;

/**
 *  @brief  两个相邻的item之间的距离为0，相等的item
 */
@property (nonatomic, assign) BOOL isNeighborMargin;

#pragma mark - method

/*!
 *  @brief 更新坐标
 *
 *  @param frame frame
 */
-(void)updateFrame:(CGRect)frame;


-(void)selectIndex:(NSInteger)index;

/**
 *  @brief  创建SUNSliderView
 *
 *  @param frame frame
 *  @param style 样式
 *
 *  @return sliderView
 */
-(instancetype)initWithFrame:(CGRect)frame withStyle:(SUNSliderViewStyle)style;


/**
 *	@brief	设置某个tab的文字信息
 *
 *	@param 	title 	文字信息
 *	@param 	index 	索引
 */
- (void)setTabTitle:(NSString *)title tabIndex:(NSInteger)index;






/**
 *  @brief  创建子视图UI
 */
- (void)buildUI;



/**
 *	@brief	通过16进制计算颜色
 *
 *	@param 	inColorString 	16进制的字符串，长度为6
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end

@protocol SUNSlideSwitchViewDelegate <NSObject>

@required


/**
 *  @brief  顶部tab个数
 *
 *  @param view 本控件
 *
 *  @return tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view;

/**
 *  @brief  顶部tab的title
 *
 *  @param view 本控件
 *
 *  @return 返回的是title的数组
 */
- (NSArray *)namesOfTab:(SUNSlideSwitchView *)view;


/**
 *  @brief  每个tab所属的ViewController
 *
 *  @param view   本控件
 *  @param number tab索引
 *
 *  @return 所属的ViewController
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional


/**
 *  @brief  滑动左边界时传递手势
 *
 *  @param view     本控件
 *  @param panParam 滑动的手势
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;



/**
 *  @brief  滑动右边界时传递手势
 *
 *  @param view     本控件
 *  @param panParam 滑动的手势
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;



/**
 *  @brief  点击tab
 *
 *  @param view   本控件
 *  @param number tab索引
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number;

@end
