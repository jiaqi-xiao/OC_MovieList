//
//  TableViewCell.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import <UIKit/UIKit.h>

//#import "MovieDataModel.h"

@class MovieDataModel;
@class ImageDownloader;

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

- (void)updateCellWithData:(MovieDataModel*)data andTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

//-(void) getJSON;

@end

NS_ASSUME_NONNULL_END
