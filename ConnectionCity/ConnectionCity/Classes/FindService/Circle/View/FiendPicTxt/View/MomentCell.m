//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "MomentKit.h"
#import <MLLabel/MLLinkLabel.h>
#import "MLLabelUtil.h"
#import "UIView+Geometry.h"
#import "Utility.h"
#import "privateUserInfoModel.h"
#define TitleColor  [UIColor colorWithRed:179 / 255.0 green:179 / 255.0 blue:179 / 255.0 alpha:1.0]
#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
        
    }
    return self;
}

- (void)setUpUI
{
    
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)];
    [_headImageView addGestureRecognizer:tapGesture];
    // 名字视图
    _nameLab = [[UILabel alloc] init];
    _nameLab.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLab.textColor = kHLTextColor;
    _nameLab.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLab];
    // 正文视图
    _linkLabel = kMLLinkLabel();
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
//    _linkLabel.linkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor};
//    _linkLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:kLinkTextColor,NSBackgroundColorAttributeName:kHLBgColor};
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc]init];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageListView];
    // 位置视图
    _locationLab = [[UILabel alloc] init];
    _locationLab.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _locationLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_locationLab];
    // 时间视图
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = TitleColor;
    _timeLab.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLab];
   
    //点赞
    _praiseBtn = [[UIButton alloc] init];
    _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _praiseBtn.backgroundColor = [UIColor clearColor];
    [_praiseBtn setTitle:@"点赞(999+)" forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [_praiseBtn addTarget:self action:@selector(priseMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_praiseBtn];
    //评论
    _commentBtn = [[UIButton alloc] init];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _commentBtn.backgroundColor = [UIColor clearColor];
    [_commentBtn setTitle:@"评论(999+)" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
 
    //分享
    _shareBtn = [[UIButton alloc] init];
    _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _shareBtn.backgroundColor = [UIColor clearColor];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"f-share"] forState:UIControlStateNormal];
    [_shareBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:0];
    [_shareBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareBtn];
    
    //分享
    _letterBtn = [[UIButton alloc] init];
    _letterBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _letterBtn.backgroundColor = [UIColor clearColor];
    [_letterBtn setTitle:@"私信" forState:UIControlStateNormal];
    [_letterBtn setImage:[UIImage imageNamed:@"f-sixin"] forState:UIControlStateNormal];
    [_letterBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:0];
    [_letterBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    [_letterBtn addTarget:self action:@selector(letterMoment:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_letterBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    [self.contentView addSubview:_commentView];
   
    // 最大高度限制
    maxLimitHeight = _linkLabel.font.lineHeight * 6;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:moment.userMo.headImage] placeholderImage:[UIImage imageNamed:@"no-pic"]];
    // 昵称
    _nameLab.text = moment.userMo.nickName;
    _nameLab.frame = CGRectMake(_headImageView.right+10, _headImageView.top, [YSTools caculateTheWidthOfLableText:16 withTitle:_nameLab.text], 20);
    _timeLab.text = [YSTools compareCurrentTime:moment.createTime];
    CGFloat textW = [_timeLab.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_timeLab.font}
                                                context:nil].size.width;
    _timeLab.frame = CGRectMake(_nameLab.right+10, _nameLab.top, textW, kTimeLabelH);
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _nameLab.bottom + kPaddingValue;
    if ([moment.content length]) {
        _linkLabel.hidden = NO;
        _linkLabel.text = moment.content;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labH = attrStrSize.height;
        if (labH > maxLimitHeight) {
            if (!_moment.isFullText) {
                labH = maxLimitHeight;
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
            } else {
                [self.showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
            _showAllBtn.hidden = NO;
        }
        _linkLabel.frame = CGRectMake(_nameLab.left, bottom, attrStrSize.width, labH);
        _showAllBtn.frame = CGRectMake(_nameLab.left, _linkLabel.bottom + kArrowHeight, kMoreLabWidth, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
    }
    // 图片
    _imageListView.moment = moment;
    if (moment.fileCount > 0) {
        _imageListView.origin = CGPointMake(_nameLab.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置
    _locationLab.frame = CGRectMake(_nameLab.left, bottom, _nameLab.width, kTimeLabelH);
//    long long a = [[YSTools cTimestampFromString:moment.createTime] floatValue];
    if ([moment.cityName length]) {
        _locationLab.hidden = NO;
        _locationLab.text = moment.cityName;
        _praiseBtn.frame = CGRectMake(_nameLab.left-10, _locationLab.bottom+kPaddingValue, 60, kTimeLabelH);
    } else {
        _locationLab.hidden = YES;
        _praiseBtn.frame = CGRectMake(_nameLab.left-10, bottom, 60, kTimeLabelH);
    }
    [_praiseBtn setTitle:[NSString stringWithFormat:@"点赞(%@)",moment.likeCount?moment.likeCount:@"999+"] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@"评论(%@)",moment.commentCount?moment.commentCount:@"999+"] forState:UIControlStateNormal];
//    _praiseBtn.frame = CGRectMake(_timeLab.right+1, _timeLab.top, 60, kTimeLabelH);
    _commentBtn.frame = CGRectMake(_praiseBtn.right+1, _praiseBtn.top, 60, kTimeLabelH);
    _shareBtn.frame = CGRectMake(_commentBtn.right+1, _praiseBtn.top, 50, kTimeLabelH);
    _letterBtn.frame = CGRectMake(_shareBtn.right+1, _praiseBtn.top, 50, kTimeLabelH);
    
    bottom = _praiseBtn.bottom + kPaddingValue;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = kWidth-kRightMargin-_nameLab.left-20;
    if (moment.praiseNameList.length) {
        MLLinkLabel *likeLabel = kMLLinkLabel();
        likeLabel.delegate = self;
        likeLabel.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);
        CGSize attrStrSize = [likeLabel preferredSizeWithMaxWidth:kTextWidth];
        likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        [_commentView addSubview:likeLabel];
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, likeLabel.bottom + 7, width, 0.5)];
        line.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        [_commentView addSubview:line];
        // 更新
        top = attrStrSize.height + 15;
    }
    // 处理评论
    NSInteger count = [moment.comments count];
    if (count > 0) {
        for (NSInteger i = count-1; i < count; i ++) {
            Comment * comment = moment.comments[i];
            if ([[comment.user.ID description] isEqualToString:[[YSAccountTool userInfo] modelId]]) {
                CommentLabel *label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
                label.comment = [moment.comments objectAtIndex:i];
                [label setDidClickText:^(Comment *comment) {
                    if ([self.delegate respondsToSelector:@selector(didSelectComment:)]) {
                        [self.delegate didSelectComment:comment];
                    }
                }];
                [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
                    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:momentCell:)]) {
                        [self.delegate didClickLink:link linkText:linkText momentCell:self];
                    }
                }];
                [_commentView addSubview:label];
                // 更新
                top += label.height;
            }
        }
    }
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(_nameLab.left, bottom, width, top + kArrowHeight);
        _bgImageView.image = [[UIImage imageNamed:@"comment_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
        _commentView.frame = CGRectMake(_nameLab.left, bottom + kArrowHeight, width, top);
    }
}

