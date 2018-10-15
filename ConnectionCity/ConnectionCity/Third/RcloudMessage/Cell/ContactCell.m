//
//  ContactCell.m
//  ConnectionCity
//
//  Created by umbrella on 2018/10/15.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ContactCell.h"
#import "UIColor+RCColor.h"
@implementation ContactCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize {
    _portraitView = [[UIImageView alloc] init];
    _portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    _portraitView.frame = CGRectMake(10, 8, 40, 40);
    _portraitView.layer.cornerRadius = 2;
    _portraitView.layer.masksToBounds = YES;
    [self.contentView addSubview:_portraitView];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nicknameLabel.frame = CGRectMake(_portraitView.width+20, 8, 200, 40);
    [_nicknameLabel setFont:[UIFont fontWithName:@"Heiti SC" size:15.0]];
    [self.contentView addSubview:_nicknameLabel];
 
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_statusLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14.0]];
    _statusLabel.frame = CGRectMake(kScreenWidth-100, 8, 70, 40);
    _statusLabel.textColor = [UIColor lightGrayColor];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_statusLabel];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor =[UIColor colorWithHexString:@"f5f5f5" alpha:1.0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
