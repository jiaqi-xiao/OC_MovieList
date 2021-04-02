//
//  TableViewController.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "MovieDataModel.h"
#import "ImageDownloader.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // clear cahce files
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
    MovieDataModel *model = [_movies objectAtIndex:indexPath.row];
    cell.model = model;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [cell updateCellWithModel:model tableView:tableView];
    return cell;
}

- (void)getData{
    // movie list json url
    NSString *urlAsString = [NSString stringWithFormat:@"https://api.androidhive.info/json/movies.json"];
    // download from url
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlAsString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

                if (jsonError) {
                    // Error Parsing JSON

                } else {
                    // Success Parsing JSON
                    
                    // three times jsonitem
                    NSMutableArray *threeJson = [[NSMutableArray alloc] init];
                    for (int i = 0; i < 3; i++) {
                        [threeJson addObjectsFromArray:jsonResponse];
                    }
                    int i = 0; // row counter
                    for (NSDictionary *item in threeJson) {
                        NSString *title = item[@"title"];
                        NSString *imgUrl = item[@"image"];
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
