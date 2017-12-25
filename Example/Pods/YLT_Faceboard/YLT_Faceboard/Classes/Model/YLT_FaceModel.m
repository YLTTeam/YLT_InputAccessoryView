//
//  YLT_FaceModel.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import "YLT_FaceModel.h"

typedef NS_ENUM(NSUInteger, FaceModelType) {
    FaceModelType_Delete,
    FaceModelType_Normal,
    FaceModelType_Empty,
};

@interface YLT_FaceModel()

@property (nonatomic, assign) FaceModelType faceModelType;

@end

@implementation YLT_FaceModel


+ (YLT_FaceModel *)faceModelWithImageName:(NSString *)imgName
                               bundlePath:(NSString *)bundlePath
                                 faceName:(NSString *)faceName {
    YLT_FaceModel *result = [[YLT_FaceModel alloc] init];
    if (imgName) {
        result.imgName = imgName;
        result.face = [YYImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, imgName]];
        if (!result.face) {
            result.face = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, imgName]];
        }
        result.faceName = faceName;
    }
    result.faceModelType = FaceModelType_Normal;
    
    return result;
}

/**
 删除按钮
 */
+ (YLT_FaceModel *)deleteFaceModelWithImageName:(NSString *)imgName
                                     bundlePath:(NSString *)bundlePath
                                       faceName:(NSString *)faceName {
    YLT_FaceModel *result = [YLT_FaceModel faceModelWithImageName:imgName bundlePath:bundlePath faceName:faceName];
    result.faceModelType = FaceModelType_Delete;
    return result;
}

/**
 空按钮 用来填充使用
 */
+ (YLT_FaceModel *)emptyFaceModel {
    YLT_FaceModel *result = [YLT_FaceModel faceModelWithImageName:nil bundlePath:nil faceName:nil];
    result.faceModelType = FaceModelType_Empty;
    return result;
}

- (BOOL)isDelete {
    return (self.faceModelType == FaceModelType_Delete);
}

- (BOOL)isEmpty {
    return (self.faceModelType == FaceModelType_Empty);
}

@end
