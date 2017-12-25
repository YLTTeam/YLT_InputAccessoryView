//
//  YLT_FaceboardConfig.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import <Foundation/Foundation.h>
#import "YLT_FaceboardGroupModel.h"

@interface YLT_FaceboardConfig : NSObject

/**
 所有键盘的配置
 */
@property (nonatomic, strong) NSMutableArray<YLT_FaceboardGroupModel *> *keyboards;
/**
 当前键盘的索引
 */
@property (nonatomic, assign) NSInteger currentKeyboardIndex;
/**
 当前键盘
 */
@property (nonatomic, strong, readonly) YLT_FaceboardGroupModel *currentKeyboardGroupModel;
/**
 父视图
 */
@property (nonatomic, weak) UIView *superView;
/**
 输入视图
 */
@property (nonatomic, weak) UIView *inputView;
/**
 键盘高度 
 */
@property (nonatomic, assign) CGFloat height;

/**
 键盘背景色
 */
@property (nonatomic, strong) UIColor *bgColor;


#pragma mark - 回调配置

/**
 tool bar 上事件的回调 包含左右侧按钮 以及 表情的回调
 */
@property (nonatomic, copy) void(^toolBarAction)(NSInteger index);
/**
 表情的回调
 */
@property (nonatomic, copy) void(^faceAction)(YLT_FaceboardType faceboardType, YLT_FaceModel *faceModel);

#pragma mark - ToolBar 的配置

/**
 toolBar的显示隐藏
 */
@property (nonatomic, assign) BOOL toolBarHidden;

/**
 左侧按钮
 */
@property (nonatomic, strong) NSMutableArray *leftBtns;

/**
 右侧按钮
 */
@property (nonatomic, strong) NSMutableArray *rightBtns;

/**
 faceboard btn
 */
@property (nonatomic, strong) NSMutableArray *faceboardBtns;

@end

