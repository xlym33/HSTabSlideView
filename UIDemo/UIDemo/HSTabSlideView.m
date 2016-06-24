//
//  HSTabSlideView.m
//  UIDemo
//
//  Created by huangshan on 16/4/25.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import "HSTabSlideView.h"


#pragma mark - ====================HSTabItemView===========================

#define MARGIN 15.0f

#define MAXCOUNT 6

@interface HSTabItemView ()



/** 类型 */
@property (nonatomic, assign) HSSlideStyle style;

/** 滑动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;

/** button的个数 */
@property (nonatomic, strong) NSMutableArray *buttonArray;

/** 滑动的线条 */
@property (nonatomic, strong) UIView *moveLineView;

/** 滑动的imageView */
@property (nonatomic, strong) UIImageView *moveImageView;

/** button的宽度 */
@property (nonatomic, assign) CGFloat kWidthOfButton;

/** 下面的小线条 */
@property (nonatomic, strong) UIView *lineView;

/** 内部记录的选择的index */
@property (nonatomic, assign) NSInteger UDIndex;

/** 移动线条的颜色 */
@property (nonatomic, strong) UIColor *moveLineColor;

@end

@implementation HSTabItemView

-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)style
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.style = style;
        
        self.UDIndex = 0;
        
        [self initValues];
        
    }
    return self;
}

-(void)initValues
{
    self.backgroundColor = [UIColor clearColor];
    
    self.selectItemColor = [UIColor redColor];
    
    self.normalItemColor = [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1.0];
    
    self.moveLineColor = [UIColor redColor];
    
    self.buttonArray = [NSMutableArray arrayWithCapacity:0];
    
    [self addSubview:self.lineView];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置滑动视图frame
    
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    self.lineView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - 1.0f), CGRectGetWidth(self.frame), 1.0f);
    
    
    if (self.dataArray.count){
        
        //获取数组元素个数
        
        NSInteger count = self.dataArray.count;
        
        //根据视图大小 和 标签个数 计算其占用宽度 (标签个数大于maxCount个 平均宽度按maxCount个计算)
        
        NSInteger deCount =  (count <= MAXCOUNT ? count : MAXCOUNT);
        
        self.kWidthOfButton = (self.frame.size.width - (deCount - 1) * MARGIN) / (deCount);
        
        //循环遍历button 设置其frame尺寸
        
        for (NSInteger index = 0; index < self.buttonArray.count; index ++) {
            
            UIButton *button = (UIButton *)self.buttonArray[index];
            
            [self buttonDefaultStyle:button];
            
            button.frame = CGRectMake((self.kWidthOfButton + MARGIN) * index, self.scrollView.frame.origin.y, self.kWidthOfButton, self.scrollView.frame.size.height);
            
            if (self.UDIndex == index){
                
                [self buttonClickStyle:button];
            }
        }
        
        //设置滑动视图内容大小
        
        self.scrollView.contentSize = CGSizeMake((self.kWidthOfButton + MARGIN) * count - MARGIN, self.scrollView.frame.size.height);
        
        //设置下划线视图frame
        
        self.moveLineView.frame = CGRectMake((self.kWidthOfButton + MARGIN) * self.UDIndex , self.scrollView.frame.size.height - 3, self.kWidthOfButton, 3);
        
        //设置阴影视图的frame
        self.moveImageView.frame = CGRectMake((self.kWidthOfButton + MARGIN) * self.UDIndex , self.scrollView.frame.size.height - 3, self.kWidthOfButton, self.scrollView.frame.size.height);
    }
}


#pragma mark - 设置dataArray

-(void)setDataArray:(NSArray *)dataArray{
    
    if (_dataArray != dataArray) {
        
        _dataArray = dataArray;
        
    }
    
    //清除所有视图
    
    [self removeAllViews];
    
    //计算数据 加载button
    
    [self loadButton];
    
}


#pragma mark - 删除所有视图

