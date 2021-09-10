//
//  MomentsTableViewController.m
//  WechatMoments
//

#import "MomentsTableViewController.h"
#import "MomentsTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "MJRefresh.h"
#import "UIImageView+Web.h"
#import "UIImage+Color.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Config.h"
#import "NetRequest.h"

static NSString *reuseIdentifier = @"reuseIdentifier";

@interface MomentsTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property(weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property(weak, nonatomic) IBOutlet UILabel *nickLabel;
/**
 Data currently displayed by tableview
 */
@property (nonatomic, strong) NSMutableArray *tweets;

/**
 All valid data requested
 */
@property (nonatomic, strong) NSMutableArray *allTweets;

@property (nonatomic, strong) NSMutableArray *listOfShouldShowMoreButton;
@property (nonatomic, strong) NSMutableArray *listOfIsOpening;

@property (nonatomic, strong) SuccessBlock tweetsSuccessBlock;

@end

@implementation MomentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self requestData];
}

- (void)requestData {
    _allTweets = [[NSMutableArray alloc] init];
    _tweets = [[NSMutableArray alloc] init];
    _listOfShouldShowMoreButton = [[NSMutableArray alloc] init];
    _listOfIsOpening = [[NSMutableArray alloc] init];
    [self requestUserInfo];
    [self requestTweets];
}

- (void)setupTableView {
    self.tableView.estimatedRowHeight = 0;
    [self.tableView registerClass:[MomentsTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    // Retry when the data request fails through the delegate, click Retry
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    self.tableView.tableFooterView = [UIView new];
    // Pull down to refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
    }];
    // Pull up to load more
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - Request

- (void)requestUserInfo {
    __weak typeof(self) weakSelf = self;
    [NetRequest RequestGetWithUrl:UserInfoUrl success:^(id response) {
        NSString *profileImage = response[@"profile-image"];
        NSString *avatar = response[@"avatar"];
        NSString *nick = response[@"nick"];
        [weakSelf.bgImageView jf_setImageWithURL:profileImage placeholderImage:[UIImage imageNamed:@"ic_bg_header"]];
        [weakSelf.avatarImageView jf_setImageWithURL:avatar
                                    placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:234 / 255.0
                                                                                             green:234 / 255.0
                                                                                              blue:234 / 255.0
                                                                                             alpha:1.0]]];
        weakSelf.avatarImageView.layer.borderColor = [UIColor colorWithRed:231 / 255.0
                                                                     green:231 / 255.0
                                                                      blue:231 / 255.0
                                                                     alpha:1.0].CGColor;
        weakSelf.avatarImageView.layer.borderWidth = 1;
        weakSelf.nickLabel.text = nick;
    } failure:^(NSError *error) {
        NSLog(@"Request failed %@", error);
    }];
}

- (void)requestTweets {
    __weak typeof(self) weakSelf = self;
    [NetRequest RequestGetWithUrl:UserTweetsUrl success:^(id response) {
        NSArray *all = (NSArray *)response;
        [self checkResponse:all];
        [self refresh];
    } failure:^(NSError *error) {
        NSLog(@"Request failed %@", error);
    }];

    _tweetsSuccessBlock = ^(id response) {
      weakSelf.tableView.mj_footer.hidden = NO;
      if (weakSelf.tableView.mj_header.isRefreshing) {
          [weakSelf.tableView.mj_header endRefreshing];
          [weakSelf.tableView.mj_footer resetNoMoreData];
      } else if (weakSelf.tableView.mj_footer.isRefreshing) {
          if (_tweets.count < _allTweets.count) {
              [weakSelf.tableView.mj_footer endRefreshing];
          } else {
              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
          }
      }
      [weakSelf.tableView reloadData];
  };
}

- (void)refresh {
    [_tweets removeAllObjects];
    if (_allTweets.count <= 5) {
        [_tweets addObjectsFromArray:_allTweets];
    } else {
        [_tweets addObjectsFromArray:[_allTweets subarrayWithRange:NSMakeRange(0, 5)]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tweetsSuccessBlock(_tweets);
    });
}

- (void)loadMore {
    NSInteger diffCount = _allTweets.count - _tweets.count;
    if (diffCount <= 5) {
        [_tweets addObjectsFromArray:[_allTweets subarrayWithRange:NSMakeRange(_tweets.count, diffCount)]];
    } else {
        [_tweets addObjectsFromArray:[_allTweets subarrayWithRange:NSMakeRange(_tweets.count, 5)]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tweetsSuccessBlock(_tweets);
    });
}

- (NSInteger)checkResponse:(NSArray *)allTweet {
    for (NSDictionary *tweet in allTweet) {
        NSString *content = tweet[@"content"];
        
        CGRect textRect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                context:nil];
        // When the text height is greater than the set height, the "full text" button is displayed
        if (textRect.size.height > 54) {
            [_listOfShouldShowMoreButton addObject:@(YES)];
        } else {
            [_listOfShouldShowMoreButton addObject:@(NO)];
        }
        [_listOfIsOpening addObject:@(NO)];
        [_allTweets addObject:tweet];
    }
    return _allTweets.count;
}

- (void)toggleIsOpeningAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldShowMoreButton = [_listOfShouldShowMoreButton[indexPath.row] boolValue];
    BOOL isOpening = [_listOfIsOpening[indexPath.row] boolValue];
    if (shouldShowMoreButton == NO) {
        [_listOfIsOpening replaceObjectAtIndex:indexPath.row withObject:@(NO)];
    } else {
        [_listOfIsOpening replaceObjectAtIndex:indexPath.row withObject:@(!isOpening)];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell prepareForReuse];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [cell configCell:indexPath tweets:_tweets listOfShouldShowMoreButton:_listOfShouldShowMoreButton listOfIsOpening:_listOfIsOpening];

    if (cell.clickedMoreButtonBlock == nil) {
        [cell setClickedMoreButtonBlock:^(NSIndexPath *indexPath) {
            [self toggleIsOpeningAtIndexPath:indexPath];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

#pragma mark - DZNEmptyDataSetSource

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 20;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],
            NSForegroundColorAttributeName: [UIColor blueColor]
    };
    return [[NSAttributedString alloc] initWithString:@"Retry" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self requestUserInfo];
    [self requestTweets];
}

@end
