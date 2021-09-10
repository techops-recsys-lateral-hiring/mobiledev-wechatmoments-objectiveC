//
//  MomentsTableViewCell.m
//  WechatMoments
//

#import "MomentsTableViewCell.h"
#import "MomentsPhotoView.h"
#import "MomentsCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+Web.h"
#import "UIImage+Color.h"

@interface MomentsTableViewCell ()
// UI controls
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nickLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) MomentsPhotoView *photoView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIButton *moreButton;
@property(nonatomic, strong) UIButton *operateButton;
@property(nonatomic, strong) MomentsCommentView *commentView;

// Data
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) NSDictionary *tweet;
@property(nonatomic, assign) BOOL shouldShowMoreButton;
@property(nonatomic, assign) BOOL isOpening;

@end

@implementation MomentsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Add controls
    _avatarImageView = [[UIImageView alloc] init];

    _nickLabel = [[UILabel alloc] init];
    _nickLabel.font = [UIFont systemFontOfSize:14];
    _nickLabel.textColor = [UIColor colorWithRed:77 / 255.0 green:93 / 255.0 blue:136 / 255.0 alpha:1.0];

    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    _moreButton = [[UIButton alloc] init];
    [_moreButton setTitle:@"Full text" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor colorWithRed:77 / 255.0 green:93 / 255.0 blue:136 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(clickedMoreButton) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];

    _photoView = [[MomentsPhotoView alloc] init];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithRed:103 / 255.0 green:103 / 255.0 blue:103 / 255.0 alpha:1.0];

    _operateButton = [[UIButton alloc] init];
    [_operateButton setImage:[UIImage imageNamed:@"btn_operate"] forState:UIControlStateNormal];

    _commentView = [[MomentsCommentView alloc] init];

    NSArray *subViews = @[_avatarImageView, _nickLabel, _contentLabel, _moreButton, _photoView, _timeLabel, _operateButton, _commentView];
    [self.contentView sd_addSubviews:subViews];
    // Control layout
    _avatarImageView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 15).widthIs(40).heightIs(40);
    _nickLabel.sd_layout.leftSpaceToView(_avatarImageView, 10).topEqualToView(_avatarImageView).rightSpaceToView(self.contentView, 10).heightIs(18);
    _contentLabel.sd_layout.leftEqualToView(_nickLabel).topSpaceToView(_nickLabel, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    _moreButton.sd_layout.leftEqualToView(_contentLabel).topSpaceToView(_contentLabel, 5).widthIs(60);
    _photoView.sd_layout.leftEqualToView(_contentLabel);
    _timeLabel.sd_layout.leftEqualToView(_contentLabel).topSpaceToView(_photoView, 10).heightIs(15).widthIs(150);
    _operateButton.sd_layout.rightEqualToView(_contentLabel).centerYEqualToView(_timeLabel).heightIs(25).widthIs(25);
    _commentView.sd_layout.leftEqualToView(_contentLabel).rightEqualToView(_contentLabel).topSpaceToView(_timeLabel, 10);
}

- (void)configCell:(NSIndexPath *)indexPath
            tweets:(NSArray *)tweets
listOfShouldShowMoreButton:(NSArray *)listOfShouldShowMoreButton
    listOfIsOpening:(NSArray *)listOfIsOpening {
    _indexPath = indexPath;
    _tweet = tweets[indexPath.row];
    _shouldShowMoreButton = listOfShouldShowMoreButton[indexPath.row];
    _isOpening = listOfIsOpening[indexPath.row];

    NSArray *comments = _tweet[@"Comment"];
    _commentView.comments = comments;
    _nickLabel.text = _tweet[@"sender"][@"nick"];
    _contentLabel.text = _tweet[@"content"];
    _timeLabel.text = @"3 minutes ago";
    NSArray *images = _tweet[@"images"];
    _photoView.imageArray = images;
    [_avatarImageView jf_setImageWithURL:_tweet[@"sender"][@"avatar"]
                        placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:234 / 255.0
                                                                                 green:234 / 255.0
                                                                                  blue:234 / 255.0
                                                                                 alpha:1.0]]];

    if (_shouldShowMoreButton) {
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (_isOpening) {
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"Put away" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(54);
            [_moreButton setTitle:@"Full text" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }

    CGFloat photoTop = images.count > 0 ? 10 : 0;
    NSString *content = _tweet[@"content"];
    UIView *topView = (content == nil || content.length == 0) ? _nickLabel : _moreButton;
    _photoView.sd_layout.topSpaceToView(topView, photoTop);

    UIView *bottomView = comments.count > 0 ? _commentView : _timeLabel;

    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
}

- (void)clickedMoreButton {
    _isOpening = !_isOpening;
    if (self.clickedMoreButtonBlock) {
        self.clickedMoreButtonBlock(_indexPath);
    }
}

@end
