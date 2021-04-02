//
//  MovieDataModel.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieDataModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, assign) NSInteger row;


-(instancetype)initWithTitle:(NSString*)title imgUrl:(NSString*)imgUrl row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
