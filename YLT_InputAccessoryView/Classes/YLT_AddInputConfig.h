//
//  YLT_AddInputConfig.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/9.
//

#import <UIKit/UIKit.h>
#import <YLT_Kit/YLT_Kit.h>

@interface YLT_AddInputModel : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *name;

+ (YLT_AddInputModel *)modelImage:(UIImage *)image name:(NSString *)name;

@end

@interface YLT_AddInputConfig : UIView

/**
 布局样式 可以自定义 
 */
@property (nonatomic, strong) YLT_HorizontalFlowLayout *flowLayout;
/**
 显示的内容
 */
@property (nonatomic, strong) NSMutableArray<YLT_AddInputModel *> *models;
/**
 键盘高度 默认 216
 */
@property (nonatomic, assign) CGFloat height;
/**
 背景色
 */
@property (nonatomic, strong) UIColor *bgColor;

@end
