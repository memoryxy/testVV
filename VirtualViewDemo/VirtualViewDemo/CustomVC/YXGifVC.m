//
//  YXGifVC.m
//  VirtualViewDemo
//
//  Created by wangjianfei on 2020/8/28.
//  Copyright © 2020 tmall. All rights reserved.
//

#import "YXGifVC.h"
#import <VirtualView/VVTemplateManager.h>
#import <VirtualView/VVViewFactory.h>
#import <VirtualView/VVViewContainer.h>

@interface YXGifVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) VVViewContainer *container;

@end

@implementation YXGifVC

- (instancetype)initWithFilename:(NSString *)filename
{
    if (self = [super init]) {
        self.title = filename;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
    if (![[VVTemplateManager sharedManager].loadedTypes containsObject:self.title]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.title ofType:@"out"];
        VVVersionModel *v = [[VVTemplateManager sharedManager] loadTemplateFile:path forType:nil];
        NSLog(@"wjflog v:%@", v.stringValue);
    }
    self.container = [VVViewContainer viewContainerWithTemplateType:self.title];
    [self.scrollView addSubview:self.container];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void) tap {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.frame = self.view.bounds;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGSize size = CGSizeMake(viewWidth, 1000);
    size = [self.container estimatedSize:size];
    self.scrollView.contentSize = size;
    self.container.frame = CGRectMake(0, 0, size.width, size.height);
    [self.container update:self.params];
}

- (NSDictionary *)params
{
    return @{@"picUrl":@"https://yanxuan-item.nosdn.127.net/1245cde4697d17c1bdc417ee054bf3a0.jpg",
             @"info":@{
                 @"name":@"wjf",
                 @"age":@18
             },
             @"dic":@{
                 @"name":@"zjh",
                 @"age":@99
             }
    };
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sm" ofType:@"json"];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//
//    return dic;
}


@end
