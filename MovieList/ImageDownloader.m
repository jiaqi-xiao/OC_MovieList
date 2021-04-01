//
//  ImageDownloader.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/30.
//

#import "ImageDownloader.h"
#import "UIKit/UIKit.h"
#import "MovieDataModel.h"
#import "TableViewCell.h"

//static NSMutableDictionary *imageDics;

static ImageDownloader* downloader = nil;

@interface ImageDownloader ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_queue_t downloadQueue;
@property (nonatomic, strong) NSMutableDictionary* memoryCache;
@property (nonatomic, strong) NSMutableArray* urlsRequesting;
@property (nonatomic, strong) NSMutableDictionary* images;

@end

@implementation ImageDownloader

@dynamic imageDics;
#pragma mark - 异步加载

+ (instancetype) sharedDownloader {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloader = [[self alloc] init];
    });
    return downloader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("image.request.serial.queue", NULL); //serial queue
        _downloadQueue = dispatch_get_global_queue(0, 0); //concurrent queue
        _memoryCache = [NSMutableDictionary dictionary];
        _urlsRequesting = [NSMutableArray array];
        _images = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)downloadImageWithModel:(MovieDataModel*)model tableView:(UITableView*)tableView imageView:(UIImageView*)imageView placeholder:(UIImage*)placeholder;
{
    NSString* imageURL = model.imgUrl;
    UIImage* targetImage = [self loadCacheWithImageURL:imageURL];
    if (!targetImage) {
        //use placholder if targetimage not exist
        imageView.image = placeholder;
        
        if (![self.urlsRequesting containsObject:imageURL]) {
            [self.urlsRequesting addObject:imageURL];
            
            dispatch_async(self.downloadQueue, ^{
                NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                if (imageData) {
                    UIImage* origImage = [UIImage imageWithData:imageData];
                    [self cacheDataWithImageURL:imageURL imageData:imageData image:origImage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadData];
//                        for (TableViewCell* cell in tableView.visibleCells) {
//                            NSUInteger innerRow = [tableView indexPathForCell:cell].row;
//                            if (innerRow == model.row || model.imgUrl == cell.model.imgUrl) {
//                                cell.imageView.image = origImage;
//                                break;
//                            }
//                        }
                    });
                }
                [self.urlsRequesting removeObject:imageURL];
            });
        }

    } else {
        imageView.image = targetImage;
    }
}

- (BOOL)cacheDataWithImageURL:(NSString*)imageURL imageData:(NSData*)imageData image:(UIImage*)origImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [imageData writeToFile:[self imageFilePath:imageURL] atomically:YES];
    });
    dispatch_async(self.queue, ^{
        if (imageURL && origImage) {
            [self.memoryCache setObject:origImage forKey:imageURL];
        }
    });
    return YES;
}

- (UIImage*)loadCacheWithImageURL:(NSString*)imageURL {
    if (!imageURL) {
        return nil;
    }
    
    UIImage* targetImage = [self.memoryCache objectForKey:imageURL];
    if (!targetImage) {
        targetImage = [UIImage imageWithContentsOfFile:[self imageFilePath:imageURL]];
        if (targetImage) {
            dispatch_async(self.queue, ^{
                if (imageURL && targetImage) {
                    [self.memoryCache setObject:targetImage forKey:imageURL];
                }
            });
        }
    }
    return targetImage;
}

//- (void)updateCell:(UITableViewCell*)cell imageUrl:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage {
//    UIImage* image = [self loadLocalImage:imageUrl];
//
//    if (!image) {
//        cell.imageView.image = placeholderImage;
//            [self startDownloadImage:imageUrl completion:^(UIImage *image) {
//                cell.imageView.image = image;
//            }];
//
//    } else {
//        cell.imageView.image = image;
//    }
//}

//- (void)startDownloadImage:(NSString *)imageUrl completion:(void (^)(UIImage* image))completion
//{
//    // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
//    // 存在沙盒的Caches的子文件夹DownloadImages中
//
//    __block UIImage * image = nil;
//
//    if(image == nil) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//                image = [UIImage imageWithData:imageData];
////                NSLog(@"download image: %@", imageUrl);
//                //write to model
//    //            [imageDics setObject:image forKey:imageUrl];
//    //            imageDics[imageUrl] = [UIImage imageWithData:imageData];
//    //            [self addImageDics:imageUrl imageData:[UIImage imageWithData:imageData]];
//
//    //            if (imageDics[imageUrl]) {
//    //                NSLog(@"write image to memory");
//    //            }
//                // write to cache
////            if (![[NSFileManager defaultManager] fileExistsAtPath:[self imageFilePath:imageUrl]]) {
//                [imageData writeToFile:[self imageFilePath:imageUrl] atomically:YES];
////                NSLog(@"write image path: %@", [self imageFilePath:imageUrl]);
////            }
//
////            //write to model
////            [imageDics setObject:image forKey:[self imageFilePath:imageUrl]];
////            NSLog(@"write image to memory");
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completion) {
//                    completion(image);
//                }
//            });
//        });
//
//    }
    
    
//
//    //IO
//    image = [ImageDownloader loadLocalImage:imageUrl];
//    else {
//        if (completion) {
//            completion(image, indexPath);
//        }
//    }
//}


#pragma mark - 加载本地图像
- (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    NSString * filePath = [self imageFilePath:imageUrl];
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - 获取图像路径
- (NSString *)imageFilePath:(NSString *)imageUrl
{
    // 获取caches文件夹路径, Documents,
    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

//    NSLog(@"caches = %@\n",cachesPath);

    // 创建DownloadImages文件夹 Documents/Cache/DownloadImages
    NSString * downloadImagesPath = [cachesPath stringByAppendingPathComponent:@"DownloadImages"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:downloadImagesPath]) {
        [fileManager createDirectoryAtPath:downloadImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

#pragma mark 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [downloadImagesPath stringByAppendingPathComponent:imageName];

    return imageFilePath;
}
@end
