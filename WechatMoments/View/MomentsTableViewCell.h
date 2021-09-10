//
//  MomentsTableViewCell.h
//  WechatMoments
//

#import <UIKit/UIKit.h>

@interface MomentsTableViewCell : UITableViewCell

/**
 More button click callback
 */
@property(nonatomic, copy) void (^clickedMoreButtonBlock)(NSIndexPath *indexPath);

/**
 Set cell data

 @param indexPath Current NSIndexPath
 @param tweets Data source
 */
- (void)configCell:(NSIndexPath *)indexPath
            tweets:(NSArray *)tweets
listOfShouldShowMoreButton:(NSArray *)listOfShouldShowMoreButton
    listOfIsOpening:(NSArray *)listOfIsOpening;

@end
