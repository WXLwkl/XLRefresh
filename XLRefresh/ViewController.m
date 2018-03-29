//
//  ViewController.m
//  XLRefresh
//
//  Created by xingl on 2018/3/29.
//  Copyright © 2018年 xingl. All rights reserved.
//

#define RandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

#import "ViewController.h"

#import "XLTestHeader.h"
#import "XLTestFooter.h"

#import "CollectionViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ViewController

- (NSMutableArray *)data {
    if (!_data) {
        self.data = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            [self.data addObject:RandomData];
        }
    }
    return _data;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        if (@available(iOS 11.0, *)) {
//            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
//        _tableView.xl_header = [XLRefreshHeader headerWithRefreshingBlock:^{
//            [self loadNewData];
//        }];
        
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"tableView刷新";
    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
//    self.navigationItem.searchController =
    
    
//    self.tableView.xl_header = [MJDIYHeader headerWithRefreshingBlock:^{
//        [self loadNewData];
//    }];
    [self.view addSubview:self.tableView];
    self.tableView.xl_header = [XLTestHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.xl_footer = [XLTestFooter footerWithRefreshingBlock:^{
//        [self loadMoreData];
//    }];
    self.tableView.xl_footer = [XLTestFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadLastData)];
    
    [self.tableView.xl_header beginRefreshing];
    
}

- (void)loadNewData {
    
    NSLog(@"--- [刷新中...] ---");
    
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data insertObject:RandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.xl_header endRefreshing];
    });
}

- (void)loadMoreData {
    NSLog(@"--- [加载更多...] ---");
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data addObject:RandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.xl_footer endRefreshing];
        
    });
}

#pragma mark 只加载一次数据
- (void)loadOnceData {
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data addObject:RandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.xl_footer endRefreshing];
        // 隐藏当前的上拉刷新控件
        tableView.xl_footer.hidden = YES;
    });
}

#pragma mark 加载最后一份数据
- (void)loadLastData {
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data addObject:RandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [tableView.xl_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //code...
    
    CollectionViewController *viewCon = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:viewCon animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
