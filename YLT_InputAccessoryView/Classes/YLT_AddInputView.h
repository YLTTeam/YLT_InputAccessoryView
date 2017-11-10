//
//  YLT_AddInputView.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/9.
//

#import <UIKit/UIKit.h>
#import "YLT_AddInputConfig.h"

@interface YLT_AddInputView : UIView

/**
 配置
 */
@property (nonatomic, strong) YLT_AddInputConfig *configer;

/**
 显示inputview

 @param config 配置
 @param actionBlock 事件回调
 @return 当前对象
 */
+ (YLT_AddInputView *)showInputViewConfig:(void(^)(YLT_AddInputConfig *config))config
                              actionBlock:(void(^)(NSInteger index))actionBlock;

@end
