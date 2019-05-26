//
//  kkkkHomeVC.m
//  Jinrirong
//
//  Created by zk on 2019/5/8.
//  Copyright © 2019 ahxb. All rights reserved.
//

#import "kkkkHomeVC.h"
#import "kkkkHomeOneCell.h"
#import "kkkkHomeTwoCell.h"
#import "kkkkCell.h"
#import "kkkkDongTaiVC.h"
#import "kkkkDaKaVCViewController.h"
#import "kkkkGongZuoJiHuaListVC.h"
#import "kkkkRenWuVC.h"
#import "kkkkXiangMuListVC.h"
#import "kkkkRiBaoListVC.h"
#import "kkkkHuiYiListVC.h"
#import "kkkkTuanDuiListVC.h"
#import "kkkkHomeThreeCell.h"
#import "XBJinRRLoginViewController.h"
#import "XBJinRRBaseNavigationViewController.h"
@interface kkkkHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation kkkkHomeVC
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
    
     [self getData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.navigationItem.title = @"首页";
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"kkkkHomeOneCell" bundle:nil] forCellReuseIdentifier:@"cellone"];
    [self.tableView registerClass:[kkkkHomeTwoCell class] forCellReuseIdentifier:@"twoCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"kkkkHomeThreeCell" bundle:nil] forCellReuseIdentifier:@"cellThree"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
    
    
    
}

- (void)getData {
    NSArray * arr  = @[@"kkkk_mineDongTai",@"kkkk_gongZuoJiHua",@"kkkk_renWu",@"kkkk_tuanDui"];
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    [self.dataArray removeAllObjects];
    BOOL isOpen = [db open];
    for (int i = 0 ; i<arr.count; i++) {
        NSString * sql = [NSString stringWithFormat:@"select *from %@ where userId='%@'",arr[i],[UDefault getObject:@"phone"]];
        if (isOpen) {
            
            FMResultSet * result = [db executeQuery:sql];
           
            if ([result next]) {
                
                kkkkModel * model = [[kkkkModel alloc] init];
                model.ID = [result stringForColumn:@"ID"];
                model.userId = [result stringForColumn:@"userId"];
                model.title = [result stringForColumn:@"title"];
                model.content = [result stringForColumn:@"content"];
                [self.dataArray insertObject:model atIndex:0];
                
            }
            [self.tableView reloadData];
        }
    }
    [self.tableView reloadData];
    [db close];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 2){
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1) {
        return 185;
    }else if (indexPath.section == 2) {
        return 113;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        kkkkHomeOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellone" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        kkkkHomeTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"twoCell" forIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        
//        __weak kkkkHomeVC * weakSelf = self;
        
        
        cell.didIndexBlock = ^(NSInteger index) {
          
            if (index == 0) {
                kkkkDongTaiVC * vc =[[kkkkDongTaiVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 1) {
                
                kkkkDaKaVCViewController * vc =[[kkkkDaKaVCViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 2) {
                kkkkGongZuoJiHuaListVC * vc =[[kkkkGongZuoJiHuaListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 3) {
                kkkkRenWuVC * vc =[[kkkkRenWuVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 4) {
                kkkkXiangMuListVC * vc =[[kkkkXiangMuListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 5) {
                kkkkRiBaoListVC * vc =[[kkkkRiBaoListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 6) {
                kkkkHuiYiListVC * vc =[[kkkkHuiYiListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index == 7) {
                kkkkTuanDuiListVC * vc =[[kkkkTuanDuiListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }

            
        };
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        
        kkkkHomeThreeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cellThree" forIndexPath:indexPath];
        NSArray * arr = @[@"动态",@"工作计划",@"任务",@"团队"];
        cell.typeLB.text =  [NSString stringWithFormat:@"类型: %@",arr[indexPath.row]];;
        kkkkModel * model = self.dataArray[indexPath.row];
        cell.titleLB.text =  [NSString stringWithFormat:@"%@标题: %@",arr[indexPath.row],model.title];;
        cell.contentLB.text =  [NSString stringWithFormat:@"详细信息: %@",model.content];
        return cell;
        
    }
    kkkkHomeOneCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            kkkkDongTaiVC * vc =[[kkkkDongTaiVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            kkkkGongZuoJiHuaListVC * vc =[[kkkkGongZuoJiHuaListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {
            kkkkRenWuVC * vc =[[kkkkRenWuVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3) {
            kkkkTuanDuiListVC * vc =[[kkkkTuanDuiListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}


@end
