//
//  XBJinRRIncomeFromRecommendCell.m
//  Jinrirong
//
//  Created by 刘飞 on 2018/6/5.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "XBJinRRIncomeFromRecommendCell.h"

@implementation XBJinRRIncomeFromRecommendCell

//131高度

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderNumLabel.font = FONT(15);
    self.orderNumLabel.textColor = RGB(120, 120, 120);
    self.dateLabel.font = FONT(15);
    self.dateLabel.textColor = MainColor;
    
//    self.iconImageView
    self.phoneNumLabel.font = FONT(12);
    self.phoneNumLabel.textColor = BlackColor;
    self.bonusLabel.font = FONT(12);
    self.bonusLabel.textColor = WhiteColor;
//    self.bonusLabel.backgroundColor = MainColor;
    self.bonusLabel.layer.masksToBounds = YES;
    self.bonusLabel.layer.cornerRadius = 12.5;
    
    
    self.submitTimeLabel.font = FONT(12);
    self.submitTimeLabel.textColor = RGB(166, 166, 166);
}


- (void)setTModel:(XBJinRRPromotdataModel *)tModel{
    _tModel = tModel;
    
    if ([_tModel.Status isEqualToString:@"1"]) {
        //已达标
        self.bonusLabel.textColor = MainColor;

    }else{
        //为达标
        self.bonusLabel.textColor = RGB(176, 176, 176);
    }
    
    if ([tModel.Itype isEqualToString:@"0"]) {
        //贷款
            if ( [tModel.Status isEqualToString:@"0"] ){
                //未达标
                
                NSString * str = [UDefault getObject:TICKSID];
                NSString * str2 = [NSString stringWithFormat:@"%@",[UDefault getObject:TICKSID]];
                
                if ([tModel.erUserID isEqualToString: [NSString stringWithFormat:@"%@",[UDefault getObject:@"kk_userId"]]]) {
                    //二级代理
                    if ([tModel.Yjtype isEqualToString:@"1"]) {
                        //按比例
                        
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%@%%元",tModel.two_bonusRate];
                        
                    }else {
                        //按金额
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%@元",tModel.two_ymoney];
                        
                    }
                    
                }else {
                    //一级代理
                    
                    if ([tModel.Yjtype isEqualToString:@"1"]) {
                        //按比例
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款金额的%@%%元",tModel.BonusRate];
                        
                    }else {
                        //按金额
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%@元",tModel.two_ymoney];
                        
                    }
                }
                
                
            }else {
                //已达标
                if ([tModel.erUserID isEqualToString: [NSString stringWithFormat:@"%@",[UDefault getObject:@"kk_userId"]]]) {
                    //二级代理
                    if ([tModel.Yjtype isEqualToString:@"1"]) {
                        //按比例
                        CGFloat two_money = [tModel.two_bonusRate floatValue]*[tModel.money floatValue]/100;
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%.02f元",two_money];
                        
                    }else {
                        //按金额
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%@元",tModel.two_ymoney];
                        
                    }
                    
                }else {
                    //一级代理
                    
                    if ([tModel.Yjtype isEqualToString:@"1"]) {
                        //按比例
                        CGFloat one_money = [tModel.BonusRate floatValue]*[tModel.money floatValue]/100;
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%.02f元",one_money];
                        
                    }else {
                        //按金额
                        self.bonusLabel.text = [NSString stringWithFormat:@"放款奖金: 放款%@元",tModel.two_ymoney];
                        
                    }
                }

            }

    }else {
        //信用卡
        if (  [[NSString stringWithFormat:@"%@",tModel.money] isEqualToString:@"(null)"]) {
            tModel.money = @"0";
        }
        self.bonusLabel.text = [NSString stringWithFormat:@"下卡奖励: 下卡%@元",tModel.Ymoney];
        
    }
    
    
    
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",_tModel.OrderSn];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",_tModel.Settletime];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_tModel.Logurl]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",_tModel.goodname];
    self.phoneNumLabel.text = [NSString stringWithFormat:@"手机号码：%@",_tModel.Mobile];
    if (_tModel.applyBonus) {
        if(self.bonusLabel.frame.size.width!=110){
            self.widthcn.constant += 30;
            self.leftCn.constant -= 30;
        }
    }
    
//    if ([_tModel.Status isEqualToString:@"0"]) {
//        if(_tModel.applyBonus){
//            self.bonusLabel.text = [NSString stringWithFormat:@"申请%@元+放款%@%@",_tModel.applyBonus,[_tModel.Yjtype isEqualToString:@"1"]?_tModel.BonusRate:_tModel.Ymoney,[_tModel.Yjtype isEqualToString:@"1"]?@"%":@"元"];
//        }
//        else{
//            self.bonusLabel.text = [NSString stringWithFormat:@"放款%@%@",[_tModel.Yjtype isEqualToString:@"1"]?_tModel.BonusRate:_tModel.Ymoney,[_tModel.Yjtype isEqualToString:@"1"]?@"%":@"元"];
//        }
//    }else{
//        if(_tModel.applyBonus){
//            self.bonusLabel.text = [NSString stringWithFormat:@"申请%@元+放款%@%@",_tModel.applyBonus,_tModel.Bonus,@"元"];
//        }else{
//            self.bonusLabel.text = [NSString stringWithFormat:@"放款%@%@",_tModel.Bonus,@"元"];
//        }
//    }
    
    self.submitTimeLabel.text = [NSString stringWithFormat:@"提交时间：%@",_tModel.Addtime];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
