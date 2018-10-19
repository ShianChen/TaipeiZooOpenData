//
//  ViewController.m
//  TaipeiZooOpenData
//
//  Created by NT30338 on 2018/10/19.
//  Copyright © 2018年 NT30338. All rights reserved.
//

#import "ViewController.h"
#import "ZooDataModel.h"
#import "ZooDataCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *headerMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSMutableArray<ZooData *> *zooDatas;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isQuerying;
@property (strong, nonatomic) UIView *maskView;

@end

@implementation ViewController

#pragma mark - Getter

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [UIView new];
        UIView *window = [[[UIApplication sharedApplication] delegate] window];
        _maskView.frame = window.bounds;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _maskView;
}

#pragma mark - Setter

- (void)setIsQuerying:(BOOL)isQuerying {
    _isQuerying = isQuerying;
    self.activityIndicator.hidden = !isQuerying;
    if (_isQuerying) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.maskView];
            [self.view bringSubviewToFront:self.activityIndicator];
            [self.activityIndicator startAnimating];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.maskView removeFromSuperview];
            [self.view sendSubviewToBack:self.activityIndicator];
            [self.activityIndicator stopAnimating];
        });
    }
}

#pragma mark - life cycle

- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.title = @"";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zooDatas = [[ZooDataModel sharedInstance] getZooDatas];
    [self queryZooData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zooDatas.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ZooDataCell";
    ZooDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.data = self.zooDatas[indexPath.row];
    //[cell setupUI:self.zooDatas[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat distanceFromBottom = scrollView.contentSize.height/5*3/*全部高度的5分之3*/ - scrollView.contentOffset.y;
    if (distanceFromBottom < scrollView.frame.size.height) {
        [self queryZooData];
    }
}

#pragma mark - Action


#pragma mark - Private

- (void)queryZooData {
    if (self.zooDatas.count == 0) {
        //第一次出現loading
        self.isQuerying = YES;
    }
    
    void (^successHandler)(NSDictionary*) = ^(NSDictionary *response) {
        self.isQuerying = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    
    void (^failHandler)(NSDictionary*) = ^(NSDictionary *response) {
        self.isQuerying = NO;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"訊息"
                                                                                 message:@"資料有誤"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"確定"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }]];
        [self presentViewController:alertController animated:YES completion:^{}];
    };
    
    [[ZooDataModel sharedInstance] queryZooOpenDataWithSuccessHandler:successHandler
                                                          failHandler:failHandler];
}

@end
