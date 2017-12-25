//
//  YLT_FaceboardCell.h
//  Pods
//
//  Created by YLT_Alex on 2017/11/20.
//

#import <UIKit/UIKit.h>
#import "YLT_FaceboardGroupModel.h"


@interface YLT_FaceboardCell : UICollectionViewCell

@property (nonatomic, strong) YLT_FaceModel *faceModel;

@end


@interface YLT_FaceboardToolBarCell : UICollectionViewCell

@property (nonatomic, strong) YLT_FaceboardGroupModel *groupModel;

@end
