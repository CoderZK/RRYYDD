//
//  kkkkNewsVC.m
//  Jinrirong
//
//  Created by zk on 2019/5/8.
//  Copyright © 2019 ahxb. All rights reserved.
//

#import "kkkkNewsVC.h"
#import "XBJinRRLoginViewController.h"
#import "XBJinRRBaseNavigationViewController.h"
#import "kkkkTwoCell.h"
@interface kkkkNewsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation kkkkNewsVC
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *token = [UDefault getObject:TOKEN];
    if (token == nil || [token isEqualToString:@""]) {
        XBJinRRLoginViewController *vc = [[XBJinRRLoginViewController alloc] init];
        XBJinRRBaseNavigationViewController *nav = [[XBJinRRBaseNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerNib:[UINib nibWithNibName:@"kkkkTwoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getData];
    
}

- (void)getData {
    
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    BOOL isOpen = [db open];
    
    NSString * sql = [NSString stringWithFormat:@"select *from kkkk_news where userId='%@'",[UDefault getObject:@"phone"]];
    if (isOpen) {
        
        FMResultSet * result = [db executeQuery:sql];
        [self.dataArray removeAllObjects];
        while ([result next]) {
            
            kkkkModel * model = [[kkkkModel alloc] init];
            model.ID = [result stringForColumn:@"ID"];
            model.userId = [result stringForColumn:@"userId"];
            model.title = [result stringForColumn:@"title"];
            model.content = [result stringForColumn:@"content"];
            model.names = [result stringForColumn:@"names"];
            model.status = [result intForColumn:@"status"];
            
            [self.dataArray insertObject:model atIndex:0];
            
        }
        
        [self.tableView reloadData];
    }
    
    [db close];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    kkkkTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    kkkkModel * model = self.dataArray[indexPath.row];
    cell.titleLB.text = [NSString stringWithFormat:@"消息题目: %@",model.title];
    cell.contentLB.text = [NSString stringWithFormat:@"消息内容: %@",model.content];
    return cell;
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
