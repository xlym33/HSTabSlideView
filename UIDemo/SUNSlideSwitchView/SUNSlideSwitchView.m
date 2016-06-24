//
//  SUNSlideSwitchView.h
//  SUNSliderViewDemo
//
//  Created by huangshan on 15/9/17.
//  Copyright (c) 2015年 huangshan. All rights reserved.
//

#import "SUNSlideSwitchView.h"

typedef void (^CompleteBlock)(BOOL finish);


static const CGFloat kHeightOfTopScrollView = 37.0f;

/**
 *  @brief  rightButton最右侧按钮的tag值
 */
static const NSUInteger kTagOfRightSideButton = 999;

@interface SUNSlideSwitchView()
{
    CGFloat kWidthOfButtonMargin;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
}

@end

@implementation SUNSlideSwitchView


-(void)dealloc
{
    self.topScrollView = nil;
    
    self.rootScrollView = nil;
    
    self.viewArray = nil;
}

#pragma mark - 初始化参数
-(instancetype)initWithFrame:(CGRect)frame withStyle:(SUNSliderViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self){
        [self initValues];
        self.sliderStyle = style;
    }
    return self;
}

-(void)setSliderStyle:(SUNSliderViewStyle)sliderStyle
{
    _sliderStyle = sliderStyle;
    switch (_sliderStyle) {
        case SUNSliderViewStyleZoom:
        {
            
        }
            break;
        case SUNSliderViewStyleShadowImage:
        {
            [self createShadowImageView];
        }
            break;
        case SUNSliderViewStyleLine:
        {
            [self createMoveLine];
        }
            break;
            
        default:
            break;
    }
}
- (void)initValues
{
    /**
     *  @brief  创建顶部可滑动的tab
     */
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    
    
    /**
     *  @brief  创建主滚动视图
     */
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView, self.bounds.size.width, self.bounds.size.height - kHeightOfTopScrollView)];
    _rootScrollView.backgroundColor = [UIColor clearColor];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _userContentOffsetX = 0;
    
    /**
     *  @brief  创建底部线条
     */
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeightOfTopScrollView - 0.5, self.bounds.size.width, 0.5)];
    _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_bottomLineView];
    
    [self addSubview:_rootScrollView];
    
    _viewArray = [[NSMutableArray alloc] init];
    
    
    /**
     *  @brief  初始化
     */
    _isBuildUI = NO;
    _isNeighborMargin = NO;
    _tabTitleFont = [UIFont systemFontOfSize:15];
    _sliderStyle = SUNSliderViewStyleZoom;
    _moveLineViewColor = [UIColor lightGrayColor];
    _tabItemWidth = 0.0f;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

-(void)updateFrame:(CGRect)frame
{
    self.frame = frame;
        
    _rootScrollView.frame = CGRectMake(0, kHeightOfTopScrollView, frame.size.width, frame.size.height - kHeightOfTopScrollView);
    
    //更新主视图各个子视图的宽度
    for (int i = 0; i < [_viewArray count]; i++) {
        
        UIViewController *viewController = _viewArray[i];
        
        viewController.view.frame = CGRectMake(0 + _rootScrollView.bounds.size.width * i,
                                               0,
                                               CGRectGetWidth(_rootScrollView.bounds),
                                               CGRectGetHeight(_rootScrollView.bounds));
        
        [viewController.view layoutIfNeeded];
        
    }


}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
    
}
-(void)setMoveLineViewColor:(UIColor *)moveLineViewColor
{
    _moveLineViewColor = moveLineViewColor;
    _moveLineView.backgroundColor = _moveLineViewColor;
}
-(void)setShadowImage:(UIImage *)shadowImage
{
    _shadowImage = nil;
    _shadowImage = shadowImage;
    self.shadowImageView.image = shadowImage;
}

-(void)setTabItemNormalColor:(UIColor *)tabItemNormalColor
{
    _tabItemNormalColor = tabItemNormalColor;
    for (int i = 0; i < [self.slideSwitchViewDelegate namesOfTab:self].count; i ++) {
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:100 + i];
        [button setTitleColor:_tabItemNormalColor forState:UIControlStateNormal];
    }
}

