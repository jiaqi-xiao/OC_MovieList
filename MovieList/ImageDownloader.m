//
//  ImageDownloader.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/30.
//

#import "ImageDownloader.h"
#import "UIKit/UIKit.h"

static NSMutableDictionary *imageDics;

@implementation ImageDownloader

@dynamic imageDics;
#pragma mark - 异步加载

+ (void)load {
    imageDics = [NSMutableDictionary dictionary];
}
//+ (void)addImageDics:(NSString*)key imageData:(UIImage*)image{
//    imageDics[key] = image;
//}

+ (void)startDownloadImage:(NSString *)imageUrl indexPath:(NSIndexPath*)indexPath completion:(void (^)(UIImage* image))completion
{
    // 先判断本地沙盒是否已经存在图像，存在直接获取，不存在再下载，下载后保存
    // 存在沙盒的Caches的子文件夹DownloadImages中
    
    __block UIImage * image = nil;
    
    if(image == nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                image = [UIImage imageWithData:imageData];
//                NSLog(@"download image: %@", imageUrl);
                //write to model
    //            [imageDics setObject:image forKey:imageUrl];
    //            imageDics[imageUrl] = [UIImage imageWithData:imageData];
    //            [self addImageDics:imageUrl imageData:[UIImage imageWithData:imageData]];
                
    //            if (imageDics[imageUrl]) {
    //                NSLog(@"write image to memory");
    //            }
                // write to cache
//            if (![[NSFileManager defaultManager] fileExistsAtPath:[self imageFilePath:imageUrl]]) {
                [imageData writeToFile:[self imageFilePath:imageUrl] atomically:YES];
//                NSLog(@"write image path: %@", [self imageFilePath:imageUrl]);
//            }
                
//            //write to model
//            [imageDics setObject:image forKey:[self imageFilePath:imageUrl]];
//            NSLog(@"write image to memory");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(image);
                }
            });
        });
    }
    
    
//
//    //IO
//    image = [ImageDownloader loadLocalImage:imageUrl];
//    else {
//        if (completion) {
//            completion(image, indexPath);
//        }
//    }
}


#pragma mark - 加载本地图像
+ (UIImage *)loadLocalImage:(NSString *)imageUrl
{
    UIImage* image = nil;
//    UIImage* image = imageDics[imageUrl];
//    if (!image) {
        // 获取图像路径
        NSString * filePath = [self imageFilePath:imageUrl];
        image = [UIImage imageWithContentsOfFile:filePath];
//        imageDics[imageUrl] = image;
//        if (image) {
//            imageDics[imageUrl] = image;
//            NSLog(@"load image from cache");
//        }
//    }
    return image;
}

#pragma mark - 获取图像路径
+ (NSString *)imageFilePath:(NSString *)imageUrl
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
