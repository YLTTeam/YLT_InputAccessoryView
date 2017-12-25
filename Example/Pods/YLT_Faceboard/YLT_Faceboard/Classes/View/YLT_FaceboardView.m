//
//  YLT_FaceboardView.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import "YLT_FaceboardView.h"
#import <Masonry/Masonry.h>
#import "YLT_FaceboardCell.h"
#import <ReactiveObjc/ReactiveObjc.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import <YLT_Kit/YLT_kit.h>

#define LEFT_SPACING 4
#define RIGHT_SPACING 4

@interface YLT_FaceboardView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
}

/**
 内容键盘
 */
@property (nonatomic, strong) UIView *contentView;

/**
 工具栏
 */
@property (nonatomic, strong) UIView *toolBar;
/**
 布局样式
 */
@property (nonatomic, strong) YLT_HorizontalFlowLayout *flowLayout;
/**
 表情键盘
 */
@property (nonatomic, strong) UICollectionView *faceCollectionView;
/**
 ToolBar
 */
@property (nonatomic, strong) UICollectionView *toolBarCollectionView;
/**
 底部索引
 */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YLT_FaceboardView

+ (YLT_FaceboardView *)showFaceboardConfig:(void(^)(YLT_FaceboardConfig *config))config {
    YLT_FaceboardView *result = [[YLT_FaceboardView alloc] init];
    result.configer = [[YLT_FaceboardConfig alloc] init];
    !config?:config(result.configer);
    
    [result show];
    return result;
}

- (void)show {
    @weakify(self);
    if (self.configer.superView) {
        [self.configer.superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.configer.superView);
        }];
    } else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.configer.height));
        }];
    }
    if (self.configer.inputView && !([self.configer.inputView isKindOfClass:[UITextView class]] || [self.configer.inputView isKindOfClass:[UITextField class]])) {
        YLT_LogError(@"配置异常");
        return;
    }
    
    self.backgroundColor = self.configer.bgColor;
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    
    if (self.configer.toolBarHidden) {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        [self toolBar];
    }
    self.pageControl.numberOfPages = self.configer.currentKeyboardGroupModel.pageCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.faceCollectionView) {
        return self.configer.keyboards.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.faceCollectionView) {
        return self.configer.keyboards[section].faces.count;
    }
    return self.configer.keyboards.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.faceCollectionView) {
        CGSize result = CGSizeMake(collectionView.bounds.size.width/self.configer.keyboards[indexPath.section].countPreRow, collectionView.bounds.size.height/self.configer.keyboards[indexPath.section].row);
        if (indexPath.row > 20) {
            result.width *= 2;
            result.height *= 2;
        }
        return result;
    }
    return CGSizeMake(44., 44.);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.faceCollectionView) {
        YLT_FaceboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YLT_FaceboardCell" forIndexPath:indexPath];
        YLT_FaceModel *model = (YLT_FaceModel *)[self.configer.keyboards[indexPath.section].faces objectAtIndex:indexPath.row];
        cell.faceModel = model;
        return cell;
    }
    YLT_FaceboardToolBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YLT_FaceboardToolBarCell" forIndexPath:indexPath];
    cell.groupModel = self.configer.keyboards[indexPath.row];
    cell.backgroundColor = (self.configer.currentKeyboardIndex==indexPath.row)?self.configer.bgColor:[UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.faceCollectionView) {
        if (self.configer.faceAction) {
            YLT_FaceModel *model = (YLT_FaceModel *)[self.configer.keyboards[indexPath.section].faces objectAtIndex:indexPath.row];
            if (!model.isEmpty) {
                UITextField *textField = ((UITextField *) self.configer.inputView);
                NSInteger location = textField.selectedRange.location;
                if (model.isDelete) {//删除事件
                    if (location > 0) {
                        //匹配光标位置往前的字符串
                        __block NSString *front = [textField.text substringToIndex:location];
                        NSString *back = [textField.text substringFromIndex:location];
                        __block BOOL isEmoji = NO;
                        if ([front hasSuffix:@"]"]) {
                            [self.configer.keyboards enumerateObjectsUsingBlock:^(YLT_FaceboardGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [obj.faces enumerateObjectsUsingBlock:^(YLT_FaceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stopFace) {
                                    if (obj.faceName && [front hasSuffix:obj.faceName]) {
                                        isEmoji = YES;
                                        front = [front substringToIndex:front.length-obj.faceName.length];
                                        *stop = YES;
                                        *stopFace = YES;
                                    }
                                }];
                            }];
                        }
                        front = isEmoji?front:[front substringToIndex:front.length-1];
                        textField.text = [NSString stringWithFormat:@"%@%@", front, back];
                        textField.selectedRange = NSMakeRange(front.length, 0);
                    }
                } else {//添加表情事件
                    if (self.configer.keyboards[indexPath.section].faceboardType==YLT_FaceboardType_Emoji) {
                        textField.text = [NSString stringWithFormat:@"%@%@%@", [textField.text substringToIndex:location], model.faceName, [textField.text substringFromIndex:location]];
                        textField.selectedRange = NSMakeRange(location+model.faceName.length, 0);
                    }
                }
                self.configer.faceAction(self.configer.keyboards[indexPath.section].faceboardType, model);
            }
        }
        return;
    }
    [self.faceCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self selectToolBarIndex:indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.faceCollectionView) {
        NSInteger section = self.faceCollectionView.indexPathsForVisibleItems.firstObject.section;
        [self selectToolBarIndex:section];
        NSInteger totalPages = 0;
        for (int i = 0; i < section; i++) {
            totalPages += self.configer.keyboards[i].pageCount;
        }
        self.pageControl.currentPage = (scrollView.contentOffset.x/scrollView.frame.size.width)-totalPages;
    }
}

