//
//  MomentsCommentView.m
//  WechatMoments
//

#import "MomentsCommentView.h"
#import "UIView+SDAutoLayout.h"

@interface MomentsCommentView ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) NSMutableArray *commentLabelArray;

@end

@implementation MomentsCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _commentLabelArray = [[NSMutableArray alloc] init];

    _bgImageView = [[UIImageView alloc] init];
    UIImage *bgImage = [[UIImage imageNamed:@"ic_bg_comment"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;

    for (UILabel *label in _commentLabelArray) {
        [label sd_clearAutoLayoutSettings];
        label.hidden = YES;
    }
    if (_comments && _comments.count > 0) {
        self.fixedWidth = nil;
        self.fixedHeight = nil;
        UIView *bottomView;
        [self setupCommentLabelArray];
        for (int i = 0; i < _comments.count; i++) {
            NSDictionary *commentObj = _comments[i];
            NSAttributedString *attributedContent = [self getAttributedContent:commentObj];
            UILabel *label = _commentLabelArray[i];
            label.hidden = NO;
            label.attributedText = attributedContent;
            label.isAttributedContent = YES;
            CGFloat topMargin = i == 0 ? 10 : 5;
            label.sd_layout.leftSpaceToView(self, 8).rightSpaceToView(self, 5).topSpaceToView(bottomView, topMargin).autoHeightRatio(0);

            bottomView = label;
        }
        [self setupAutoHeightWithBottomView:bottomView bottomMargin:5];
    } else {
        self.fixedWidth = @(0);
        self.fixedHeight = @(0);
    }
}

- (void)setupCommentLabelArray {
    NSInteger addCount = _comments.count - _commentLabelArray.count;
    if (addCount > 0) {
        for (int i = 0; i < addCount; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.hidden = YES;
            [self addSubview:label];
            [_commentLabelArray addObject:label];
        }
    }
}

- (NSMutableAttributedString *)getAttributedContent:(NSDictionary *)comment {
    NSString *nick = comment[@"sender"][@"nick"];
    NSString *content = [NSString stringWithFormat:@"%@：%@", nick, comment[@"content"]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    [attString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:77 / 255.0
                                                                               green:93 / 255.0
                                                                                blue:136 / 255.0
                                                                               alpha:1.0]}
                       range:NSMakeRange(0, nick.length)];
    return attString;
}


@end
