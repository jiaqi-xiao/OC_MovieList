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

@property (nonatomic, strong) dispatch_queue_t queue; // serial queue to cache images
@property (nonatomic, strong) dispatch_queue_t downloadQueue; // concurrent queue to download images
@property (nonatomic, strong) NSMutableDictionary* memoryCache;
@property (nonatomic, strong) NSMutableArray* urlsRequesting; // current requesting urls

@end

@implementation ImageDownloader

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
    }
    return self;
}

- (void)downloadImageWithModel:(MovieDataModel*)model tableView:(UITableView*)tableView imageView:(UIImageView*)imageView placeholder:(UIImage*)placeholder;
{
    NSString* imageURL = model.imgUrl;
    UIImage* targetImage = [self loadCacheWithImageURL:imageURL];
    if (!targetImage) { //no cache
        //use placholder first if targetimage not exist
        imageView.image = placeholder;
        
        if (![self.urlsRequesting containsObject:imageURL]) { // current image url is not being requested
            [self.urlsRequesting addObject:imageURL]; // add url to requesting list
            // concurrent download images
            dispatch_async(self.downloadQueue, ^{
                // download iamge data
                NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                // successfully download
                if (imageData) {
                    UIImage* origImage = [UIImage imageWithData:imageData];
                    // cache image to memroy and disk
                    [self cacheDataWithImageURL:imageURL imageData:imageData image:origImage];
                    // realodData to refresh the view
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadData];
                    });
                }
                // requeest complete and remove it from the requesting list
                [self.urlsRequesting removeObject:imageURL];
            });
        }
    } else { // get image from cache
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
#pragma mark - 加载本地图像
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

    // 拼接图像文件在沙盒中的路径,因为图像URL有"/",要在存入前替换掉,随意用"_"代替
    NSString * imageName = [imageUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString * imageFilePath = [downloadImagesPath stringByAppendingPathComponent:imageName];

    return imageFilePath;
}
@end