- (void)removeAllViews{
    
    NSArray *subViews = [self.scrollView subviews];
    
    for (UIView *subView in subViews) {
        
        [subView removeFromSuperview];
        
    }
    
    [self.buttonArray removeAllObjects];
}

#pragma mark - 加载button

-(void)loadButton{
    
    //获取数组元素个数
    
    NSInteger count = self.dataArray.count;
    
    if (count > 0) {
        
        //根据视图大小 和 标签个数 计算其占用宽度 (标签个数大于6个 平均宽度按6个计算)
        
        NSInteger deCount =  (count <= MAXCOUNT ? count : MAXCOUNT);
        
        self.kWidthOfButton = (self.frame.size.width - (deCount - 1) * MARGIN) / (deCount);
        
        //循环初始化button
        
        for (int i = 0; i < count; i++) {
            
            //初始化BUTTON
            
            UIButton *button = [self createButtonWithFrame:CGRectMake((self.kWidthOfButton + MARGIN) * i, self.scrollView.frame.origin.y, self.kWidthOfButton, self.scrollView.frame.size.height) title:self.dataArray[i]];
            
            button.tag = 2000 + i;
            
        }
        
        //设置滑动视图内容大小
        
        self.scrollView.contentSize = CGSizeMake((self.kWidthOfButton + MARGIN) * count , CGRectGetHeight(self.frame));
        
        //设置下划线视图frame
        
        self.moveLineView.frame = CGRectMake((self.kWidthOfButton + MARGIN) * self.UDIndex , CGRectGetHeight(self.frame) - 3 , self.kWidthOfButton, 3);
        
    }
    
}


#pragma mark - 创建button

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    
    //初始化BUTTON
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    CGFloat fontSize = 17.0f;
    
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    button.backgroundColor = [UIColor clearColor];
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置样式
    
    [self buttonDefaultStyle:button];
    
    //设置下划线与button的层级
    
    [self.scrollView insertSubview:button belowSubview:self.moveLineView];
    
    //添加创建好的button到button数组
    
    [self.buttonArray addObject:button];
    
    return button;
    
    
}

#pragma mark - button默认样式

- (void)buttonDefaultStyle:(UIButton *)button{
    
    //设置选中button的字体颜色
    
    [button setTitleColor:self.normalItemColor forState:UIControlStateNormal];
    
    //判断标签导航栏样式
    
    switch (self.style) {
            
        case HSSlideStyleZoom:
            
            //隐藏下划线视图
            
            self.moveLineView.hidden = YES;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = YES;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1];
            
            break;
            
        case HSSlideStyleLine:
            
            //显示下划线视图
            
            self.moveLineView.hidden = NO;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = YES;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1];
            
            //下划线移动
            
            [self moveLineViewMove:button.center.x];
            
            break;
            
        case HSSlideStyleShadow:
            
            //显示下划线视图
            
            self.moveLineView.hidden = YES;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = NO;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1];
            
            //下划线移动
            
            [self moveImageViewMove:button.frame.origin.x];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - button点击样式

- (void)buttonClickStyle:(UIButton *)button{
    
    //设置选中button的字体颜色
    
    [button setTitleColor:self.selectItemColor forState:UIControlStateNormal];
    
    
    //如果 当前显示的最后一个tab文字超出右边界
    if (button.frame.origin.x - self.scrollView.contentOffset.x > self.bounds.size.width - (self.kWidthOfButton + button.bounds.size.width)) {
        
        //向左滚动视图，显示完整tab文字
        if (button.frame.origin.x + button.frame.size.width + self.kWidthOfButton >= self.scrollView.contentSize.width){
            
            [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentSize.width - self.scrollView.bounds.size.width), 0) animated:YES];
        }
        else {
            
            [self.scrollView setContentOffset:CGPointMake(button.frame.origin.x - (self.scrollView.bounds.size.width- (self.kWidthOfButton + button.bounds.size.width)), 0)  animated:YES];
        }
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (button.frame.origin.x - self.scrollView.contentOffset.x < self.kWidthOfButton) {
        
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        if (button.frame.origin.x - self.kWidthOfButton <= 0){
            
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else {
            
            [self.scrollView setContentOffset:CGPointMake(button.frame.origin.x - self.kWidthOfButton, 0)  animated:YES];
        }
    }
    
    //判断标签导航栏样式
    
    switch (self.style) {
            
        case HSSlideStyleZoom:
            
            //隐藏下划线视图
            
            self.moveLineView.hidden = YES;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = YES;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1.2];
            
            break;
            
        case HSSlideStyleLine:
            
            //显示下划线视图
            
            self.moveLineView.hidden = NO;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = YES;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1.2];
            
            //下划线移动
            
            [self moveLineViewMove:button.center.x];
            
            break;
            
        case HSSlideStyleShadow:
            
            //显示下划线视图
            
            self.moveLineView.hidden = YES;
            
            //隐藏阴影视图
            
            self.moveImageView.hidden = NO;
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1.2];
            
            //下划线移动
            
            [self moveImageViewMove:button.frame.origin.x];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - button缩放

