//
//  kkkkXiangMuListVC.m
//  Jinrirong
//
//  Created by zk on 2019/5/17.
//  Copyright © 2019 ahxb. All rights reserved.
//

#import "kkkkXiangMuListVC.h"
#import "kkkkGongZuoJiHuaListCell.h"
#import "kkkkAddXiangMuVC.h"
@interface kkkkXiangMuListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation kkkkXiangMuListVC

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"项目列表列表";
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 40;
    [self.tableView registerNib:[UINib nibWithNibName:@"kkkkGongZuoJiHuaListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    
    [button setTitle:@"添加项目" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    button.layer.cornerRadius = 0;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}


- (void)add {
    kkkkAddXiangMuVC * vc =[[kkkkAddXiangMuVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)getData {
    
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    BOOL isOpen = [db open];
    
    NSString * sql = [NSString stringWithFormat:@"select *from kkkk_mineProject where userId='%@'",[UDefault getObject:@"phone"]];
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
    
    kkkkGongZuoJiHuaListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    kkkkModel * model = self.dataArray[indexPath.row];
    cell.titleLB.text = [NSString stringWithFormat:@"项目题目: %@",model.title];
    cell.contentLB.text = [NSString stringWithFormat:@"项目内容: %@\n%@",model.content,model.names];
    [cell.statusBT addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    cell.statusBT.tag = indexPath.row;
    if (model.status == 0) {
        [cell.statusBT setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cell.statusBT.userInteractionEnabled = YES;
        [cell.statusBT setTitle:@"未完成" forState:UIControlStateNormal];
        
    }else {
        [cell.statusBT setTitleColor:RGB(150, 150, 150) forState:UIControlStateNormal];
        cell.statusBT.userInteractionEnabled = NO;
        [cell.statusBT setTitle:@"已完成" forState:UIControlStateNormal];
        
    }
    
    return cell;
    
}

- (void)action:(UIButton *)button{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否要操作为完成" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        FMDatabase * db = [FMDBSingle shareFMDB].fd;
        BOOL isOpen = [db open];
        kkkkModel * model = self.dataArray[button.tag];
        NSString * sql = [NSString stringWithFormat:@"update  kkkk_xiangMu set status=1 where userId='%@'",model.ID];
        
        if (isOpen){
            BOOL isOk = [db executeUpdate:sql];
            if (isOk) {
                [SVProgressHUD showSuccessWithStatus:@"任务已完成"];
                model.status = 1;
                [self.tableView reloadData];
            }else {
                [SVProgressHUD showErrorWithStatus:@"完成任务失败"];
            }
        }
        
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
