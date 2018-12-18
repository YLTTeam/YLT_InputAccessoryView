//
//  YLT_AccessoryConfig.m
//  FMDB
//
//  Created by YLT_Alex on 2017/11/8.
//

#import "YLT_AccessoryConfig.h"
#import <YLT_BaseLib/YLT_BaseLib.h>
#import <Masonry/Masonry.h>

@interface YLT_AccessoryConfig()

@end

@implementation YLT_AccessoryConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyboardType = UIKeyboardTypeDefault;
        _returnKeyType = UIReturnKeyDefault;
        _backgroundColor = [@"FAFAFA" ylt_colorFromHexString];
        _borderColor = [@"CCCCCC" ylt_colorFromHexString];
        _lineColor = [@"CCCCCC" ylt_colorFromHexString];
        _leftBtns = @[];
        _rightBtns = @[];
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _inputTextView = [[SZTextView alloc] init];
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _height = 49;
        _maxHeight = 140;
        _placeholder = @"请输入...";
        _font = [UIFont systemFontOfSize:16];
        _textColor = [@"515151" ylt_colorFromHexString];
    }
    return self;
}


- (UIButton *)audioBtn {
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _audioBtn.tag = YLT_AUDIO_TAG;
        
        [_audioBtn setImage:YLT_AccessoryImage(@"mes_record") forState:UIControlStateNormal];
        [_audioBtn setImage:YLT_AccessoryImage(@"mes_key") forState:UIControlStateSelected];
    }
    return _audioBtn;
}

- (UIButton *)faceBtn {
    if (!_faceBtn) {
        _faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _faceBtn.tag = YLT_FACE_TAG;
        [_faceBtn setImage:YLT_AccessoryImage(@"mes_expression") forState:UIControlStateNormal];
        [_faceBtn setImage:YLT_AccessoryImage(@"mes_key") forState:UIControlStateSelected];
    }
    return _faceBtn;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _addBtn.tag = YLT_ADD_TAG;
        [_addBtn setImage:YLT_AccessoryImage(@"mes_otherfun") forState:UIControlStateNormal];
        [_addBtn setImage:YLT_AccessoryImage(@"mes_key") forState:UIControlStateSelected];
    }
    return _addBtn;
}

@end
