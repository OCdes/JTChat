//
//  PrewarningVC.m
//  JingTeYuHui
//
//  Created by LJ on 2019/5/31.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PrewarningVC.h"
#import "ScrollBtnView.h"
#import "PrewarningTableView.h"
#import "PCHeader.h"

@interface PrewarningVC ()

@property (nonatomic, strong) ScrollBtnView *scrollBtnView;

@property (nonatomic, strong) UIButton *searchBtn, *screenBtn, *readedBtn;

@property (nonatomic, strong) PrewarningTableView *prewarningTableView;

@property (nonatomic, strong) PrewarningViewModel *viewModel;

@end

@implementation PrewarningVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPrewarning) name:@"NewPrewarningIsComing" object:nil];
    [self newPrewarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewPrewarningIsComing" object:nil];
}

- (void)newPrewarning {
    if (!self.readedBtn.hidden) {
        
        self.prewarningTableView.dataArr = PREWARNING_MANAGER.latestPrewarningList;
    }
    [self.scrollBtnView relodaData:@[PREWARNING_MANAGER.latestPrewarningList.count? NSStringFormate(@"未查阅(%li)",PREWARNING_MANAGER.latestPrewarningList.count):@"未查阅",PREWARNING_MANAGER.prewarningList.count? NSStringFormate(@"已查阅(%li)",PREWARNING_MANAGER.prewarningList.count) : @"已查阅"]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav];
    [self initView];
    [self bindViewModel];
}

- (void)setNav {
    self.title = @"预警消息";
    self.readedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.readedBtn.title = @"全部已阅";
    self.readedBtn.titleColor = HEX_FFF;
    self.readedBtn.titleLabel.font = SYS_FONT(14);
    [self.readedBtn addTarget:self action:@selector(allReaded)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.readedBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)allReaded {
    if ([self.readedBtn.title isEqualToString:@"全部已阅"]) {
        if (PREWARNING_MANAGER.latestPrewarningList.count) {
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.prewarningList];
            NSMutableArray *pMArr = [NSMutableArray arrayWithArray:PREWARNING_MANAGER.latestPrewarningList];
            [mArr addObjectsFromArray:[[pMArr reverseObjectEnumerator] allObjects]];
            PREWARNING_MANAGER.latestPrewarningList = [NSArray array];
            PREWARNING_MANAGER.prewarningList = [NSArray arrayWithArray:mArr];
            self.prewarningTableView.dataArr = PREWARNING_MANAGER.latestPrewarningList;
            [self.scrollBtnView relodaData:@[@"未查阅", PREWARNING_MANAGER.prewarningList.count? NSStringFormate(@"已查阅(%li)",PREWARNING_MANAGER.prewarningList.count) : @"已查阅"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PrewarningReaded" object:nil userInfo:nil];
        } else {
            SHOWHUD(@"已全部设为已阅");
            DISMISS_HUD(1.2);
        }
    } else {
        PREWARNING_MANAGER.prewarningList = [NSMutableArray array];
        [self.scrollBtnView relodaData:@[@"未查阅", PREWARNING_MANAGER.prewarningList.count? NSStringFormate(@"已查阅(%li)",PREWARNING_MANAGER.prewarningList.count) : @"已查阅"]];
        self.prewarningTableView.dataArr = PREWARNING_MANAGER.prewarningList;
    }
    
    
    
}

- (void)initView {
    self.scrollBtnView = [[ScrollBtnView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 45) titleArr:@[PREWARNING_MANAGER.latestPrewarningList.count? NSStringFormate(@"未查阅(%li)",PREWARNING_MANAGER.latestPrewarningList.count):@"未查阅",PREWARNING_MANAGER.prewarningList.count? NSStringFormate(@"已查阅(%li)",PREWARNING_MANAGER.prewarningList.count) : @"已查阅"]];
    [self.view addSubview:self.scrollBtnView];
    
//    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollBtnView.frame), Screen_Width/2., 44)];
//    self.searchBtn.image = @"search2";
//    self.searchBtn.title = @"  搜索";
//    self.searchBtn.titleColor = HEX_333;
//    [self.view addSubview:self.searchBtn];
//
//    self.screenBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchBtn.frame), self.searchBtn.frame.origin.y, self.searchBtn.width, self.searchBtn.height)];
//    self.screenBtn.image = @"screen2";
//    self.screenBtn.title = @"  筛选";
//    self.screenBtn.titleColor = HEX_333;
//    [self.view addSubview:self.screenBtn];
    
    self.prewarningTableView = [[PrewarningTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollBtnView.frame), Screen_Width, self.view.frame.size.height-CGRectGetMaxY(self.scrollBtnView.frame)) style:UITableViewStylePlain];
    self.prewarningTableView.dataArr = PREWARNING_MANAGER.latestPrewarningList;
    [self.view addSubview:self.prewarningTableView];
}

- (void)bindViewModel {
    @weakify(self);
    [self.scrollBtnView.tapSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSInteger i = [x integerValue];
        if (i == 0) {
            self.readedBtn.title = @"全部已阅";
            self.prewarningTableView.hasReaded = NO;
            self.prewarningTableView.dataArr = PREWARNING_MANAGER.latestPrewarningList;
        } else {
            self.readedBtn.title = @"清除历史";
            self.prewarningTableView.hasReaded = YES;
            self.prewarningTableView.dataArr = PREWARNING_MANAGER.prewarningList;
        }
    }];
    
    [self.prewarningTableView.readedSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.scrollBtnView relodaData:@[PREWARNING_MANAGER.latestPrewarningList.count? NSStringFormate(@"未查阅(%li)",PREWARNING_MANAGER.latestPrewarningList.count):@"未查阅", PREWARNING_MANAGER.prewarningList.count? NSStringFormate(@"已查阅(%li)",PREWARNING_MANAGER.prewarningList.count) : @"已查阅"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PrewarningReaded" object:nil userInfo:nil];
    }];
}



@end