- (void)buttonZoomWithButton:(UIButton*)button zoomScale:(CGFloat)scale
{
    
    [UIView animateWithDuration:0.4f animations:^{
        
        button.transform = CGAffineTransformMakeScale(scale, scale);
        
    }];
}

#pragma mark - button点击事件

- (void)buttonAction:(UIButton *)sender
{
    if (self.UDIndex < self.buttonArray.count){
        
        //将之前的button转换样式
        UIButton *preButton = [self.buttonArray objectAtIndex:self.UDIndex];
        
        [self buttonDefaultStyle:preButton];
        
        //现在的button，记录UDIndex
        self.UDIndex = sender.tag - 2000;
        
        //添加点击样式
        
        [self buttonClickStyle:sender];
        
        
        if (self.selectBlock){
            
            self.selectBlock(self.UDIndex);
        }
        
        if(self.itemClickBlock){
            
            self.itemClickBlock(self.UDIndex);
        }
        
    }
}

#pragma mark - 跳转到指定下标的位置

-(void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex < self.buttonArray.count){
        
        //将之前的button转换样式
        UIButton *preButton = [self.buttonArray objectAtIndex:self.UDIndex];
        
        [self buttonDefaultStyle:preButton];
        
        //记录现在的UDIndex
        self.UDIndex = selectIndex;
        
        //获取对应下标得button
        
        UIButton *curButton = [self.buttonArray objectAtIndex:self.UDIndex];
        
        //清除当前的样式
        [self buttonDefaultStyle:curButton];
        
        //修改样式
        [self buttonClickStyle:curButton];
        
        if (self.selectBlock){
            
            self.selectBlock(self.UDIndex);
        }
        
    }
}


#pragma mark - 阴影视图移动

- (void)moveImageViewMove:(CGFloat)x{
    
    //添加动画
    
    [UIView beginAnimations:@"moveImageViewMove" context:nil];
    
    //设置动画时长
    
    [UIView setAnimationDuration:0.2f];
    
    //设置下划线视图frame
    
    self.moveImageView.frame = CGRectMake(x , CGRectGetHeight(self.scrollView.frame) - 3 , CGRectGetWidth(self.moveImageView.frame) , CGRectGetHeight(self.moveImageView.frame));
    
    //提交动画
    
    [UIView commitAnimations];
    
}

#pragma mark - 下划线视图移动

- (void)moveLineViewMove:(CGFloat)x{
    
    //添加动画
    
    [UIView beginAnimations:@"moveLineViewMove" context:nil];
    
    //设置动画时长
    
    [UIView setAnimationDuration:0.2f];
    
    //设置下划线视图frame
    
    self.moveLineView.center = CGPointMake(x, CGRectGetHeight(self.scrollView.frame) - 3 / 2);
    
    //提交动画
    
    [UIView commitAnimations];
    
}


#pragma mark - Lazy Loading

