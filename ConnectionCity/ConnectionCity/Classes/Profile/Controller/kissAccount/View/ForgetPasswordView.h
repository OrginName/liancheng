//
//  ForgetPasswordView.h
//  ConnectionCity
//
//  Created by umbrella on 2018/8/21.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KissModel.h"
@interface ForgetPasswordView : UIView
{
    NSString * YZM;
}
@property (nonatomic,strong) KissModel * modelR;
@property (weak, nonatomic) IBOutlet UITextField *txt_phone;
@property (weak, nonatomic) IBOutlet UITextField *txt_yzm;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPW;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPWAgain;
@property (weak, nonatomic) IBOutlet UITextField *txt_oldPW;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPW2;
@property (weak, nonatomic) IBOutlet UIButton *btn_YZM;
@property (weak, nonatomic) IBOutlet UITextField *txt_newPWAgain2; 
@end
