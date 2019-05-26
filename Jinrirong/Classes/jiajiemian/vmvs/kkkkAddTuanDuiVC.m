//
//  kkkkAddTuanDuiVC.m
//  Jinrirong
//
//  Created by zk on 2019/5/22.
//  Copyright © 2019 ahxb. All rights reserved.
//

#import "kkkkAddTuanDuiVC.h"

@interface kkkkAddTuanDuiVC ()
@property (weak, nonatomic) IBOutlet UITextField *TF;
@property (weak, nonatomic) IBOutlet UITextView *TV;
@property (weak, nonatomic) IBOutlet UITextView *namesTV;
@end

@implementation kkkkAddTuanDuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TV.layer.borderColor = RGB(200, 200, 200).CGColor;
    self.TV.layer.borderWidth = 1;
    self.namesTV.layer.borderColor = RGB(200, 200, 200).CGColor;
    self.namesTV.layer.borderWidth = 1;
    self.navigationItem.title = @"添加项目";
}
- (IBAction)add:(id)sender {
    if (self.TF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (self.TV.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    
    if (self.namesTV.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入参与人员"];
        return;
    }
    
    
    
    FMDatabase * db = [FMDBSingle shareFMDB].fd;
    BOOL isOpen = [db open];
    //    NSString * sql = [[NSString stringWithFormat:@"insert into kkkk_mineDongTai (title,content,scan,like,userId) values ('%@','%@','%d','%d','%@')",self.TF.text,self.TV.text,0,0,@"1111"]];
    
    NSString * sql = [NSString stringWithFormat:@"insert into kkkk_tuanDui (title,content,status,userId,names) values ('%@','%@','%d','%@','%@')",self.TF.text,self.TV.text,0,[UDefault getObject:@"phone"],self.namesTV.text];
    
    if (isOpen) {
        BOOL insert = [db executeUpdate:sql];
        if (insert) {
            [SVProgressHUD showSuccessWithStatus:@"添加项目成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        [db close];
    }
}


@end
