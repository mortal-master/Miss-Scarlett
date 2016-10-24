//
//  BWEssenceVC.m
//  Miss-Scarlett
//
//  Created by mortal on 16/10/15.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "BWEssenceVC.h"

#import "BWAllViewController.h"
#import "BWVideoViewController.h"
#import "BWVoiceViewController.h"
#import "BWPictureViewController.h"
#import "BWTextViewController.h"

static NSString *const ID = @"collectionCell";

@interface BWEssenceVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UIScrollView *topScrollView;
@property (nonatomic, weak) UICollectionView *bottomCollectionView;
@property (nonatomic, weak) UIButton *selectedBtn;
/** 保存按钮的数组 */
@property (strong, nonatomic) NSMutableArray *btnArray;
/** 下划线 */
@property (nonatomic, weak) UIView *underLine;
@end

@implementation BWEssenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航控制器的内容
    [self setNavBar];
    //设置底部内容
    [self setUpBottom];
    //设置顶部标题
    [self setUpTopTitle];
    //添加所有子控制器
    [self addAllChildVC];
    //添加所有标题按钮
    [self setUpAllTitleBtn];
    
    //取消额外的滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//设置导航控制器的内容
- (void)setNavBar {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //左边视图
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:nil action:nil];
    //右边视图
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
}

//设置顶部标题
- (void)setUpTopTitle {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenW, 30)];
    scrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    [self.view addSubview:scrollView];
    self.topScrollView = scrollView;
}

//设置底部内容
- (void)setUpBottom {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    //指定水平滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    //创建 collectionView，指定流水布局
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册 cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:collectionView];
    self.bottomCollectionView = collectionView;
    
    //设置 collectionView
    collectionView.pagingEnabled = YES;//分页滑动
    collectionView.bounces = NO;//取消弹簧效果
    collectionView.showsVerticalScrollIndicator = NO;//取消垂直滑动条
    collectionView.showsHorizontalScrollIndicator = NO;//取消水平滑动条
}

//添加所有子控制器
- (void)addAllChildVC {
    //全部
    BWAllViewController *allVC = [[BWAllViewController alloc] init];
    allVC.title = @"全部";
    [self addChildViewController:allVC];
    
    //视频
    BWVideoViewController *videoVC = [[BWVideoViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    //声音
    BWVoiceViewController *voiceVC = [[BWVoiceViewController alloc] init];
    voiceVC.title = @"声音";
    [self addChildViewController:voiceVC];
    
    //图片
    BWPictureViewController *pictureVC = [[BWPictureViewController alloc] init];
    pictureVC.title = @"图片";
    [self addChildViewController:pictureVC];
    
    //段子
    BWTextViewController *textVC = [[BWTextViewController alloc] init];
    textVC.title = @"段子";
    [self addChildViewController:textVC];
}

//添加所有标题按钮
- (void)setUpAllTitleBtn {
    NSInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = i;
        
        CGFloat width = screenW / count;
        btn.frame = CGRectMake(i * width, 0, width, self.topScrollView.bw_height);
        [self.topScrollView addSubview:btn];
        
        //将按钮添加到数组中
        [self.btnArray addObject:btn];
        
        //默认选中第 0 个按钮
        if (i == 0) {
            [self btnClick:btn];
            
            //给按钮添加下划线
            UIView *underLine = [[UIView alloc] init];
            underLine.backgroundColor = [UIColor redColor];
            
            [btn.titleLabel sizeToFit];
            
            underLine.bw_width = btn.titleLabel.bw_width;
            underLine.bw_height = 2;
            underLine.bw_centerX = btn.bw_centerX;
            underLine.bw_y = btn.bw_height - underLine.bw_height;
            
            self.underLine = underLine;
            [self.topScrollView addSubview:underLine];
        }
    }
}

- (void)btnClick:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    //移动要显示的 view
    NSInteger i = btn.tag;
    self.bottomCollectionView.contentOffset = CGPointMake(i * screenW, 0);
    
    //移动下划线的位置
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underLine.bw_centerX = btn.bw_centerX;
    }];
}

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //移除之前控制器的 view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //切换子控制器的 view
    UITableViewController *tabVC = self.childViewControllers[indexPath.row];
    tabVC.view.frame = [UIScreen mainScreen].bounds;
    tabVC.tableView.contentInset = UIEdgeInsetsMake(64 + self.topScrollView.bw_height, 0, 49, 0);
    [cell.contentView addSubview:tabVC.view];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //计算当前页码
    NSInteger pageNum = scrollView.contentOffset.x / screenW;
    UIButton *btn = self.btnArray[pageNum];
    //将按钮设为选中状态
    [self btnClick:btn];
}
@end
