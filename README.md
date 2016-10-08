# HSTabSlideView

HSTabSlideView是滑动轮播视图

使用教程：

```

-(void)demo10
{
    
    self.navigationController.navigationBarHidden = YES;
    
    self.slideView = [[HSTabSlideView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) slideStyle:HSSlideStyleLine];
    
    //设置是否可以循环
    self.slideView.isCycle = NO;
    
    [self.view addSubview:self.slideView];
    
    //设置代理
    self.slideView.delegate = self;
    
    //设置重新加载数据
    [self.slideView reloadData];
    
}

#pragma mark - slideView的代理方法

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

```
