//
//  ShowTrvalCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ShowTrvalCell.h"
#import "CustomImageScro.h"
@interface ShowTrvalCell()
{
    NSMutableArray * _arr_image;
}
@property (weak, nonatomic) IBOutlet UILabel *lab_FK;
@property (weak, nonatomic) IBOutlet UILabel *lab_dd;
@property (weak, nonatomic) IBOutlet UILabel *lab_yydd;
@property (weak, nonatomic) IBOutlet UILabel *lab_type;
@property (weak, nonatomic) IBOutlet UIView *view_line2;
@property (weak, nonatomic) IBOutlet UIView *view_line1;
@property (weak, nonatomic) IBOutlet UILabel *lab_typeProperty;
@property (weak, nonatomic) IBOutlet UILabel *lab_ddNum;
@property (weak, nonatomic) IBOutlet UILabel *lab_fkRS;
@end
@implementation ShowTrvalCell
-(void)awakeFromNib{
    [super awakeFromNib];
    if (!_arr_image) {
        _arr_image = [[NSMutableArray alloc] initWithObjects:self.image1,self.image2,self.image3,self.image4, nil];
        //把绘制好的虚线添加上来
        [self.view_line1.layer addSublayer:[self drawDottedLine]];
        [self.view_line2.layer addSublayer:[self drawDottedLine]];
    }
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath{
    NSString * identifiy = @"";
    NSInteger index;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            identifiy = @"ShowTrvalCell0";
            index = 0;
        } else if (indexPath.row==3){
            identifiy = @"ShowTrvalCell1";
            index = 1;
        }else if(indexPath.row==1){
            identifiy = @"ShowTrvalCell5";
            index = 5;
        }else{
            identifiy = @"ShowTrvalCell6";
            index = 6;
        }
    }else if (indexPath.section==3){
        identifiy = @"ShowTrvalCell2";
        index = 2;
    }else if (indexPath.section==4){
        identifiy = @"ShowTrvalCell3";
        index = 3;
    }else if (indexPath.section==1){
        identifiy = @"ShowTrvalCell8";
        index = 8;
    } else{
        identifiy = @"ShowTrvalCell7";
        index = 7;
    }
    ShowTrvalCell * cell = [tableView dequeueReusableCellWithIdentifier:identifiy];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShowTrvalCell" owner:nil options:nil][index];
    }
    
    return cell;
}
-(void)setTrval:(trvalMo *)trval{
    _trval = trval;
    if (trval!=nil) {
        self.lab_ServiceTitle.hidden=YES;
        self.lab_DW.hidden = YES;
        self.lab_PriceDY.hidden = YES;
        self.lab_price.hidden=YES;
        self.lab_Des.hidden = YES;
        self.view_JNB.hidden = YES;
        self.lab_JNB.hidden = YES;
//        self.lab_yydd.hidden = YES;
//        self.lab_dd.hidden = YES;
//        self.lab_ddNum.hidden = YES;
        self.lab_FK.hidden = YES;
//        self.lab_fkRS.hidden = YES;
        self.lab_Title.text = trval.user.nickName;
        self.lab_ddNum.text = [trval.orderCount description];
        if (trval.cityName.length!=0) {
            [self.btn_city setTitle:trval.cityName forState:UIControlStateNormal];
        }
        [self.btn_height setTitle:[NSString stringWithFormat:@"%@cm",trval.user.height?trval.user.height:@"-"] forState:UIControlStateNormal];
        [self.btn_coll setTitle:trval.user.educationName?trval.user.educationName:@"-" forState:UIControlStateNormal];
        [self.btn_wight setTitle:trval.user.marriageName?trval.user.marriageName:@"-" forState:UIControlStateNormal];
        self.lab_Age.text = trval.user.age?trval.user.age:@"-";
        [self.btn_weight setTitle:[NSString stringWithFormat:@"%@kg",trval.user.weight?trval.user.weight:@""] forState:UIControlStateNormal];
        self.lab_TrvalPrice.text = [NSString stringWithFormat:@"¥%@",trval.price];
        self.lab_DTNum.text = KString(@"%lu", (unsigned long)trval.serviceCircleList.count);
        self.lab_TrvalDY.text = trval.priceUnit;//单位暂无
        self.lab_TrvalDes.text = trval.introduce;
        self.lab_LLNum.text = [NSString stringWithFormat:@"浏览%@次",trval.browseTimes?trval.browseTimes:@"999+"];
        self.image_sex.image = [UIImage imageNamed:[KString(@"%@", trval.user.gender) isEqualToString:@"2"]?@"women":@"men"];
        for (NSDictionary * dic in trval.serviceCircleList) {
            if ([[dic[@"containsImage"] description] isEqualToString:@"1"] && ![YSTools dx_isNullOrNilWithObject:dic[@"images"]]) {
                NSArray * arr2 = [dic[@"images"] componentsSeparatedByString:@";"];
                for (int i=0; i<([arr2 count]>4?4:[arr2 count]); i++) {
                    if ([arr2[i] length]!=0) {
                        if (_arr_image.count!=0) {
                            UIImageView * image = _arr_image[i];
                            image.hidden = NO;
                            [image sd_setImageWithURL:[NSURL URLWithString:arr2[i]] placeholderImage:[UIImage imageNamed:@"logo2"]];
                        }
                    }
                }
                break;
            }
            
        }
        
    }
//  trval.comments 评论咱不知道怎么写
}
-(void)setJNIndexReceive:(NSInteger)JNIndexReceive{
    _JNIndexReceive = JNIndexReceive;
}
-(void)setList:(UserMo *)list{
    _list = list;
    if (list!=nil) {
        ServiceListMo * list1 = list.serviceList[self.JNIndexReceive];
        self.lab_TrvalDY.hidden = YES;
//        self.lab_TrvalDes.hidden = YES;
        self.lab_TrvalPrice.hidden = YES;
//        self.lab_trvalJNXQ.hidden = YES;
//        self.view_trval1.hidden = YES;
        self.lab_fkRS.hidden = NO;
        self.lab_DW.hidden = YES;
        self.layout_height.constant = 55;
        self.lab_fkRS.text = KString(@"%@人", [list1.browserCount description]);
        self.lab_Title.text = list.nickName?list.nickName:@"-";
        
        self.lab_ddNum.text = [list1.orderCount description];
        if (list.cityName.length!=0) {
            [self.btn_city setTitle:list.cityName forState:UIControlStateNormal];
        }
        [self.btn_height setTitle:KString(@"%@cm", list.height?list.height:@"-") forState:UIControlStateNormal];
        [self.btn_coll setTitle:list.educationName?list.educationName:@"-" forState:UIControlStateNormal];
        [self.btn_wight setTitle:list.marriageName?list.marriageName:@"-" forState:UIControlStateNormal];
        self.lab_Age.text = list.age?list.age:@"-";
        self.lab_price.text = [NSString stringWithFormat:@"¥%@",list1.price];
        self.lab_PriceDY.text = list1.typeName;
        self.image_sex.image = [UIImage imageNamed:[KString(@"%@", list.gender) isEqualToString:@"2"]?@"women":@"men"];
        [self.btn_weight setTitle:KString(@"%@kg", list.weight?list.weight:@"-") forState:UIControlStateNormal];
        self.lab_ServiceTitle.text = list1.title?list1.title:@"";
        self.lab_TrvalDes.text = list1.introduce?list1.introduce:@"";
//        self.lab_typeProperty.text = @"";
//        self.lab_type.text = list1.typeName;
//        if (list1.property.length!=0&&[[self stringToJSON:list1.property] count]!=0) {
//            NSString * propertyTxt = @"";
//            NSArray * arr = [self stringToJSON:list1.property];
//            for (NSDictionary * dic in arr) {
//                NSString * str = @"";
//                NSArray * arr1 = dic[@"childs"];
//                for (NSDictionary * dic1 in arr1) {
//                    if (str.length==0) {
//                        str = dic1[@"name"];
//                    }else
//                    str = [NSString stringWithFormat:@"%@,%@",dic1[@"name"],str];
//                }
//                propertyTxt = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%@:%@",dic[@"name"],str],propertyTxt];
//            }
//            self.lab_DW.text =propertyTxt;
//        }else{
//            self.lab_DW.text = @"";
//        }
        self.lab_LLNum.text = [NSString stringWithFormat:@"浏览%@次",list1.browseTimes?list1.browseTimes:@"999+"];
        self.lab_DTNum.text = KString(@"%lu", (unsigned long)list1.serviceCircleList.count);
        if (![YSTools dx_isNullOrNilWithObject:list.serviceCircleList]&&[list.serviceCircleList isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dic in list.serviceCircleList) {
                if ([[dic[@"containsImage"] description] isEqualToString:@"1"] && ![YSTools dx_isNullOrNilWithObject:dic[@"images"]]) {
                    NSArray * arr2 = [dic[@"images"] componentsSeparatedByString:@";"];
                    for (int i=0; i<([arr2 count]>4?4:arr2.count); i++) {
                        if ([arr2[i] length]!=0) {
                            if (_arr_image.count!=0) {
                                UIImageView * image = _arr_image[i];
                                image.hidden = NO;
                                [image sd_setImageWithURL:[NSURL URLWithString:arr2[i]] placeholderImage:[UIImage imageNamed:@"no-pic"]];
                            }
                        }
                    }
                    break;
                }
            }
        }
        
    }
}
-(void)setPropertyName:(NSString *)propertyName{
    _propertyName = propertyName;
    self.lab_typeProperty.text = propertyName;
}
-(void)setTypeName:(NSString *)typeName{
    _typeName = typeName;
    self.lab_type.text = typeName;
}
-(void)setCommentrval:(comments *)commentrval{
    _commentrval = commentrval;
    [self.imgae_Comment sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commentrval.user.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
    self.lab_commentTitle.text = commentrval.user.nickName?commentrval.user.nickName:commentrval.user.ID;
    self.lab_Comment.text = commentrval.content;
    self.lab_HF.text = commentrval.replyList.count!=0?commentrval.replyList[0][@"content"]:@"";
    self.lab_CommentTime.text = [commentrval.createTime componentsSeparatedByString:@" "][0];
    commentrval.cellHeight = 45+[YSTools cauculateHeightOfText:self.lab_Comment.text width:(self.width-60) font:13]+[YSTools cauculateHeightOfText:self.lab_HF.text width:(self.width-80) font:13];
}
-(void)setCommen:(commentList *)commen{
    _commen = commen;
    [self.imgae_Comment sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",commen.user.headImage,SMALLPICTURE]] placeholderImage:[UIImage imageNamed:@"logo2"]];
    self.lab_commentTitle.text = commen.user.nickName?commen.user.nickName:commen.user.ID;
    self.lab_Comment.text = commen.content;
    self.lab_HF.text = commen.replyList.count!=0?commen.replyList[0][@"content"]:@"";
    self.lab_CommentTime.text = [commen.createTime componentsSeparatedByString:@" "][0];
    commen.cellHeight = 45+[YSTools cauculateHeightOfText:self.lab_Comment.text width:(self.width-60) font:13]+[YSTools cauculateHeightOfText:self.lab_HF.text width:(self.width-80) font:13];
}
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
- (IBAction)YDClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:sender.tag];
    }
}
-(CAShapeLayer *)drawDottedLine{
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    //设置虚线颜色为blackColor
    [dotteShapeLayer setStrokeColor:YSColor(224, 224, 226).CGColor];
    //设置虚线宽度
    dotteShapeLayer.lineWidth = 2.0f ;
    //10=线的宽度 5=每条线的间距
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath, NULL, 8 ,0);
    CGPathAddLineToPoint(dotteShapePath, NULL, kScreenWidth-40, 0);
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    return dotteShapeLayer;
}
@end
