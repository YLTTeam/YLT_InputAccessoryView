//
//  YLT_AccessoryConfig.h
//  FMDB
//
//  Created by YLT_Alex on 2017/11/8.
//

#import <Foundation/Foundation.h>
#import <SZTextView/SZTextView.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define YLT_AccessoryImage(name) [UIImage imageNamed:name inBundle:[NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"YLT_InputAccessoryView" withExtension:@"bundle"]] compatibleWithTraitCollection:nil]

#define YLT_AUDIO_TAG 999888777
#define YLT_FACE_TAG 999888778
#define YLT_ADD_TAG 999888779

@interface YLT_AccessoryConfig : NSObject
/**
 键盘类型
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/**
 return 按钮类型
 */
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

/**
 背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 圆角率
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 左边按钮
 */
@property (nonatomic, strong) NSArray<UIButton *> *leftBtns;

/**
 右边按钮
 */
@property (nonatomic, strong) NSArray<UIButton *> *rightBtns;

/**
 主视图
 */
@property (nonatomic, weak) UIScrollView *mainScrollView;

/**
 输入文本框部分的ContentView
 */
@property (nonatomic, strong, readonly) UIView *contentView;

/**
 文本框
 */
@property (nonatomic, strong, readonly) SZTextView *inputTextView;

/**
 占位
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 高度 默认 49
 */
@property (nonatomic, assign) CGFloat height;

/**
 最大高度
 */
@property (nonatomic, assign) CGFloat maxHeight;

/**
 上层视图
 */
@property (nonatomic, weak) UIView *superView;

/**
 语音按钮
 */
@property (nonatomic, strong) UIButton *audioBtn;
/**
 表情按钮
 */
@property (nonatomic, strong) UIButton *faceBtn;
/**
 添加按钮
 */
@property (nonatomic, strong) UIButton *addBtn;

@end

