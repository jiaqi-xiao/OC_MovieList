//
//  ImageDownloader.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/30.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@class MovieDataModel;

@interface ImageDownloader : NSObject
+ (instancetype) sharedDownloader;

- (void)downloadImageWithModel:(MovieDataModel*)model tableView:(UITableView*)tableView imageView:(UIImageView*)imageView placeholder:(UIImage*)placeholder;

//开始下载图像
//- (void)updateCell:(UITableViewCell*)cell imageUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage;
//- (void)startDownloadImage:(NSString *)imageUrl completion:(void (^)(UIImage* image))completion;
//- (UIImage *)loadLocalImage:(NSString *)imageUrl;

// (imgUrl, image)
@property(class, nonatomic, strong)NSMutableDictionary* imageDics;


@end

NS_ASSUME_NONNULL_END
