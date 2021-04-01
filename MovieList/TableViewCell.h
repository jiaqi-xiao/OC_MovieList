//
//  TableViewCell.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import <UIKit/UIKit.h>

//#import "MovieDataModel.h"

@class MovieDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) MovieDataModel* model;
- (void)updateCellWithModel:(MovieDataModel*)model tableView:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