-(void)setTabItemSelectedColor:(UIColor *)tabItemSelectedColor
{
    _tabItemSelectedColor = tabItemSelectedColor;
    for (int i = 0; i < [self.slideSwitchViewDelegate namesOfTab:self].count; i ++) {
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:100 + i];
        [button setTitleColor:_tabItemSelectedColor forState:UIControlStateSelected];
    }
}

-(void)setTabItemNormalBackgroundImage:(UIImage *)tabItemNormalBackgroundImage
{
    _tabItemNormalBackgroundImage = tabItemNormalBackgroundImage;
    for (int i = 0; i < [self.slideSwitchViewDelegate namesOfTab:self].count; i ++) {
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:100 + i];
        [button setBackgroundImage:_tabItemNormalBackgroundImage forState:UIControlStateNormal];
    }
}

-(void)setTabItemSelectedBackgroundImage:(UIImage *)tabItemSelectedBackgroundImage
{
    _tabItemSelectedBackgroundImage = tabItemSelectedBackgroundImage;
    for (int i = 0; i < [self.slideSwitchViewDelegate namesOfTab:self].count; i ++) {
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:100 + i];
        [button setBackgroundImage:_tabItemSelectedBackgroundImage forState:UIControlStateSelected];
    }
}

- (void)setTabTitle:(NSString *)title tabIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[_topScrollView viewWithTag:100 + index];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
}


#pragma mark - 选中那个页面
-(void)selectIndex:(NSInteger)index
{
    if (index >= _viewArray.count){
    
        return;
    }

    UIViewController *viewController = _viewArray[index];
    
//    [_rootScrollView scrollRectToVisible:viewController.view.frame animated:YES];
    
    [_rootScrollView setContentOffset:CGPointMake(viewController.view.frame.origin.x, 0)];

}

#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            
            //调整右侧按钮的frame
            _rigthSideButton.frame = CGRectMake(
                                                CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rigthSideButton.bounds),
                                                0,
                                                CGRectGetWidth(_rigthSideButton.bounds),
                                                CGRectGetHeight(_topScrollView.bounds));
            
            //调整topScrollView的frame
            _topScrollView.frame = CGRectMake(
                                              0,
                                              0,
                                              CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rigthSideButton.bounds),
                                              kHeightOfTopScrollView);
        }
        
        //更新主视图的总宽度
        _rootScrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewArray count], 0);
        
        //更新主视图各个子视图的宽度
        for (int i = 0; i < [_viewArray count]; i++) {
            
            UIViewController *viewController = _viewArray[i];
            viewController.view.frame = CGRectMake(0 + _rootScrollView.bounds.size.width * i,
                                                   0,
                                                   CGRectGetWidth(_rootScrollView.bounds),
                                                   CGRectGetHeight(_rootScrollView.bounds));
            
        }
        
        //滚动到选中的视图
        [_rootScrollView setContentOffset:CGPointMake((_userSelectedChannelID - 100) * self.bounds.size.width, 0) animated:NO];
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
    }
}

/**
 *  @brief  创建子视图UI
 */
- (void)buildUI
{
    //创建视图View加到rootScrollView上面
    NSUInteger number = [self.slideSwitchViewDelegate numberOfTab:self];
    for (int i=0; i<number; i++) {
        
        UIViewController *viewController= [self.slideSwitchViewDelegate slideSwitchView:self viewOfTab:i];
        [_viewArray addObject:viewController];
        [_rootScrollView addSubview:viewController.view];
    }
    
    //创建topScrollView的Button
    [self createNameButtons];
    
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
    
    //创建完毕将_isBuildUI 置为YES
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}


/**
 *  @brief  初始化顶部tab的各个按钮
 */
