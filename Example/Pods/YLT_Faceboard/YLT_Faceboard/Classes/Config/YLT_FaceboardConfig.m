//
//  YLT_FaceboardConfig.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import "YLT_FaceboardConfig.h"
#import <YLT_BaseLib/YLT_BaseLib.h>

@implementation YLT_FaceboardConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = 216;
        _toolBarHidden = NO;
        _leftBtns = [[NSMutableArray alloc] init];
        _rightBtns = [[NSMutableArray alloc] init];
        _faceboardBtns = [[NSMutableArray alloc] init];
        _keyboards = [[NSMutableArray alloc] init];
        _bgColor = [@"fafafa" ylt_colorFromHexString];
    }
    return self;
}

- (YLT_FaceboardGroupModel *)currentKeyboardGroupModel {
    return self.keyboards[self.currentKeyboardIndex];
}

@end