-(UIScrollView *)scrollView
{
    if (_scrollView == nil){
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        _scrollView.pagingEnabled = NO;
        
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

-(UIView *)lineView
{
    if (_lineView == nil){
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 1.0f), CGRectGetWidth(self.frame), 1.0f)];
        
        _lineView.backgroundColor = [UIColor colorWithRed:(221.0 / 255.0) green:(221.0 / 255.0) blue:(221.0 / 255.0) alpha:1.0f];
    }
    
    return _lineView;
}

-(UIView *)moveLineView
{
    
    if (_moveLineView == nil) {
        
        //初始化下划线View
        
        _moveLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, 0, 3)];
        
        _moveLineView.backgroundColor = self.moveLineColor;
        
        [self.scrollView addSubview:_moveLineView];
        
    }
    
    return _moveLineView;
    
}

-(UIImageView *)moveImageView
{
    if (_moveImageView == nil){
        
        _moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.frame))];
        
        [self.scrollView addSubview:_moveImageView];
    }
    
    return _moveImageView;
}

@end



#pragma mark - ====================HSTabContainView===========================

@implementation HSTabContainView

@end




#pragma mark - ====================HSTabSlideView===========================


static CGFloat HeightOfTabItem = 37.0f;

#define  BackColor [UIColor colorWithRed:(238.0 / 255) green:(238.0 / 255) blue:(238.0 / 255) alpha:1.0f];

/** 占位 */
static NSString *KeepPlaceOfOwer = @"KeepPlaceOfOwer";

@interface HSTabSlideView ()<UIScrollViewDelegate>

/** 每个页面的viewController数组 */
@property (nonatomic, strong) NSMutableArray *viewsArray;

/** tab的样式 */
@property (nonatomic, assign) HSSlideStyle style;

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) HSTabItemView *tabItemView;

@property (nonatomic, assign) NSInteger numOfItem;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) HSTabContainView *currentContainView;

@property (nonatomic, strong) HSTabContainView *preContainView;

@property (nonatomic, strong) HSTabContainView *nextContainView;

@property (nonatomic, assign) NSInteger currenIndex;



@end

@implementation HSTabSlideView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)slideStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BackColor;
        
        self.titleArray = [NSMutableArray arrayWithCapacity:0];
        
        //循环
        self.isCycle = YES;
        
        //设置标签导航栏样式
        
        self.style = slideStyle;
        
        self.currenIndex = 0;
        
    }
    return self;
}

-(void)reloadData
{
    [_tabItemView removeFromSuperview];
    
    _tabItemView = nil;
    
    [self.titleArray removeAllObjects];
    
    for (UIView *subView in _currentContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in _preContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in _nextContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.tabItemView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), HeightOfTabItem);
    
    self.scrollView.frame = CGRectMake(0, HeightOfTabItem, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - HeightOfTabItem);
    
    self.nextContainView.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame) * 2, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    self.currentContainView.frame = CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    self.preContainView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
}

#pragma mark - 设置当前的index

-(void)setCurrenIndex:(NSInteger)currenIndex
{
    if (_currenIndex != currenIndex){
        
        _currenIndex = currenIndex;
    }
    
    _tabItemView.selectIndex = currenIndex;
    
}

