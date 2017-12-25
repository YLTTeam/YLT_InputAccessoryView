//
//  YLT_FaceboardGroupModel.m
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import "YLT_FaceboardGroupModel.h"

@implementation YLT_FaceboardGroupModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _faceboardType = YLT_FaceboardType_Emoji;
    }
    return self;
}

+ (YLT_FaceboardGroupModel *)groupModelWithImage:(UIImage *)image
                                      bundlePath:(NSString *)bundlePath
                                       plistName:(NSString *)plistName {
    YLT_FaceboardGroupModel *model = [[YLT_FaceboardGroupModel alloc] init];
    model.groupImage = image;
    model.bundlePath = bundlePath;
    model.plistName = plistName;
    return model;
}

+ (YLT_FaceboardGroupModel *)normalGroupModel {
    return [YLT_FaceboardGroupModel groupModelWithImage:YLT_FaceboardImage(@"000") bundlePath:[YLT_FaceboardBundle bundlePath] plistName:@"expression.plist"];
}

- (NSArray<YLT_FaceModel *> *)faces {
    if (_faces == nil) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSDictionary *faceData = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", self.bundlePath, self.plistName]];
        NSArray *faceImgNames = [faceData.allValues sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        [faceImgNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *faceName = @"";
            for (NSString *key in faceData.allKeys) {
                if ([[faceData objectForKey:key] isEqualToString:obj]) {
                    faceName = key;
                    break;
                }
            }
            if (self.faceboardType == YLT_FaceboardType_Emoji && ((idx)%(self.countPreRow*self.row-1)==0 && (idx != 0))) {
                [result addObject:[YLT_FaceModel deleteFaceModelWithImageName:@"del" bundlePath:self.bundlePath faceName:@"[删除]"]];
            }
            [result addObject:[YLT_FaceModel faceModelWithImageName:obj bundlePath:self.bundlePath faceName:faceName]];
        }];
        NSUInteger count = ceil(((CGFloat)result.count)/((CGFloat)self.countPreRow*self.row))*self.countPreRow*self.row;
        for (NSUInteger i = result.count; i < count; i++) {
            if (i == count-1) {
                [result addObject:[YLT_FaceModel deleteFaceModelWithImageName:@"del" bundlePath:self.bundlePath faceName:@"[删除]"]];
            } else {
                [result addObject:[YLT_FaceModel emptyFaceModel]];
            }
        }
        
        _faces = result;
    }
    return _faces;
}

- (NSUInteger)pageCount {
    CGFloat numOfPage = ((CGFloat)self.countPreRow*self.row);
    return ceil(((CGFloat)self.faces.count)/numOfPage);
}

- (NSUInteger)countPreRow {
    if (_countPreRow == 0) {
        _countPreRow = iPhone_4_7?7:((iPhone_5_5||iPhone_x)?8:6);
    }
    return _countPreRow;
}

- (NSUInteger)row {
    if (_row == 0) {
        _row = 3;
    }
    return _row;
}

- (NSString *)plistName {
    if (![_plistName hasSuffix:@".plist"]) {
        _plistName = [NSString stringWithFormat:@"%@.plist", _plistName];
    }
    return _plistName;
}

@end