#pragma mark - 获取行高
+ (CGFloat)momentCellHeightForMoment:(Moment *)moment;
{
    CGFloat height = kBlank;
    // 名字
    height += kNameLabelH+kPaddingValue;
    // 正文
    if (moment.content.length) {
        MLLinkLabel *linkLab = kMLLinkLabel();
        linkLab.font = kTextFont;
        linkLab.text =  moment.content;
        CGFloat labH = [linkLab preferredSizeWithMaxWidth:kTextWidth].height;
        BOOL isHide = YES;
        if (labH > maxLimitHeight) {
            if (!moment.isFullText) {
                labH = maxLimitHeight;
            }
            isHide = NO;
        }
        if (isHide) {
            height += labH + kPaddingValue;
        } else {
            height += labH + kArrowHeight + kMoreLabHeight + kPaddingValue;
        }
    }
    // 图片
    height += [MMImageListView imageListHeightForMoment:moment]+kPaddingValue;
    // 地理位置
    if ([moment.cityName length]) {
        height += kTimeLabelH+kPaddingValue;
    }
    // 时间
    height += kTimeLabelH+kPaddingValue;
    // 如果赞或评论不空，加kArrowHeight
    CGFloat addH = 0;
    // 赞
    if (moment.praiseNameList.length) {
        addH = kArrowHeight;
        MLLinkLabel *linkLab = kMLLinkLabel();
        linkLab.attributedText = kMLLinkLabelAttributedText(moment.praiseNameList);;
        height += [linkLab preferredSizeWithMaxWidth:kTextWidth].height + 15;
    }
    // 评论
    NSInteger count = [moment.comments count];
    if (count > 0) {
        addH = kArrowHeight;
        MLLinkLabel *linkLab = kMLLinkLabel();
        for (NSInteger i = count-1; i < count; i ++) {
            Comment * comment = moment.comments[i];
            if ([[comment.user.ID description] isEqualToString:[[YSAccountTool userInfo] modelId]]) {
                linkLab.attributedText = kMLLinkLabelAttributedText([moment.comments objectAtIndex:i]);
                CGFloat commentH = [linkLab preferredSizeWithMaxWidth:kTextWidth].height + 5;
                height += commentH;
            }
        }
    }
    if (addH == 0) {
        height -= kPaddingValue;
    }
    height += kBlank + addH;
    return height;
}

