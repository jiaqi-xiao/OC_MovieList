//
//  TableViewCell.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import "TableViewCell.h"
#import "MovieDataModel.h"
#import "ImageDownloader.h"

@interface TableViewCell ()

@property (nonatomic, assign) BOOL needDisplay; //NO

@end

@implementation TableViewCell

- (void)updateCellWithData:(MovieDataModel*)data andTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
{
    //title
    self.textLabel.text = data.title;
    
//    UIImage* image = [ImageDownloader loadLocalImage:data.imgUrl];
//    if (!image) {
//        self.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
//
//        // image
//        [ImageDownloader startDownloadImage:data.imgUrl indexPath:indexPath completion:^(UIImage *image) {
//            // 如果当前行还在当前屏幕内，就刷新，否则不刷新
////            for (NSIndexPath* innnerIndexPath in tableView.indexPathsForVisibleRows) {
////                if (innnerIndexPath.row == indexPath.row) {
////                    self.imageView.image = image;
////                    break;
////                }
////            }
////            NSLog(@"#### %@, %@", data.imgUrl, imageUrl);
//
//            if ([tableView.indexPathsForVisibleRows containsObject: indexPath]) {
//                self.imageView.image = image;
//            }
//        }];
//
//    } else {
//        self.imageView.image = image;
//    }
    
    // init dictionary
//    [ImageDownloader imageDics];
    UIImage* image = [ImageDownloader loadLocalImage:data.imgUrl];
    if (!image) {
        self.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];

        // image
        [ImageDownloader startDownloadImage:data.imgUrl indexPath:indexPath completion:^(UIImage *image) {
            // 如果当前行还在当前屏幕内，就刷新，否则不刷新
            if ([tableView.indexPathsForVisibleRows containsObject: indexPath]) {
                self.imageView.image = image;
            }
        }];

    } else {
        if ([tableView.indexPathsForVisibleRows containsObject: indexPath]) {
            self.imageView.image = image;
        }
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    }
    return self;
}

@end
