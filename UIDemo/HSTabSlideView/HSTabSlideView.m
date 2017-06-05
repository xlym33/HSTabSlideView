//
//  HSTabSlideView.m
//  UIDemo
//
//  Created by huangshan on 16/4/25.
//  Copyright © 2016年 huangshan. All rights reserved.
//

#import "HSTabSlideView.h"


#pragma mark - ====================一些常量===========================

/** item的标题的字号 */
#define kTitleFont [UIFont systemFontOfSize:17.0f]

/** item选择后的颜色 */
#define kSelectItemColor [UIColor redColor]

/** item正常的颜色 */
#define kNormalItemColor [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1.0]

/** 移动的线条的颜色 */
#define kMoveLineColor [UIColor redColor]

/** 头部item的高度 */
#define kHeightOfTabItem 37.0f

/** 背景颜色 */
#define kBackgroundColor [UIColor colorWithRed:(238.0 / 255) green:(238.0 / 255) blue:(238.0 / 255) alpha:1.0f]



#pragma mark - ====================HSTabItemView===========================

static NSString *const HSTabItemCollectionCellID = @"HSTabItemCollectionCell";

@interface HSTabItemView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 类型 */
@property (nonatomic, assign) HSSlideStyle style;

/** 滑动视图 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** flowLayout */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** 滑动的线条 */
@property (nonatomic, strong) UIView *moveLineView;

/** 下面的小线条 */
@property (nonatomic, strong) UIView *lineView;

/** 内部记录的选择的index */
@property (nonatomic, assign) NSInteger UDIndex;

/** 移动线条的颜色 */
@property (nonatomic, strong) UIColor *moveLineColor;

/** 文字之间的间隔 */
@property (nonatomic, assign) CGFloat margin;

/** 头部文字的insets */
@property (nonatomic, assign) UIEdgeInsets insets;

/** 每一页的最大的显示个数 */
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation HSTabItemView

-(instancetype)initWithFrame:(CGRect)frame slideStyle:(HSSlideStyle)style {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.style = style;
        
        [self initValues];
        
    }
    return self;
}

-(void)initValues
{
    self.backgroundColor = [UIColor clearColor];
    
    self.selectItemColor = kSelectItemColor;
    
    self.normalItemColor = kNormalItemColor;
    
    self.moveLineColor = [UIColor redColor];
    
    self.margin = 0.0f;
    
    self.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.maxCount = 6;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置滑动视图frame
    
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    self.lineView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - 1.0f), CGRectGetWidth(self.frame), 1.0f);
}


#pragma mark - 设置

-(void)setDataArray:(NSArray *)dataArray{
    
    if (_dataArray != dataArray) {
        
        _dataArray = dataArray;
    }
    
    //重新加载数据
    
    [self.collectionView reloadData];
}

- (void)setMoveLineColor:(UIColor *)moveLineColor {
    
    _moveLineColor = moveLineColor;
    
    self.moveLineView.backgroundColor = _moveLineColor;
}

- (void)setUDIndex:(NSInteger)UDIndex {
    
    NSInteger index = _UDIndex;
    
    //切换视图样式
    HSTabItemCollectionCell *preCell = (HSTabItemCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_UDIndex inSection:0]];
    
    preCell.isSelected = NO;
    
    _UDIndex = UDIndex;
    
    HSTabItemCollectionCell *nowCell = (HSTabItemCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_UDIndex inSection:0]];
    
    nowCell.isSelected = YES;
    
    //移动的视图到中间
    if (index == 0 && UDIndex == self.dataArray.count - 1) {
        
        index = UDIndex;
    } else if (UDIndex == 0 && index == self.dataArray.count - 1) {
        
        index = UDIndex;
    } else if (UDIndex != 0 && UDIndex != self.dataArray.count - 1){
        
        if (_UDIndex > index){
            
            //右边栏目显示
            index = _UDIndex + 1;
        } else {
            
            //左边栏目显示
            index = _UDIndex - 1;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    [self moveItemChangeStyle];
}

/** 跳转到指定下标的位置 */
- (void)configSelectIndex:(NSInteger)selectIndex {
    
    if (selectIndex < self.dataArray.count){
        
        //记录现在的UDIndex
        self.UDIndex = selectIndex;
        
        if (self.selectBlock){
            
            self.selectBlock(self.UDIndex);
        }
    }
}

/** 下划线跟着滑动 */
- (void)configMoveLineViewWithScale:(CGFloat)scale {
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:_UDIndex inSection:0]];
    
    CGFloat x = floor(scale) * (attributes.frame.size.width + self.margin) + self.insets.left + attributes.frame.size.width / 2.0f + (scale - floor(scale)) * (attributes.frame.size.width + self.margin);
    
    self.moveLineView.center = CGPointMake(x, attributes.frame.size.height - 3.0f/2.0f);
}


