//
//  YLT_AddInputConfig.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/9.
//

#import "YLT_AddInputConfig.h"
#import <YLT_BaseLib/YLT_BaseLib.h>
#import <Masonry/Masonry.h>

@implementation YLT_AddInputModel

+ (YLT_AddInputModel *)modelImage:(UIImage *)image name:(NSString *)name {
    YLT_AddInputModel *model = [[YLT_AddInputModel alloc] init];
    model.image = image;
    model.name = name;
    return model;
}

@end

@implementation YLT_AddInputConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _height = 216;
        _bgColor = [@"fafafa" YLT_ColorFromHexString];
        _models = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
