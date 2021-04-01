//
//  MovieDataModel.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/29.
//

#import "MovieDataModel.h"

@implementation MovieDataModel

-(instancetype)initWithTitle:(NSString*)title imgUrl:(NSString*)imgUrl row:(NSInteger)row;
{
    if (self = [super init]) {
        _title = title;
        _imgUrl = imgUrl;
        _row = row;
    }
    return self;
}

@end
