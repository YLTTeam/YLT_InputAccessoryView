//
//  YLTViewController.m
//  YLT_InputAccessoryView
//
//  Created by xphaijj0305@126.com on 11/08/2017.
//  Copyright (c) 2017 xphaijj0305@126.com. All rights reserved.
//

#import "YLTViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <YLT_RecordAudio.h>
#import <YLT_RecordManager.h>
#import <YLT_InputAccessoryView/YLT_InputAccessoryView.h>

@interface YLTViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSDictionary *files;
@property (nonatomic, strong) YLT_AccessoryView *input;

@end

@implementation YLTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    @weakify(self);
    self.input = [YLT_AccessoryView showInputAccessoryViewConfig:^(YLT_AccessoryConfig *config) {
        @strongify(self);
        config.leftBtns = @[config.audioBtn];
        config.rightBtns = @[config.faceBtn, config.addBtn];
        config.superView = self.view;
        config.mainScrollView = self.table;
    } textChangeBlock:^(NSString *text) {
        NSLog(@"%@", text);
    } actionBlock:^(UIButton *button) {
        NSLog(@"%@", button);
    } addActionBlock:^(NSInteger index) {
        NSLog(@"添加事件的回调");
    } recordBlock:^(YLT_RecordStatus status) {
        
    } fileBlock:^(NSDictionary *files) {
        NSLog(@"%@", files);
        self.files = files;
    } sendAction:^(NSString *value){
        NSLog(@"发送事件 %@", value);
    }];
    [self.view addSubview:self.input];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.input.mas_top);
    }];
//    input
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.input.configer.inputTextView resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.input.configer.inputTextView resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"CELL %zd", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.files[@"data"];
//    [[YLT_RecordManager manager] YLT_StartPlayRecordWithData:self.files[@"data"] completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