-(void)changeContainViewFrameWithTabItemViewSelectIndex:(NSInteger)index
{
    for (UIView *subView in self.currentContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in self.preContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in self.nextContainView.subviews) {
        
        [subView removeFromSuperview];
    }
    
    
    NSInteger preIndex = [self getPreIndex:index];
    
    NSInteger nextIndex = [self getNextIndex:index];
    
    
    if (index == 0 && self.isCycle == NO){
    
        //不循环且是第一个item时候
        self.scrollView.contentSize = CGSizeMake(2 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        [self addViewOfContainView:self.preContainView index:index];
        
        [self addViewOfContainView:self.currentContainView index:nextIndex];
        
        self.scrollView.contentOffset = CGPointMake(0, 0);

    }
    else if (index == self.numOfItem - 1 && self.isCycle == NO){
    
        //不循环且是最后一个item的时候
        self.scrollView.contentSize = CGSizeMake(2 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        [self addViewOfContainView:self.preContainView index:preIndex];
        
        [self addViewOfContainView:self.currentContainView index:index];
        
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    }
    else {
    
        //其他情况
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        [self addViewOfContainView:self.preContainView index:preIndex];
        
        [self addViewOfContainView:self.nextContainView index:nextIndex];
        
        [self addViewOfContainView:self.currentContainView index:index];
        
        //获取选中的下标 并设置内容视图相应的页面显示
        
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);

    }

}

-(void)addViewOfContainView:(HSTabContainView *)containView index:(NSInteger)index
{
    //判断视图数据源数组中是否存在相应视图
    
    if (self.viewsArray.count > index) {
        
        //判断是否不等于占位数据
        
        id obj = [self.viewsArray objectAtIndex:index];
        
        if (![obj isKindOfClass:[UIView class]]){
            
            //获取相应视图 并添加到containView上 然后加到数组里
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabSlideView:viewForItemAtIndex:)]) {
                
                //获取视图
                
                UIView *view = [self.delegate tabSlideView:self viewForItemAtIndex:index];
                
                //判断该视图是否存在
                
                if ([self.viewsArray indexOfObject:view] == NSNotFound) {
                    
                    
                    [self changeContainViewFrameWithIndex:index view:view containView:containView];
                    
                    //将获取的视图到视图数据源数组的指定下标
                    
                    [self.viewsArray replaceObjectAtIndex:index withObject:view];
                }
            }
        }
        else {
            
            [self changeContainViewFrameWithIndex:index view:obj containView:containView];
        }
    }
}

-(void)changeContainViewFrameWithIndex:(NSInteger)index view:(UIView *)view containView:(HSTabContainView *)containView
{
    
    //替换高度
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabSlideView:heightForItemAtIndex:)]){
        
        height = [self.delegate tabSlideView:self heightForItemAtIndex:index];
    }
    
    //设置视图位置
    
    view.frame = CGRectMake(0, 0, CGRectGetWidth(containView.frame), height);
    
    [containView addSubview:view];
}

#pragma mark - 上一张

-(NSInteger)getPreIndex:(NSInteger)index
{
    if (index == 0){
        
        if (self.isCycle){
            
            //循环
            return self.numOfItem - 1;
            
        }
        else {
            
            //不循环
            return 0;
        }
    }
    
    return index - 1;
    
}

- (void)playLastContainView
{
    self.currenIndex = [self getPreIndex:self.currenIndex];
}

#pragma mark - 下一张

- (void)playNextContainView
{
    self.currenIndex = [self getNextIndex:self.currenIndex];
}

-(NSInteger)getNextIndex:(NSInteger)index
{
    if (index == self.numOfItem - 1){
        
        if (self.isCycle){
            
            return 0;
            
        }
        else {
            
            return self.numOfItem - 1;
        }
    }
    
    return index + 1;
    
}

#pragma mark - 滑动视图滑动结束处理

- (void)scrollViewDidEndScrollingHandle{
    
    NSInteger page = self.scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    
    //判断左滑动还是右滑动
    
    switch (page) {
            
        case 0:
            
            [self playLastContainView];
            
            break;
            
        case 1:
            
            //当不循环的时候，且是第一个item的时候，播放下一个item
            if (self.currenIndex == 0){
            
                [self playNextContainView];
            }
            else if (self.currenIndex == self.numOfItem - 1){
            
            }
            
            break;
            
        case 2:
            
            [self playNextContainView];
            
            break;
            
        default:
            break;
    }
    
    
//    //还原滑动视图偏移量
//    
//    CGPoint point = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
//    
//    [self.scrollView setContentOffset:point animated:NO];
    
    
}



#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    
}

//滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingHandle];
    
}

//当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingHandle];
    
}

#pragma mark - 公共方法

//获取当前下标

- (NSInteger)getCurrentIndex
{
    
    return self.currenIndex;
    
}

//根据下标 获取指定视图对象

