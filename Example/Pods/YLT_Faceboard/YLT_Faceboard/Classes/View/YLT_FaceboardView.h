//
//  YLT_FaceboardView.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import <UIKit/UIKit.h>
#import "YLT_FaceboardConfig.h"

@interface YLT_FaceboardView : UIView

/**
 键盘配置文件
 */
@property (nonatomic, strong) YLT_FaceboardConfig *configer;

+ (YLT_FaceboardView *)showFaceboardConfig:(void(^)(YLT_FaceboardConfig *config))config;

@end
