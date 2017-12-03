//
//  YLT_AddInputView.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/9.
//

#import "YLT_AddInputView.h"
#import <Masonry/Masonry.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
@class YLT_AddInputViewDelegate;
@class YLT_AddInputCell;

#pragma mark - cell
@interface YLT_AddInputCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) YLT_AddInputModel *model;

@end

@interface YLT_AddInputView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
}
/**
 主视图
 */
@property (nonatomic, strong) UICollectionView *mainCollection;
/**
 事件回调
 */
@property (nonatomic, copy) void(^actionBlock)(NSInteger index);

@end

@implementation YLT_AddInputView

/**
 显示inputview
 
 @param config 配置
 @param actionBlock 事件回调
 @return 当前对象
 */
+ (YLT_AddInputView *)showInputViewConfig:(void(^)(YLT_AddInputConfig *config))config
                              actionBlock:(void(^)(NSInteger index))actionBlock {
    YLT_AddInputView *result = [[YLT_AddInputView alloc] init];
    result.configer = [[YLT_AddInputConfig alloc] init];
    !config?:config(result.configer);
    result.actionBlock = actionBlock;
    [result show];
    return result;
}

- (void)show {
    self.frame = CGRectMake(0, 0, YLT_SCREEN_WIDTH, self.configer.height);
    self.backgroundColor = self.configer.bgColor;
    if (!self.configer.flowLayout) {
        YLT_HorizontalFlowLayout *flowLayout = [[YLT_HorizontalFlowLayout alloc] init];
        self.configer.flowLayout = flowLayout;
        flowLayout.itemSize = CGSizeMake(YLT_SCREEN_WIDTH/4., self.configer.height/2.);
        flowLayout.minimumInteritemSpacing = 0.;
        flowLayout.minimumLineSpacing = 0.;
        flowLayout.headerReferenceSize = CGSizeMake(0., 0.);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    self.mainCollection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.configer.flowLayout];
    self.mainCollection.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainCollection];
    [self.mainCollection registerClass:[YLT_AddInputCell class] forCellWithReuseIdentifier:@"YLT_AddInputCell"];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    [self.mainCollection reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.configer.models.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLT_AddInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YLT_AddInputCell" forIndexPath:indexPath];
    cell.model = self.configer.models[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.actionBlock) {
        self.actionBlock(indexPath.row);
    }
}

@end


@implementation YLT_AddInputCell {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_thumbImageView];
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-16);
            make.width.height.equalTo(@(MIN(YLT_SCREEN_WIDTH/7., 60)));
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [@"515151" YLT_ColorFromHexString];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_thumbImageView.mas_bottom).offset(8);
        }];
    }
    return self;
}

- (void)setModel:(YLT_AddInputModel *)model {
    _model = model;
    _thumbImageView.image = model.image;
    _nameLabel.text = model.name;
}


@end

