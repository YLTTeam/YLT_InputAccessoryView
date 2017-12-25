//
//  YLT_FaceboardGroupModel.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import <YLT_BaseLib/YLT_BaseLib.h>
#import "YLT_FaceModel.h"
#import <YLT_Kit/YLT_Kit.h>

typedef NS_ENUM(NSInteger, YLT_FaceboardType) {
    YLT_FaceboardType_Emoji,//传统表情，添加进输入框，然后发送
    YLT_FaceboardType_Other,//自定义表情，点击即发送
};

#define YLT_FaceboardBundle [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"YLT_Faceboard" withExtension:@"bundle"]]
#define YLT_FaceboardImage(name) [UIImage imageNamed:name inBundle:YLT_FaceboardBundle compatibleWithTraitCollection:nil]

@interface YLT_FaceboardGroupModel : YLT_BaseModel

/**
 键盘类型
 */
@property (nonatomic, assign) YLT_FaceboardType faceboardType;
/**
 分组的普通图片
 */
@property (nonatomic, strong) UIImage *groupImage;
/**
 每行多少个表情
 */
@property (nonatomic, assign) NSUInteger countPreRow;
/**
 多少行
 */
@property (nonatomic, assign) NSUInteger row;
/**
 bundle 路径
 */
@property (nonatomic, strong) NSString *bundlePath;
/**
 页数
 */
@property (nonatomic, assign, readonly) NSUInteger pageCount;
/**
 plist 文件的名称
 */
@property (nonatomic, strong) NSString *plistName;
/**
 当前分组的所有表情
 */
@property (nonatomic, strong) NSArray<YLT_FaceModel *> *faces;

+ (YLT_FaceboardGroupModel *)groupModelWithImage:(UIImage *)image
                                      bundlePath:(NSString *)bundlePath
                                       plistName:(NSString *)plistName;

+ (YLT_FaceboardGroupModel *)normalGroupModel;

@end
