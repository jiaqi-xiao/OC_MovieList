//
//  TableTableViewController.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *movies;
@property(nonatomic, strong) ImageDownloader *downloader;

@end

NS_ASSUME_NONNULL_END
