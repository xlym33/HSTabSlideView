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
    
    
    self.titleArray = @[@"图集", @"哈哈", @"啦啦", @"嘻嘻"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self demo10];
    
    [self.slideView reloadData];
    
    
}


-(void)demo10
{
    
    self.navigationController.navigationBarHidden = YES;
    
    self.slideView = [[HSTabSlideView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) slideStyle:HSSlideStyleLine];
    
    self.slideView.isCycle = NO;
    
    [self.view addSubview:self.slideView];
    
    self.slideView.delegate = self;
    
    [self.slideView reloadData];
    
}

-(UIView *)tabSlideView:(HSTabSlideView *)slideView viewForItemAtIndex:(NSInteger)index
{
    CustomCell *cell = [[CustomCell alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    cell.backgroundColor = [UIColor blueColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    
    view.backgroundColor = [UIColor colorWithRed:rand() % 256 / 255.0 green:rand() % 256 / 255.0 blue:rand() % 256 / 255.0 alpha:1.0f];

    if (index == 0){
    
        view.backgroundColor = [UIColor redColor];

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
    return 4;
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



-(void)demo9
{
    /*
     NavigationItem  是对每个viewController上面的导航按钮的说明，我们已知bar是公用的，但是bar在每个viewController上左右按钮要显示不同，所以就有NavigationItem对每一个viewController的说明
     那么item有什么控件
     1、左按钮  2、右按钮   3、中间文字  4、中间的View
     */
    
    self.navigationItem.title=@"导航文字";
    //以上这个方法等同于self.title
    
    
    //在这里设置他的x和y都没有任何用 但他的width 和 height 是有用的
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor=[UIColor redColor];
    self.navigationItem.titleView=view;
    
    //超出部分使用View的属性进行裁剪 如果不设置裁剪 会出现下面的图像
    self.navigationController.navigationBar.clipsToBounds=YES;
    view.superview.clipsToBounds=YES;
    
    
    
    //针对导航上的文字进行修改，修改字体大小，字体颜色等
    //iOS7以前的方法
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:10],UITextAttributeTextColor:[UIColor redColor]}];
    
    //iOS7之后的方法
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
    
    
    UIImage*image=[UIImage imageNamed:@"main_left_nav.png"];
    
    //处理image为使用原来的数据
    //如果不处理图像，则会显示为一片蓝色或者为一个蓝色的阴影
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
}

-(void)demo8
{
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    //
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)demo7
{
    
    //设置状态条为高亮状态
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //以上是iOS6的方法，在iOS7的时候需要修改info.plist文件，让viewController修改权限低于Application 在plist文件里加上View controller-based status bar appearance 这一项 然后设置为NO
}

#pragma mark - 演示工具条的使用

-(void)demo6
{
    //演示工具条的使用
    //<1>显示工具条
    //细节: 导航控制器自带导航条和工具条
    //工具条默认情况下不会显示
    [self.navigationController setToolbarHidden:NO];
    
    //[self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
    //[self.navigationController.toolbar setTranslucent:YES];
    
    
    //<2>添加按钮
    //NSArray *toolbarItems
    //其中的对象应该是 UIBarButtonItem
    //细节: 显示的从左边,按钮中没有间隔
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(buttonClick:)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(buttonClick:)];
    UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(buttonClick:)];
    
    //间隔也是UIBarButtonItem 系统Item为UIBarButtonSystemItemFixedSpace
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 60;
    
    self.toolbarItems = [NSArray arrayWithObjects:one,space,two,space,three,nil];
    
    
}

#pragma mark - 导航条的颜色和背景的设置