#pragma mark - 点击事件
// 查看全文/收起
- (void)fullTextClicked:(UIButton *)bt
{
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        _showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        _moment.isFullText = !_moment.isFullText;
        if ([self.delegate respondsToSelector:@selector(didSelectFullText:)]) {
            [self.delegate didSelectFullText:self];
        }
    });
}

// 点击头像
- (void)clickHead:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(didClickHead:)]) {
        [self.delegate didClickHead:self];
    }
}
#pragma mark ----#warning 点赞------
-(void)priseMoment:(UIButton *)bt{
    if ([self.delegate respondsToSelector:@selector(didPraiseMoment:)]) {
        [self.delegate didPraiseMoment:self];
    }
}
#pragma mark --- #warning 评论------
-(void)commentMoment:(UIButton *)bt{
    if ([self.delegate respondsToSelector:@selector(didCommentMoment:)]) {
        [self.delegate didCommentMoment:self];
    }
}
#pragma mark ----#warning 分享-----
-(void)shareMoment:(UIButton *)bt{
    if ([self.delegate respondsToSelector:@selector(didShareMoment:)]) {
        [self.delegate didShareMoment:self];
    }
}
#pragma mark -----#warning 私信----
-(void)letterMoment:(UIButton *)bt{
    if ([self.delegate respondsToSelector:@selector(didLetterMoment:)]) {
        [self.delegate didLetterMoment:self];
    }
}
// 删除动态
//- (void)deleteMoment:(UIButton *)bt
//{
//    _deleteBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
//    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
//    dispatch_after(when, dispatch_get_main_queue(), ^{
//        _deleteBtn.titleLabel.backgroundColor = [UIColor clearColor];
//        if ([self.delegate respondsToSelector:@selector(didDeleteMoment:)]) {
//            [self.delegate didDeleteMoment:self];
//        }
//    });
//}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:momentCell:)]) {
        [self.delegate didClickLink:link linkText:linkText momentCell:self];
    }
}
@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel();
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    _linkLabel.attributedText = kMLLinkLabelAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 5;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(link,linkText);
    }
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
        if (self.didClickText) {
            self.didClickText(_comment);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}

@end
