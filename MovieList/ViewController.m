//
//  ViewController.m
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

//@synthesize testLabel1 = _testLabel1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.testLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 280, 30)];
    self.testLabel1.text = @"Hello";

    [self.view addSubview:self.testLabel1];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(20, 400, 240, 30);
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"Change"
            forState:UIControlStateNormal];
    [button addTarget:self
            action:@selector(getJSON)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.arr = [@[@"item1"] mutableCopy];
    self.strArr = self.arr;
    self.cpArr = self.arr;
    
    NSLog(@"strong Array: %@", _strArr);
    NSLog(@"copy Array: %@", _cpArr);
}

- (void)getJSON{
    NSString *urlAsString = [NSString stringWithFormat:@"https://raw.githubusercontent.com/facebook/react-native/0.51-stable/docs/MoviesExample.json"];

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
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

                if (jsonError) {
                    // Error Parsing JSON

                } else {
                    // Success Parsing JSON
                    // Log NSDictionary response:
//                    NSLog(@"%@",jsonResponse);
                    NSArray *mArr = jsonResponse[@"movies"];
                    for (NSDictionary *item in mArr) {
                        NSString *getTitle = item[@"title"];
                        NSString *getImgUrl = item[@"posters"][@"thumbnail"];
                        NSLog(@"Ttile: %@, img: %@", getTitle, getImgUrl);
                    }
//                    NSLog(@"moive list: %@\r\n", titleArr);
                    
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

//- (void)changeText{
////    [_arr addObject:@"item2"];
////
////    NSLog(@"strong Array: %@", _strArr);
////    NSLog(@"copy Array: %@", _cpArr);
//    getJSON();
//}



@end
