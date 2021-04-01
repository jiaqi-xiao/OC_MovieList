//
//  ImageDownloader.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/30.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloader : NSObject

//开始下载图像
+ (void)startDownloadImage:(NSString *)imageUrl indexPath:(NSIndexPath*)indexPath completion:(void (^)(UIImage* image))completion;
+ (UIImage *)loadLocalImage:(NSString *)imageUrl;

// (imgUrl, image)
@property(class, nonatomic, strong)NSMutableDictionary* imageDics;


@end

NS_ASSUME_NONNULL_END
