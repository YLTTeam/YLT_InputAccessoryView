//
//  YLT_FaceboardCell.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import "YLT_FaceboardCell.h"
#import <Masonry/Masonry.h>
#import "YLT_FaceboardGroupModel.h"
#import <YYImage/YYImage.h>

@interface YLT_FaceboardCell () {
}
/**
 表情显示
 */
@property (nonatomic, strong) YYAnimatedImageView *thumbImageView;

@end

@implementation YLT_FaceboardCell

- (YYAnimatedImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[YYAnimatedImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    return _thumbImageView;
}

- (void)setFaceModel:(YLT_FaceModel *)faceModel {
    _faceModel = faceModel;
    self.thumbImageView.image = faceModel.face;
}

@end


@interface YLT_FaceboardToolBarCell() {
    
}

@property (nonatomic, strong) UIImageView *thumbImageView;

@end

@implementation YLT_FaceboardToolBarCell

- (void)setGroupModel:(YLT_FaceboardGroupModel *)groupModel {
    _groupModel = groupModel;
    self.thumbImageView.image = _groupModel.groupImage;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_thumbImageView];
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
    }
    return _thumbImageView;
}

@end
