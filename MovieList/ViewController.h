//
//  ViewController.h
//  MovieList
//
//  Created by xiaojiaqi03 on 2021/3/26.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, strong) UILabel *testLabel1;

@property(nonatomic, strong) NSArray *strArr;
@property(nonatomic, copy) NSArray *cpArr;

@property(nonatomic, strong) NSMutableArray *arr;

@property(nonatomic, strong) NSDictionary *res;

-(void)getJSON;

//-(void)hello;

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender;
//@property(null_resettable, nonatomic,strong) UIView *view;

@end

