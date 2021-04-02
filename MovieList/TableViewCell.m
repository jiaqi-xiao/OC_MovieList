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

@end

@implementation TableViewCell

- (void)updateCellWithModel:(MovieDataModel*)model tableView:(UITableView*)tableView;
{
    self.textLabel.text = model.title;
    [[ImageDownloader sharedDownloader] downloadImageWithModel:(MovieDataModel*)model tableView:tableView imageView:self.imageView placeholder:[UIImage imageNamed:@"placeholder.jpg"]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    return self;
}

@end