- (UIView *)getViewAtIndex:(NSInteger)index
{
    if (self.viewsArray) {
        
        if (index < self.viewsArray.count) {
            
            id obj = [self.viewsArray objectAtIndex:index];
            
            return obj;
        }
    }
    
    return nil;
    
}

//获取当前下标的视图对象

- (UIView *)getCurrentView
{
    return [self getViewAtIndex:[self getCurrentIndex]];
    
}


#pragma mark - Lazy Loading

-(UIScrollView *)scrollView
{
    if (_scrollView == nil){
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HeightOfTabItem, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - HeightOfTabItem)];
        
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.delegate = self;
        
        _scrollView.bounces = NO;
        
        _scrollView.directionalLockEnabled = YES;
        
        _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        _scrollView.pagingEnabled = YES;
        
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

-(HSTabItemView *)tabItemView
{
    if (_tabItemView == nil){
        
        _tabItemView = [[HSTabItemView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), HeightOfTabItem) slideStyle:self.style];
        
        [self addSubview:_tabItemView];
        
        
        self.viewsArray = [NSMutableArray arrayWithCapacity:0];
        
        //获取标签数据源数组
        
        for (NSInteger i = 0 ; i < self.numOfItem ; i ++) {
            
            //先判断代理是否存在 并且 是否实现了方法
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabSlideView:titleForItemAtIndex:)]) {
                
                //获取标签标题
                
                NSString *titleStr = [self.delegate tabSlideView:self titleForItemAtIndex:i];
                
                //添加到标签数据源数组
                
                [self.titleArray addObject:titleStr];
                
            }
            
            //为视图数据源数组添加占位数据
            
            [self.viewsArray addObject:KeepPlaceOfOwer];
            
        }
        
        _tabItemView.dataArray = self.titleArray;
        
        
        //标签导航栏视图回调block实现
        
        __block typeof(self) blockSelf = self;
        
        _tabItemView.itemClickBlock = ^(NSInteger clickIndex){
            
            if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(tabSlideView:didClickItemAtIndex:didClickItemView:)]) {
                
                //视图已经添加到滑动视图代理方法
                
                [blockSelf.delegate tabSlideView:blockSelf didClickItemAtIndex:clickIndex didClickItemView:[blockSelf getViewAtIndex:clickIndex]];
                
            }
            
        };
        
        _tabItemView.selectBlock = ^(NSInteger selectIndex){
            
            _currenIndex = selectIndex;
            
            //根据标签导航下标切换不同视图显示
            
            [blockSelf changeContainViewFrameWithTabItemViewSelectIndex:selectIndex];
            
            //先判断代理是否存在 并且 是否实现了方法
            
            if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(tabSlideView:didSelectItemAtIndex:)]) {
                
                //视图已经添加到滑动视图代理方法
                
                [blockSelf.delegate tabSlideView:blockSelf didSelectItemAtIndex:selectIndex];
                
            }
        };
        
        _tabItemView.selectIndex = 0;
        
    }
    
    return _tabItemView;
}

-(NSInteger)numOfItem
{
    //先判断代理是否存在 并且 是否实现了方法
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInSlideView:)]) {
        
        _numOfItem = [self.delegate numberOfItemsInSlideView:self];
        
        return _numOfItem;
        
    } else {
        
        return _numOfItem = 0;
        
    }
}

-(HSTabContainView *)preContainView
{
    if (_preContainView == nil){
        
        _preContainView = [[HSTabContainView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        
        [self.scrollView addSubview:_preContainView];
    }
    
    return _preContainView;
}

-(HSTabContainView *)currentContainView
{
    if (_currentContainView == nil){
        
        _currentContainView = [[HSTabContainView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        
        [self.scrollView addSubview:_currentContainView];
    }
    
    return _currentContainView;
}

-(HSTabContainView *)nextContainView
{
    if (_nextContainView == nil){
        
        _nextContainView = [[HSTabContainView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) * 2, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        
        [self.scrollView addSubview:_nextContainView];
    }
    
    return _nextContainView;
}

@end
