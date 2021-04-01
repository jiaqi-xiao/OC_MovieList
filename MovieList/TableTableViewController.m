//
//  TableTableViewController.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import "TableTableViewController.h"
#import "TableViewCell.h"
#import "MovieDataModel.h"
#import "ImageDownloader.h"

@interface TableTableViewController ()

@end

@implementation TableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * downloadImagesPath = [cachesPath stringByAppendingPathComponent:@"DownloadImages"];
    [[NSFileManager defaultManager] removeItemAtPath:downloadImagesPath error:nil];
    
    _movies = [[NSMutableArray alloc] init];
    
    [self getData];
    
//    self.tableView.rowHeight = 200;
    
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_movies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
//    if (!cell) {
//        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    }else {
//        // 当复用池获取的 cell 实例不为空时，删除其所有子视图，使其变“干净”。
//        while ([cell.contentView.subviews lastObject] != nil) {
//            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//        }
//    }
    
        MovieDataModel *model = [_movies objectAtIndex:indexPath.row];
        [cell updateCellWithData:model andTableView:tableView indexPath:indexPath];
    
//    cell.imageView.image = [UIImage imageNamed:@"test_image.jpg"];
//    cell.textLabel.text = @"2";
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
//    if ([_movies count] > indexPath.row) {
//        MovieDataModel *model = [_movies objectAtIndex:indexPath.row];
//        cell.textLabel.text = [model title];
        // download image
//        NSURL *imageURL = [NSURL URLWithString: model.imgUrl];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//        cell.imageView.image = [UIImage imageWithData:imageData];
        
//        [self.downloader startDownloadImage: model.imgUrl];
//        cell.imageView.image = [self.downloader  loadLocalImage: model.imgUrl];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
//    NSLog(@"cell addr: %p, row: %ld\n", cell, indexPath.row);
    return cell;
}

- (void)getData{
//    NSString *urlAsString = [NSString stringWithFormat:@"https://raw.githubusercontent.com/facebook/react-native/0.51-stable/docs/MoviesExample.json"];
//    NSString *urlAsString = [NSString stringWithFormat:@"http://baidu.com"];
    NSString *urlAsString = [NSString stringWithFormat:@"https://api.androidhive.info/json/movies.json"];

    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//        NSLog(@"RESPONSE: %@",response);
//        NSLog(@"DATA: %@",data);

        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

                if (jsonError) {
                    // Error Parsing JSON

                } else {
                    // Success Parsing JSON
                    // Log NSDictionary response:
//                    NSLog(@"%@",jsonResponse);
                    
//                    NSArray *mArr = jsonResponse[@"movies"];
                    
                    // three times jsonitem
                    NSMutableArray *threeJson = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 5; i++) {
                        [threeJson addObjectsFromArray:jsonResponse];
                    }
                    int i = 0; // row counter
                    for (NSDictionary *item in threeJson) {
                        NSString *title = item[@"title"];
//                        NSString *getImgUrl = item[@"posters"][@"thumbnail"];
                        NSString *imgUrl = item[@"image"];
//                        NSLog(@"indexOfObject: %d", [threeJson indexOfObject:item]);
                        MovieDataModel *model = [[MovieDataModel alloc] initWithTitle:title imgUrl:imgUrl row:i++];
                        
                        [self.movies addObject:model];

                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }  else {
                //Web server is returning an error
            }
        } else {
            // Fail
            NSLog(@"error : %@", error.description);
        }
    }] resume];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