#pragma mark - 移动的视图样式

- (void)moveItemChangeStyle{
    
    //判断标签导航栏样式
    
    switch (self.style) {
            
        case HSSlideStyleZoom: {
            
            //隐藏下划线视图
            
            self.moveLineView.hidden = YES;
        }
            break;
            
        case HSSlideStyleLine: {
            
            //显示下划线视图
            
            self.moveLineView.hidden = NO;
            
            //下划线移动
            
            UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:_UDIndex inSection:0]];
            
            [UIView animateWithDuration:0.2f animations:^{
                
                self.moveLineView.frame = CGRectMake(attributes.frame.origin.x, attributes.frame.size.height - 3.0f, attributes.frame.size.width, 3.0f);
            }];
        }
            break;
            
        case HSSlideStyleLineAdaptText: {
            
            //显示下划线视图
            
            self.moveLineView.hidden = NO;
            
            CGSize textSize = [self.dataArray[_UDIndex] boundingRectWithSize:CGSizeMake(100.0f, kHeightOfTabItem) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: kTitleFont} context:nil].size;
            
            //下划线移动
            
            UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:_UDIndex inSection:0]];
            
            [UIView animateWithDuration:0.2f animations:^{
                
                self.moveLineView.frame = CGRectMake(attributes.center.x - (textSize.width + 3.0f) / 2.0f, attributes.frame.size.height - 3.0f, (textSize.width + 3.0f), 3.0f);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HSTabItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HSTabItemCollectionCellID forIndexPath:indexPath];
    
    NSString *title = self.dataArray[indexPath.row];
    
    cell.title = title;
    
    cell.style = self.style;
    
    cell.normalItemColor = self.normalItemColor;
    
    cell.selectItemColor = self.selectItemColor;
    
    cell.isSelected = (self.UDIndex == indexPath.row) ? YES : NO;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.itemClickBlock){
        
        self.itemClickBlock(indexPath.row);
    }
    
    [self configSelectIndex:indexPath.row];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.margin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger count = self.dataArray.count > self.maxCount ? self.maxCount : self.dataArray.count;
    
    if (self.margin <= 0.0f){
        
        CGFloat width = (CGRectGetWidth(self.frame) - self.insets.left - self.insets.right) / count;
        
        return CGSizeMake(width, kHeightOfTabItem);
        
    } else {
        
        CGFloat width = (CGRectGetWidth(self.frame) - self.insets.left - self.insets.right - self.margin * (count - 1)) / count;
        
        return CGSizeMake(width, kHeightOfTabItem);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.insets;
}



#pragma mark - Lazy Loading

-(UICollectionViewFlowLayout *)flowLayout
{
    if (_flowLayout == nil){
        
        // 创建flowLayout
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //设置Cell的大小
        
        _flowLayout.itemSize = CGSizeMake(60.0f, kHeightOfTabItem);
        
        //设置单元格的左右最小间距
        
        _flowLayout.minimumInteritemSpacing = 0.0f;
        
        //设置单元格的上下最小间距
        
        _flowLayout.minimumLineSpacing = 0.0f;
        
        //设置滑动方向
        
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //设置边界
        
        _flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil){
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:self.flowLayout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[HSTabItemCollectionCell class] forCellWithReuseIdentifier:HSTabItemCollectionCellID];
        
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}


-(UIView *)lineView
{
    if (_lineView == nil){
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 1.0f), CGRectGetWidth(self.frame), 1.0f)];
        
        _lineView.backgroundColor = [UIColor colorWithRed:(221.0 / 255.0) green:(221.0 / 255.0) blue:(221.0 / 255.0) alpha:1.0f];
        
        [self addSubview:_lineView];
    }
    
    return _lineView;
}

-(UIView *)moveLineView {
    
    if (_moveLineView == nil) {
        
        //初始化下划线View
        
        _moveLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, 0, 3)];
        
        _moveLineView.backgroundColor = self.moveLineColor;
        
        [self.collectionView addSubview:_moveLineView];
        
    }
    
    return _moveLineView;
}

@end

#pragma mark - ====================HSTabItemCollectionCell===========================

@interface HSTabItemCollectionCell ()

/** 点击的button */
@property (nonatomic, strong) UIButton *button;

@end