-(void)demo5
{
    //导航条的颜色和背景的设置
    
    //<1>导航条的设置
    //1.设置风格(默认和黑色)
    //2.不同的版本上会有不同: 两个枚举值放弃使用了
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    //设置原点的位置，即半透明
    //设为NO后位置，即不透明了，y的0点在下移了64后开始
    //设为YES后，即透明了，y的0点在原来的位置
    [self.navigationController.navigationBar setTranslucent:NO];
    
    //验证上面的半透明
    UIView *yeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    yeView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yeView];
    
    
    //<2>导航条颜色的设置
    //颜色???
    //细节1:混合色
    //细节2:只有设置为透明后才会出现
    //如果设置的Translucent为NO，则不会出现这里设置的颜色
    //而是出现导航条风格的颜色，即UIBarStyleDefault半透明和UIBarStyleBlack全黑
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    
    //设置navigationBar 的左右两边BarButtonItem和BackButton文字的颜色，title的颜色不会变
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    self.title = @"哈哈哈哈";
    
    //<3>导航条背景图片的设置
    //UIBarMetricsDefault表示横屏
    //UIBarMetricsLandscapePhone竖屏
    //细节: 图片格式适宜为 320X44
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"22.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

#pragma mark - 返回按钮

-(void)demo4
{
    
    //设置下个界面的返回按钮
    //写在mainViewController
    //细节1: 显示在下个界面上
    //细节2: 忽略自定义ButtonItem的事件响应方法
    //细节3: 如果使用的是系统样式的BarButtonItem是没有效果的，只能是添加title和image
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回主界面" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    
    //backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"22"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick:)];
    
    //没有效果
    //backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = backItem;
    
}

#pragma mark - 左右侧按钮

-(void)demo3
{
    //设置左右侧按钮
    
    //添加导航条左侧的按钮
    //<1>创建文本按钮
    //UIBarButtonItem
    //UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStyleDone target:self action:@selector(navButtonClick:)];
    
    
    //<2>创建系统样式的按钮
    //UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navButtonClick:)];
    
    //<3>自定的按钮
    //细节: 图片没有显示的问题,没有设置大小
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 33, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"22.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //这个设置的方法没有用
    //self.navigationController.navigationItem.leftBarButtonItem = leftItem;
    
    //设置左侧按钮的数组
    self.navigationItem.leftBarButtonItems = @[leftItem, leftItem];
    
    //<4>设置竖屏和横屏的显示的图片  竖屏显示22图片 横屏223图片
    //[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"22"] landscapeImagePhone:[UIImage imageNamed:@"223"] style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
}

#pragma mark - title和titleView设置

-(void)demo2
{
    //设置标题
    //实例: 导航栏显示 主界面 文本
    
    self.title = @"主界面";
    //导航控制器的控件集合
    
    self.navigationItem.title = @"main";
    //细节1: 修改的都是标题,最后一个是有效的
    
    
    //标题位置显示logo图片
    //细节1: titleView优先级高,覆盖文本标题
    //细节2: titleView是UIView,意味设置任意控件
    //细节3: x和y忽略
    //细节4: 图片显示不出来(1)名字 (2)必须设置大小
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.frame = CGRectMake(0, 0, 30, 35);
    logoView.image = [UIImage imageNamed:@"22.png"];
    self.navigationItem.titleView = logoView;
    
}

#pragma mark - 动画设置

-(void)demo1
{
    
    //加上切换效果，扩展内容
    
    //每个界面的出现的效果，push出来的界面也有此效果
    
    //QuartzCore 实现动画
    //1.包含头文件  #import <QuartzCore/QuartzCore.h>
    //2.导入库二进制文件Library
    
    //<1>创建对象
    CATransition *animation = [CATransition animation];
    
    
    //设置动画类型
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    animation.type = @"moveIn";
    
    //设置动画的方向
    animation.subtype = kCATransitionFromTop;
    
    //设置动画时间 0.5秒
    animation.duration = 5;
    
    //设置动画的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //animation加入到导航控制器中，以后push的界面都有此效果，如果只是加到self.view.layer上，效果会不一样，自行验证
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    
}

- (IBAction)buttonClick:(id)sender {
    
    //页面的切换效果和上面设置的效果一样
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
