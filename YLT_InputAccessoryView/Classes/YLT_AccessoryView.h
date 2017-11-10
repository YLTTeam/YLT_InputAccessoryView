//
//  YLT_AccessoryView.h
//  Pods-YLT_InputAccessoryView_Example
//
//  Created by YLT_Alex on 2017/11/8.
//

#import <UIKit/UIKit.h>
#import "YLT_AccessoryConfig.h"

typedef NS_ENUM(NSUInteger, FileType) {
    AudioType,//音频
    PhotoType,//图片
    OtherType,//其他
};

@interface YLT_AccessoryView : UIView

/**
 配置
 */
@property (nonatomic, strong) YLT_AccessoryConfig *configer;
/**
 生成input accessory view

 @param config 配置
 @param textChangeBlock 文本修改的回调
 @param actionBlock 事件回调
 @param fileBlock 文件回调
 */
+ (YLT_AccessoryView *)showInputAccessoryViewConfig:(void(^)(YLT_AccessoryConfig * config))config
                                    textChangeBlock:(void(^)(NSString *text))textChangeBlock
                                        actionBlock:(void(^)(UIButton *button))actionBlock
                                          fileBlock:(void(^)(NSDictionary *file))fileBlock;

@end