@implementation HSTabItemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化数据
        [self initData];
        
        // 初始化子视图
        [self initSubview];
        
        // 设置自动布局
        [self configAutoLayout];
        
        // 设置主题模式
        [self configTheme];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
}

- (void)initData {
    
    
}

- (void)initSubview {
    
    //初始化BUTTON
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button.titleLabel.font = kTitleFont;
    
    self.button.backgroundColor = [UIColor clearColor];
    
    self.button.userInteractionEnabled = NO;
    
    [self.contentView addSubview:self.button];
}

- (void)configAutoLayout {
    
    
}

- (void)configTheme {
    
    
}

#pragma mark - Method

- (void)setTitle:(NSString *)title {
    
    if (_title != title){
        
        _title = title;
        
        [self.button setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    
    if (_isSelected != isSelected){
        
        _isSelected = isSelected;
        
        if (isSelected){
            
            [self buttonClickStyle:self.button];
            
        } else {
            
            [self buttonDefaultStyle:self.button];
        }
    }
}

#pragma mark - button默认样式

- (void)buttonDefaultStyle:(UIButton *)button{
    
    //设置选中button的字体颜色
    
    [button setTitleColor:self.normalItemColor forState:UIControlStateNormal];
    
    [self buttonZoomWithButton:button zoomScale:1];
}

#pragma mark - button点击样式

- (void)buttonClickStyle:(UIButton *)button{
    
    //设置选中button的字体颜色
    
    [button setTitleColor:self.selectItemColor forState:UIControlStateNormal];
    
    //判断标签导航栏样式
    
    switch (self.style) {
            
        case HSSlideStyleZoom:
            
            //设置button字体缩放
            
            [self buttonZoomWithButton:button zoomScale:1.2];
            
            break;
            
        case HSSlideStyleLine:
            
            break;
            
        case HSSlideStyleLineAdaptText:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - button缩放

- (void)buttonZoomWithButton:(UIButton*)button zoomScale:(CGFloat)scale {
    
    [UIView animateWithDuration:0.4f animations:^{
        
        button.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

@end

#pragma mark - ====================HSTabContainView===========================

@implementation HSTabContainView

@end




#pragma mark - ====================HSTabSlideView===========================

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
        
        self.backgroundColor = kBackgroundColor;
        
        //循环
        self.isCycle = YES;
        
        //设置标签导航栏样式
        self.style = slideStyle;
        
        //设置当前的index
        self.currenIndex = 0;
        
    }
    return self;
}

- (void)setDelegate:(id<HSTabSlideViewDelegate>)delegate {
    
    _delegate = delegate;
    
    [self configTabItemViewTitle];
}

-(void)reloadData {
    
    [self configTabItemViewTitle];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.tabItemView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kHeightOfTabItem);
    
    self.scrollView.frame = CGRectMake(0, kHeightOfTabItem, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - kHeightOfTabItem);
    
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
    
    [self.tabItemView configSelectIndex:_currenIndex];
}

/** 设置当前的index的布局 */
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
    
    if (self.numOfItem <= 1) {
        
        //只有一个item的时候
        if (index == 0){
            
            [self addViewOfContainView:self.preContainView index:index];
        }
        
    } else {
        
        if (index == 0 && self.isCycle == NO){
            
            //不循环且是第一个item时候
            [self addViewOfContainView:self.preContainView index:index];
            
            [self addViewOfContainView:self.currentContainView index:nextIndex];
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if (index == self.numOfItem - 1 && self.isCycle == NO){
            
            //不循环且是最后一个item的时候
            [self addViewOfContainView:self.currentContainView index:preIndex];
            
            [self addViewOfContainView:self.nextContainView index:index];
            
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0);
        }
        else {
            
            //循环和中间的item的时候
            [self addViewOfContainView:self.preContainView index:preIndex];
            
            [self addViewOfContainView:self.nextContainView index:nextIndex];
            
            [self addViewOfContainView:self.currentContainView index:index];
            
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        }
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
        
        if (self.isCycle){ //循环
            
            return self.numOfItem - 1;
        }
        else { //不循环
            
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

-(NSInteger)getNextIndex:(NSInteger)index
{
    if (index == self.numOfItem - 1){
        
        if (self.isCycle){ //循环
            
            return 0;
        }
        else { //不循环
            
            return self.numOfItem - 1;
        }
    }
    
    return index + 1;
}

- (void)playNextContainView
{
    self.currenIndex = [self getNextIndex:self.currenIndex];
}

#pragma mark - 设置

- (void)setInsets:(UIEdgeInsets)insets {
    
    _insets = insets;
    
    self.tabItemView.insets = insets;
}

- (void)setMargin:(CGFloat)margin {

    _margin = margin;
    
    self.tabItemView.margin = margin;
}

- (void)setMaxCount:(NSInteger)maxCount {

    _maxCount = maxCount;
    
    self.tabItemView.maxCount = maxCount;
}

#pragma mark - 滑动视图滑动结束处理

- (void)scrollViewDidEndScrollingHandle{
    
    NSInteger page = self.scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    
    //判断左滑动还是右滑动
    
    switch (page) {
            
        case 0: { //上一张
            
            [self playLastContainView];
        }
            break;
            
        case 1: {
            
            //当不循环的时候，且是第一个item的时候，播放下一个item
            if (self.currenIndex == 0 && self.isCycle == NO){
                
                [self playNextContainView];
                
            } else if (self.currenIndex == self.numOfItem - 1 && self.isCycle == NO){
                
                [self playLastContainView];
            }
        }
            break;
            
        case 2: { //下一张
            
            [self playNextContainView];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scale = 0.0f;
    
    if (self.isCycle == NO){ //不循环
        
        CGFloat offset = (scrollView.contentOffset.x / scrollView.frame.size.width);
        
        if (self.currenIndex == 0){
            
            scale = offset + _currenIndex;
            
            if (offset >= 1){
                //在第一张图片时，超过第一屏幕，播放下一张图片
                [self playNextContainView];
            }
            
        } else if (self.currenIndex == self.numOfItem - 1){
            
            scale = offset - 1 + _currenIndex - 1;
            
            if (offset <= 1){
                //在最后一张图片时，超过第一屏幕，播放上一张图片
                [self playLastContainView];
            }
            
        } else {
            
            scale = offset + _currenIndex - 1;
            
            //滑动到scrollView的最左边和最右边
            if (offset >= 2){
                
                [self playNextContainView];
                
                scale = self.currenIndex;
                
            } else if (offset <= 0){
                
                [self playLastContainView];
                
                scale = self.currenIndex;
            }
        }
        
        //处理当快速滑动滑过了最大值和最小值的时候处理
        if (scale >= self.numOfItem - 1){
            
            scale = self.numOfItem - 1;
            
            self.currenIndex = self.numOfItem - 1;
            
        } else if (scale <= 0){
            
            scale = 0;
            
            self.currenIndex = 0;
        }
        
    } else { //循环
        
        CGFloat offset = (scrollView.contentOffset.x / scrollView.frame.size.width);
        
        scale = offset + _currenIndex - 1;
        
        if (offset >= 1){
            
            [self addViewOfContainView:self.nextContainView index:[self getNextIndex:_currenIndex]];
            
        } else {
            
            [self addViewOfContainView:self.preContainView index:[self getPreIndex:_currenIndex]];
        }
        
        //滑动到scrollView的最左边和最右边
        if (offset >= 2){
            
            [self playNextContainView];
            
            scale = self.currenIndex;
            
        } else if (offset <= 0){
            
            [self playLastContainView];
            
            scale = self.currenIndex;
        }
    }
    
    [self.tabItemView configMoveLineViewWithScale:scale];
}

//视图将要滑动

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    
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

- (NSInteger)getCurrentIndex {
    
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

/** 配置标题 */
- (void)configTabItemViewTitle {
    
    if (self.titleArray) {
        
        [self.titleArray removeAllObjects];
    } else {
        
        self.titleArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (self.viewsArray) {
        
        [self.viewsArray removeAllObjects];
    } else {
        
        self.viewsArray = [NSMutableArray arrayWithCapacity:0];
    }
    
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
    
    self.tabItemView.dataArray = self.titleArray;
    
    if (self.numOfItem >= 2){
        
        //>2的个数可以循环
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
    } else {
        
        //<1 或者 =1
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }
    
    
    
    self.currenIndex = 0;
}


#pragma mark - Lazy Loading

-(UIScrollView *)scrollView
{
    if (_scrollView == nil){
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeightOfTabItem, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - kHeightOfTabItem)];
        
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

-(HSTabItemView *)tabItemView {
    
    if (_tabItemView == nil){
        
        _tabItemView = [[HSTabItemView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), kHeightOfTabItem) slideStyle:self.style];
        
        [self addSubview:_tabItemView];
        
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

- (BOOL)isCycle {
    
    if (self.numOfItem <= 1){
        //如果个数只有一个，不做循环
        return NO;
        
    } else {
        
        return _isCycle;
    }
}

@end