- (void)selectToolBarIndex:(NSInteger)index {
    if (self.configer.currentKeyboardIndex == index) {
        return;
    }
    YLT_FaceboardToolBarCell *cell = (YLT_FaceboardToolBarCell *)[self.toolBarCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.configer.currentKeyboardIndex inSection:0]];
    cell.backgroundColor = [UIColor whiteColor];
    cell = (YLT_FaceboardToolBarCell *)[self.toolBarCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.backgroundColor = self.configer.bgColor;
    self.configer.currentKeyboardIndex = index;
    YLT_FaceboardGroupModel *groupModel = self.configer.keyboards[index];
    self.pageControl.numberOfPages = groupModel.pageCount;
    self.pageControl.currentPage = 0;
    if (self.configer.toolBarAction) {
        self.configer.toolBarAction(index+self.configer.leftBtns.count+self.configer.rightBtns.count);
    }
}

#pragma mark - set get

- (UIView *)toolBar {
    if (!_toolBar) {
        @weakify(self);
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@44);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(_toolBar.mas_top);
        }];
        for (NSUInteger i = 0; i < self.configer.leftBtns.count; i++) {
            UIButton *btn = self.configer.leftBtns[i];
            btn.tag = (btn.tag==0)?i:btn.tag;
            [_toolBar addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(i*44+LEFT_SPACING));
                make.bottom.top.equalTo(_toolBar);
                make.width.equalTo(@44);
            }];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                @strongify(self);
                if (self.configer.toolBarAction) {
                    self.configer.toolBarAction(x.tag);
                }
            }];
        }
        for (NSUInteger i = 0; i < self.configer.rightBtns.count; i++) {
            NSInteger index = self.configer.rightBtns.count-i-1;
            UIButton *btn = self.configer.rightBtns[index];
            btn.tag = (btn.tag==0)?(index+self.configer.leftBtns.count):btn.tag;
            [_toolBar addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@(-(i*44.+RIGHT_SPACING)));
                make.bottom.top.equalTo(_toolBar);
                make.width.equalTo(@44);
            }];
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                @strongify(self);
                if (self.configer.toolBarAction) {
                    self.configer.toolBarAction(x.tag);
                }
            }];
        }
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(44, 44);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.toolBarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.toolBarCollectionView.showsHorizontalScrollIndicator = NO;
        self.toolBarCollectionView.backgroundColor = [UIColor clearColor];
        self.toolBarCollectionView.delegate = self;
        self.toolBarCollectionView.dataSource = self;
        [self.toolBarCollectionView registerClass:[YLT_FaceboardToolBarCell class] forCellWithReuseIdentifier:@"YLT_FaceboardToolBarCell"];
        [_toolBar addSubview:self.toolBarCollectionView];
        [self.toolBarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(LEFT_SPACING+self.configer.leftBtns.count*44.));
            make.right.equalTo(@(-(RIGHT_SPACING+self.configer.rightBtns.count*44.)));
            make.top.bottom.equalTo(_toolBar);
        }];
    }
    return _toolBar;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        @weakify(self);
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [@"dddddd" YLT_ColorFromHexString];
        _pageControl.currentPageIndicatorTintColor = [@"999999" YLT_ColorFromHexString];
        [_contentView addSubview:self.pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@20);
        }];
        [[_pageControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIPageControl * _Nullable x) {
            @strongify(self);
            [self.faceCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:x.currentPage inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
        }];
        _pageControl.numberOfPages = 0;
    }
    return _pageControl;
}

- (UICollectionView *)faceCollectionView {
    if (!_faceCollectionView) {
        self.flowLayout = [[YLT_HorizontalFlowLayout alloc] init];
        self.flowLayout.minimumLineSpacing = 0;
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.headerReferenceSize = CGSizeZero;
        self.flowLayout.footerReferenceSize = CGSizeZero;
        [self pageControl];
        [self.contentView layoutIfNeeded];
        self.flowLayout.itemSize = CGSizeMake(self.contentView.bounds.size.width/self.configer.currentKeyboardGroupModel.countPreRow, (self.contentView.bounds.size.height-self.pageControl.bounds.size.height)/self.configer.currentKeyboardGroupModel.row);
        NSMutableArray *configs = [[NSMutableArray alloc] init];
        [self.configer.keyboards enumerateObjectsUsingBlock:^(YLT_FaceboardGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [configs addObject:[YLT_HorizontalFlowLayoutModel modelWithPreRow:obj.countPreRow row:obj.row]];
        }];
        self.flowLayout.sectionConfigs = configs;
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _faceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _faceCollectionView.showsHorizontalScrollIndicator = NO;
        _faceCollectionView.delegate = self;
        _faceCollectionView.dataSource = self;
        _faceCollectionView.backgroundColor = [UIColor clearColor];
        _faceCollectionView.pagingEnabled = YES;
        [_faceCollectionView registerClass:[YLT_FaceboardCell class] forCellWithReuseIdentifier:@"YLT_FaceboardCell"];
        [self.contentView addSubview:_faceCollectionView];
        [_faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.pageControl.mas_top);
        }];
    }
    
    return _faceCollectionView;
}


@end
