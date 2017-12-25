//
//  YLT_FaceModel.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import <Foundation/Foundation.h>
#import <YYImage/YYImage.h>

@interface YLT_FaceModel : NSObject

@property (nonatomic, strong) UIImage *face;

@property (nonatomic, strong) NSString *faceName;

@property (nonatomic, strong) NSString *imgName;

/**
 是否是空的
 */
@property (nonatomic, assign) BOOL isEmpty;
/**
 是否是删除按钮
 */
@property (nonatomic, assign) BOOL isDelete;

+ (YLT_FaceModel *)faceModelWithImageName:(NSString *)imgName
                               bundlePath:(NSString *)bundlePath
                                 faceName:(NSString *)faceName;

/**
 删除按钮
 */
+ (YLT_FaceModel *)deleteFaceModelWithImageName:(NSString *)imgName
                                     bundlePath:(NSString *)bundlePath
                                       faceName:(NSString *)faceName;

/**
 空按钮 用来填充使用
 */
+ (YLT_FaceModel *)emptyFaceModel;

@end
