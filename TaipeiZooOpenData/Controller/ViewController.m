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

static float bigNavigationBarMinH = 50.0f;
static float bigNavigationBarMaxH = 200.0f;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *headerMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSMutableArray<ZooData *> *zooDatas;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isShowLoading;
@property (assign, nonatomic) BOOL isQuerying;
@property (strong, nonatomic) UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *bigNavigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigNavigationBarH;

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

- (void)setIsShowLoading:(BOOL)isQuerying {
    _isShowLoading = isQuerying;
    self.activityIndicator.hidden = !isQuerying;
    if (_isShowLoading) {
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.isQuerying = NO;
    self.isShowLoading = NO;
    
//    // tableView 偏移20/64适配
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
//    }
//    else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
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
    ZooData *data = self.zooDatas[indexPath.row];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ZooDataCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithWhite:252.0f / 255.0f alpha:1.0f];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupUI:data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return UITableViewAutomaticDimension;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat toQueryH = scrollView.contentSize.height/5*3/*全部高度的5分之3*/ - scrollView.contentOffset.y;
    if (toQueryH <= scrollView.frame.size.height) {
        [self queryZooData];
    }
    
    CGFloat newBigNavigationBarH = MAX(bigNavigationBarMinH,
                                       self.bigNavigationBarH.constant - scrollView.contentOffset.y);
    
    if (newBigNavigationBarH > bigNavigationBarMaxH) {
        newBigNavigationBarH = bigNavigationBarMaxH;
    }
    
    self.bigNavigationBarH.constant = newBigNavigationBarH;
    
    if (newBigNavigationBarH > bigNavigationBarMinH) {
        //比min大先別動
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    
    
    float newAlpha = 1.0f;
    if (newBigNavigationBarH == bigNavigationBarMaxH) {
        newAlpha = 1.0f;
    }
    else if (newBigNavigationBarH <= bigNavigationBarMinH) {
        newAlpha = 0.0f;
    }
    else {
        newAlpha = scrollView.contentOffset.y / bigNavigationBarMaxH;
        if (newAlpha < 0.5f) {
            newAlpha = 0.5f;
        }
    }
    
    self.bigNavigationBar.alpha = newAlpha;
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
//}

#pragma mark - Action


#pragma mark - Private

- (void)queryZooData {
    if (self.isQuerying) {
        return;
    }
    
    self.isQuerying = YES;
    
    if (self.zooDatas.count == 0) {
        //第一次出現loading
        self.isShowLoading = YES;
    }
    
    void (^successHandler)(NSDictionary*) = ^(NSDictionary *response) {
        self.isShowLoading = NO;
        self.isQuerying = NO;
        if (response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    };
    
    void (^failHandler)(NSDictionary*) = ^(NSDictionary *response) {
        self.isShowLoading = NO;
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