- (void)createNameButtons
{
    
    kWidthOfButtonMargin = 0.0f;
    CGFloat textWidth = 0.0f;
    
    /**
     *  @brief  计算文字总宽度
     */
    for (NSString *str in [self.slideSwitchViewDelegate namesOfTab:self]){
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(_topScrollView.bounds), kHeightOfTopScrollView) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_tabTitleFont} context:nil].size;
        textWidth += textSize.width;
    }
    
    /**
     *  @brief  如果设置了每个item的宽度，则以每个item的宽度为准，如果没有设置，则以每个item的文字宽度为准
     */
    if (_tabItemWidth * (_viewArray.count) > textWidth){
        textWidth = _tabItemWidth * (_viewArray.count);
    }
    
    
    //如果是平铺的状态
    if (_isNeighborMargin){
        kWidthOfButtonMargin = 0.0f;
        _tabItemWidth = self.bounds.size.width / (_viewArray.count);
    }
    else {
        /**
         *  @brief  计算每个item的间距
         */
        kWidthOfButtonMargin = (CGRectGetWidth(_topScrollView.bounds)  - (self.leftMargin + self.rightMargin) - textWidth) / ([self.slideSwitchViewDelegate namesOfTab:self].count - 1);
        if (kWidthOfButtonMargin <= 0){
            kWidthOfButtonMargin = 20;
        }
    }
    
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = self.leftMargin;
    
    //每个tab偏移量
    CGFloat xOffset = topScrollViewContentWidth;
    for (int i = 0; i < [_viewArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonWidth = 0.0f;
        
        //button的宽度，若是设置了Button的宽度，则以tabItem的宽度为准
        if (_tabItemWidth > 0){
            buttonWidth = _tabItemWidth;
        }
        else {
            
            //如果没有设置宽度，则以文字为准
            buttonWidth = [[self.slideSwitchViewDelegate namesOfTab:self][i] boundingRectWithSize:CGSizeMake(CGRectGetWidth(_topScrollView.bounds), kHeightOfTopScrollView) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_tabTitleFont} context:nil].size.width;
        }
        //设置按钮尺寸
        [button setFrame:CGRectMake(xOffset,
                                    0,
                                    buttonWidth,
                                    kHeightOfTopScrollView)];
        
        //累计每个tab文字的长度
        if (i == [_viewArray count] - 1){
            topScrollViewContentWidth += buttonWidth;
        }
        else {
            topScrollViewContentWidth += kWidthOfButtonMargin + buttonWidth;
        }
        
        //计算下一个tab的x偏移量
        xOffset += kWidthOfButtonMargin + buttonWidth;
        
        [button setTag:i+100];
        if (i == 0) {
            switch (self.sliderStyle) {
                case SUNSliderViewStyleZoom:
                {
                    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
                    break;
                case SUNSliderViewStyleLine:
                {
                    self.moveLineView.frame = CGRectMake(button.frame.origin.x, kHeightOfTopScrollView - 2, button.frame.size.width, 2);
                }
                    break;
                case SUNSliderViewStyleShadowImage:
                {
                    self.shadowImageView.frame = button.frame;
                }
                    break;
                    
                default:
                    break;
            }
            
            button.selected = YES;
        }
        
        [button setTitle:[self.slideSwitchViewDelegate namesOfTab:self][i] forState:UIControlStateNormal];
        button.titleLabel.font = _tabTitleFont;
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
    }
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth + self.rightMargin, kHeightOfTopScrollView);
}


#pragma mark - 顶部滚动视图逻辑方法

/**
 *  @brief  选中tabBar的第几个Button
 *
 *  @param sender 选中Button
 */
- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮，将之前的按钮置为不选中状态
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        
        //设置动画效果
        switch (self.sliderStyle) {
            case SUNSliderViewStyleZoom:
            {
                [UIView animateWithDuration:0.8 animations:^{
                    lastButton.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
                break;
            default:
                break;
        }
        
        
        //赋值选中按钮的ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        
        //将按钮置为选中撞他
        sender.selected = YES;
        
        //设置动画效果
        
        [UIView animateWithDuration:0.25 animations:^{
            
            switch (self.sliderStyle) {
                case SUNSliderViewStyleZoom:
                {
                    sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
                    break;
                case SUNSliderViewStyleLine:
                {
                    _moveLineView.frame = CGRectMake(sender.frame.origin.x, kHeightOfTopScrollView - 2, sender.frame.size.width, 2);
                }
                    break;
                case SUNSliderViewStyleShadowImage:
                {
                    _shadowImageView.frame = sender.frame;
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
        } completion:^(BOOL finished) {
            if (finished) {
                //动画结束后，设置新页出现
                if (!_isRootScroll) {
                    [_rootScrollView setContentOffset:CGPointMake((sender.tag - 100)*self.bounds.size.width, 0) animated:YES];
                }
                _isRootScroll = NO;
                
                //按钮的选中状态
                if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        _isRootScroll = NO;
        
    }
}

/**
 *  @brief  调整顶部滚动视图x位置
 *
 *  @param sender 选中的按钮
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    if (_topScrollView.contentSize.width <= _topScrollView.frame.size.width){
        return;
    }
    
    if (sender.frame.origin.x - _topScrollView.contentOffset.x >= (_topScrollView.bounds.size.width / 2)){
        
        
        CGRect rect =  [_topScrollView convertRect:sender.frame toView:self];
        CGFloat offset = rect.origin.x - (_topScrollView.frame.size.width / 2 - sender.frame.size.width / 2);
        if (offset + _topScrollView.contentOffset.x + _topScrollView.bounds.size.width >= _topScrollView.contentSize.width){
            [_topScrollView setContentOffset:CGPointMake((_topScrollView.contentSize.width - _topScrollView.bounds.size.width), 0) animated:YES];
        }
        else {
            [_topScrollView setContentOffset:CGPointMake((_topScrollView.contentOffset.x + offset), 0) animated:YES];
        }
    }
    else {
        CGRect rect =  [_topScrollView convertRect:sender.frame toView:self];
        CGFloat offset = (_topScrollView.frame.size.width / 2 - sender.frame.size.width / 2) - rect.origin.x;
        if (_topScrollView.contentOffset.x - offset <= 0){
            [_topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x - offset, 0) animated:YES];
        }
    }
    
    //如果 当前显示的最后一个tab文字超出右边界
    //    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+sender.bounds.size.width)) {
    //        //向左滚动视图，显示完整tab文字
    //        if (sender.frame.origin.x + sender.frame.size.width + kWidthOfButtonMargin >= _topScrollView.contentSize.width){
    //            [_topScrollView setContentOffset:CGPointMake((_topScrollView.contentSize.width - _topScrollView.bounds.size.width), 0) animated:YES];
    //        }
    //        else {
    //            [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    //        }
    //    }
    //
    //    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    //    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
    //        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
    //        if (sender.frame.origin.x - kWidthOfButtonMargin <= 0){
    //            [_topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //        }
    //        else {
    //            [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    //        }
    //    }
    
}

#pragma mark 主视图逻辑方法

//滚动视图开始时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//滚动视图结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
    }
}

//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _isRootScroll = YES;
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/self.bounds.size.width +100;
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:tag];
        [self selectNameButton:button];
    }
}

//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
    if (panParam.state == UIGestureRecognizerStateBegan){
        return;
    }
    else if (panParam.state == UIGestureRecognizerStateEnded){
        if ([panParam translationInView:_rootScrollView].x > 50){
            if (self.slideSwitchViewDelegate
                && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panLeftEdge:)]) {
                [self.slideSwitchViewDelegate slideSwitchView:self panLeftEdge:panParam];
            }
        }
        else if ([panParam translationInView:_rootScrollView].x < -50){
            if (self.slideSwitchViewDelegate
                && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:panRightEdge:)]) {
                [self.slideSwitchViewDelegate slideSwitchView:self panRightEdge:panParam];
            }
            
        }
    }
}


#pragma mark ---createViews
-(void)createMoveLine
{
    self.moveLineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.moveLineView.backgroundColor = _moveLineViewColor;
    [self.topScrollView addSubview:self.moveLineView];
}

-(void)createShadowImageView
{
    self.shadowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.shadowImageView.backgroundColor = [UIColor lightGrayColor];
    [self.topScrollView addSubview:self.shadowImageView];
}

#pragma mark - 工具方法

/**
 *	@brief	通过16进制计算颜色
 *
 *	@param 	inColorString 	16进制的字符串，长度为6
 *
 *	@return	颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

@end
