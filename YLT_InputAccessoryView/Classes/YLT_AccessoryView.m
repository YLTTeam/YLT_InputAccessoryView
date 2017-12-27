//
//  YLT_AccessoryView.m
//  Pods-YLT_InputAccessoryView_Example
//
//  Created by YLT_Alex on 2017/11/8.
//

#import "YLT_AccessoryView.h"
#import <Masonry/Masonry.h>
#import <YLT_BaseLib/YLT_BaseLib.h>
#import <YLT_RecordAudio/YLT_RecordAudio.h>
#import "YLT_AddInputView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <NSObject+YLT_BaseObject.h>
#import <RMUniversalAlert/RMUniversalAlert.h>
#import <YLT_Faceboard/YLT_Faceboard.h>


#define LEFT_SPACING 4
#define RIGHT_SPACING 4

@interface YLT_AccessoryView()<UITextViewDelegate, YLT_RecordManagerDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate> {
}

/**
 录音按钮
 */
@property (nonatomic, strong) UIButton *recordBtn;
//高度 输入框的高度
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UIView *faceInputView;

@property (nonatomic, strong) YLT_AddInputView *addInputView;

@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);

@property (nonatomic, copy) void(^actionBlock)(UIButton *button);

@property (nonatomic, copy) void(^addActionBlock)(NSInteger index);

@property (nonatomic, copy) void(^fileBlock)(NSDictionary *files);

@property (nonatomic, copy) void(^sendBlock)(NSString *value);

@property (nonatomic, copy) void(^recordBlock)(YLT_RecordStatus status);

@end

@implementation YLT_AccessoryView

/**
 生成input accessory view
 
 @param config 配置
 @param textChangeBlock 文本修改的回调
 @param actionBlock 事件回调
 @param addActionBlock 事件回调
 @param recordBlock 录音回调
 @param fileBlock 文件回调
 @param sendBlock 发送按钮的回调
 */
+ (YLT_AccessoryView *)showInputAccessoryViewConfig:(void(^)(YLT_AccessoryConfig * config))config
                                    textChangeBlock:(void(^)(NSString *text))textChangeBlock
                                        actionBlock:(void(^)(UIButton *button))actionBlock
                                     addActionBlock:(void(^)(NSInteger index))addActionBlock
                                        recordBlock:(void(^)(YLT_RecordStatus status))recordBlock
                                          fileBlock:(void(^)(NSDictionary *file))fileBlock
                                         sendAction:(void(^)(NSString *value))sendBlock {
    YLT_AccessoryView *result = [[[self class] alloc] init];
    result.configer = [[YLT_AccessoryConfig alloc] init];
    !config?:config(result.configer);
    result.textChangeBlock = textChangeBlock;
    result.actionBlock = actionBlock;
    result.addActionBlock = addActionBlock;
    result.recordBlock = recordBlock;
    result.fileBlock = fileBlock;
    result.sendBlock = sendBlock;
    [result show];
    return result;
}

- (void)show {
    if (self.configer.superView) {
        [self.configer.superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.configer.superView);
        }];
    }
    self.configer.maxHeight = (self.configer.maxHeight>self.configer.height)?self.configer.maxHeight:self.configer.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.configer.height));
    }];
    self.height = self.configer.height;
    
    self.backgroundColor = self.configer.backgroundColor;
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.backgroundColor = self.configer.lineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    @weakify(self);
    for (NSInteger i = 0; i < self.configer.leftBtns.count; i++) {
        UIButton *btn = self.configer.leftBtns[i];
        btn.tag = (btn.tag==0)?i:btn.tag;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            [self btnAction:x];
        }];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(i*44+LEFT_SPACING));
            make.bottom.equalTo(self);
            make.width.equalTo(@44);
            make.height.equalTo(@(self.configer.height));
        }];
    }
    for (NSInteger i = 0; i < self.configer.rightBtns.count; i++) {
        NSInteger index = self.configer.rightBtns.count-i-1;
        UIButton *btn = self.configer.rightBtns[index];
        btn.tag = (btn.tag==0)?(index+self.configer.leftBtns.count):btn.tag;
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            [self btnAction:x];
        }];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-(i*44.+RIGHT_SPACING)));
            make.bottom.equalTo(self);
            make.width.equalTo(@44);
            make.height.equalTo(@(self.configer.height));
        }];
    }
    [self addSubview:self.configer.contentView];
    [self.configer.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.configer.leftBtns.count*44.+LEFT_SPACING));
        make.right.equalTo(@(-(self.configer.rightBtns.count*44.+RIGHT_SPACING)));
        make.top.equalTo(@4);
        make.bottom.equalTo(@(-4));
    }];
    [self.configer.contentView addSubview:self.configer.inputTextView];
    self.configer.inputTextView.layer.borderColor = self.configer.borderColor.CGColor;
    self.configer.inputTextView.layer.borderWidth = 0.5;
    self.configer.inputTextView.layer.cornerRadius = 3;
    self.configer.inputTextView.placeholder = self.configer.placeholder;
    self.configer.inputTextView.textColor = self.configer.textColor;
    self.configer.inputTextView.font = self.configer.font;
    [self.configer.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.configer.contentView).offset(8);
        make.right.equalTo(self.configer.contentView).offset(-8);
        make.top.equalTo(self.configer.contentView).offset(4);
        make.bottom.equalTo(self.configer.contentView).offset(-4);
    }];
    [[self.configer.inputTextView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (self.textChangeBlock) {
            self.textChangeBlock(x);
        }
    }];
    self.configer.inputTextView.delegate = self;
    [YLT_RecordManager manager].delegate = self;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary *userInfo = [x userInfo];
        [self keyboardUserInfo:userInfo];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidChangeFrameNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary *userInfo = [x userInfo];
        [self keyboardUserInfo:userInfo];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (self.superview) {
            [self.superview bringSubviewToFront:self];
        }
        
        NSDictionary *userInfo = [x userInfo];
        [self keyboardUserInfo:userInfo];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary *userInfo = [x userInfo];
        [self keyboardUserInfo:userInfo];
    }];
}

- (void)btnAction:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
    switch (sender.tag) {
        case YLT_AUDIO_TAG: {
            self.configer.faceBtn.selected = NO;
            self.configer.addBtn.selected = NO;
            sender.selected = !sender.selected;
            if (sender.selected) {
                @weakify(sender);
                @weakify(self);
                [[YLT_AuthorizationHelper shareInstance] YLT_AuthorizationType:YLT_Microphone success:^{
                    @strongify(self);
                    self.configer.inputTextView.inputView = nil;
                    [self.configer.inputTextView resignFirstResponder];
                    self.height = self.configer.height;
                    [self mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(self.height));
                    }];
                    [self.configer.contentView addSubview:self.recordBtn];
                    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@8);
                        make.right.equalTo(@(-8));
                        make.top.equalTo(@4);
                        make.bottom.equalTo(@(-4));
                    }];
                } failed:^{
                    @strongify(sender);
                    sender.selected = NO;
                    [RMUniversalAlert showAlertInViewController:self.YLT_CurrentVC withTitle:@"提示" message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-麦克风”选项中，允许%@访问你的麦克风", YLT_AppName] cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    }];
                }];
            } else {
                [self showMessageInputView];
                [self.recordBtn removeFromSuperview];
            }
        }
            break;
        case YLT_FACE_TAG: {
            sender.selected = !sender.selected;
            self.configer.audioBtn.selected = NO;
            self.configer.addBtn.selected = NO;
            [self.recordBtn removeFromSuperview];
            CGRect faceFrame = self.inputView.frame;
            faceFrame.origin.y = 0;
            CGRect addFrame = self.addInputView.frame;
            addFrame.origin.y = addFrame.size.height;
            if (sender.selected) {
                if (self.configer.inputTextView.inputView != self.inputView) {
                    [self.configer.inputTextView resignFirstResponder];
                    self.faceInputView.frame = faceFrame;
                    self.addInputView.frame = addFrame;
                    self.configer.inputTextView.inputView = self.inputView;
                    [self.configer.inputTextView becomeFirstResponder];
                } else {//页面上
                    [UIView animateWithDuration:0.2 animations:^{
                        self.addInputView.frame = addFrame;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.faceInputView.frame = faceFrame;
                        } completion:nil];
                    }];
                }
            } else {
                [self showMessageInputView];
            }
        }
            break;
        case YLT_ADD_TAG: {
            sender.selected = !sender.selected;
            self.configer.audioBtn.selected = NO;
            self.configer.faceBtn.selected = NO;
            [self.recordBtn removeFromSuperview];
            CGRect addFrame = self.inputView.frame;
            addFrame.origin.y = 0;
            CGRect faceFrame = self.faceInputView.frame;
            faceFrame.origin.y = faceFrame.size.height;
            if (sender.selected) {
                if (self.configer.inputTextView.inputView != self.inputView) {
                    [self.configer.inputTextView resignFirstResponder];
                    self.addInputView.frame = addFrame;
                    self.faceInputView.frame = faceFrame;
                    self.configer.inputTextView.inputView = self.inputView;
                    [self.configer.inputTextView becomeFirstResponder];
                } else {//页面上
                    [UIView animateWithDuration:0.2 animations:^{
                        self.faceInputView.frame = faceFrame;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.addInputView.frame = addFrame;
                        } completion:nil];
                    }];
                }
            } else {
                [self showMessageInputView];
            }
        }
            break;
    }
}

- (void)showMessageInputView {
    if (self.configer.inputTextView.inputView != nil) {
        [self.configer.inputTextView resignFirstResponder];
        [self textViewDidChange:self.configer.inputTextView];
        self.configer.inputTextView.inputView = nil;
    }
    [self.configer.inputTextView becomeFirstResponder];
}

/**
 键盘改变事件
 
 @param userInfo 参数
 */
- (void)keyboardUserInfo:(NSDictionary *)userInfo {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-(YLT_SCREEN_HEIGHT-keyboardEndFrame.origin.y)));
    }];
    if ([self.configer.mainScrollView isKindOfClass:[UIScrollView class]]) {
        [self.configer.mainScrollView scrollRectToVisible:CGRectMake(0, self.configer.mainScrollView.contentSize.height-(YLT_SCREEN_HEIGHT-keyboardEndFrame.origin.y), YLT_SCREEN_WIDTH, YLT_SCREEN_HEIGHT-keyboardEndFrame.origin.y) animated:NO];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger length = textView.text.length;
    
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    [textView layoutIfNeeded];
    
    CGFloat height = self.configer.inputTextView.contentSize.height+16.;
    height = MAX(height, self.configer.height);
    height = MIN(height, self.configer.maxHeight);
    if (height != self.height) {
        self.height = height;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.height));
        }];
        [self.superview layoutIfNeeded];
        if (textView.text.length > 1) {
            [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text YLT_CheckString]) {
            return NO;
        }
        
        [self textViewDidChange:textView];
        return NO;
    }
    return YES;
}

#pragma mark - YLT_RecordManagerDelegate
/**
 * 音量变化
 */
- (void)YLT_RecordVolumeChanged:(NSInteger)volume {
    dispatch_async(dispatch_get_main_queue(), ^{
        [YLT_RecordProgressHUD YLT_RecordVolumeChangeLevel:volume];
    });
}

/**
 * 录音剩余时长
 */
- (void)YLT_RecordTimeRemain:(NSInteger)remain {
    dispatch_async(dispatch_get_main_queue(), ^{
        [YLT_RecordProgressHUD YLT_RemainTime:remain];
    });
}

/**
 * 录音完成
 */
- (void)YLT_RecordCompleteWithData:(NSData *)recordData recordDuration:(NSInteger)recordDuration {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.fileBlock) {
            self.fileBlock(@{@"type":@(AudioType), @"data":recordData, @"duration":@(recordDuration)});
        }
    });
}

/**
 * 录音失败
 */
- (void)YLT_RecordFail {
    [RMUniversalAlert showAlertInViewController:self.YLT_CurrentVC withTitle:@"提示" message:@"录制失败" cancelButtonTitle:@"好的" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
}

/**
 * 远程流媒体状态
 */
- (void)YLT_RemoteAudioStateChanged:(REMOTE_AUDIO_STATE)state {
}

/**
 * 远程流媒体进度检测
 */
- (void)YLT_RemoteAudioProgressChanged:(double)progress duration:(double)duration {
}

#pragma mark - set get

- (UIView *)inputView {
    if (!_inputView) {
        CGRect bounds = CGRectMake(0, 0, YLT_SCREEN_WIDTH, 216);
        _inputView = [[UIView alloc] initWithFrame:bounds];
        [_inputView addSubview:self.addInputView];
        [_inputView addSubview:self.faceInputView];
        self.addInputView.frame = bounds;
        self.faceInputView.frame = bounds;
    }
    return _inputView;
}

- (UIView *)faceInputView {
    if (!_faceInputView) {
        _faceInputView = [[UIView alloc] init];
        @weakify(self);
        [YLT_FaceboardView showFaceboardConfig:^(YLT_FaceboardConfig *config) {
            @strongify(self);
            config.superView = self.faceInputView;
            config.inputView = self.configer.inputTextView;
            config.toolBarHidden = NO;
            
            YLT_FaceboardGroupModel *mo = [YLT_FaceboardGroupModel normalGroupModel];
            [config.keyboards addObject:mo];
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [sendBtn setTitleColor:self.configer.textColor forState:UIControlStateNormal];
            [config.rightBtns addObject:sendBtn];
            
            [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.sendBlock) {
                        if (self.configer.inputTextView) {
                            self.sendBlock(self.configer.inputTextView.text);
                            self.configer.inputTextView.text = @"";
                        } else {
                            self.sendBlock(@"");
                        }
                    }
                });
            }];
            
            config.faceAction = ^(YLT_FaceboardType faceboardType, YLT_FaceModel *faceModel) {
                NSLog(@"%zd -- >> %@", faceboardType, faceModel.faceName);
            };
        }];
    }
    return _faceInputView;
}

- (YLT_AddInputView *)addInputView {
    if (!_addInputView) {
        @weakify(self);
        _addInputView = [YLT_AddInputView showInputViewConfig:^(YLT_AddInputConfig *config) {
            [config.models addObject:[YLT_AddInputModel modelImage:YLT_AccessoryImage(@"mes_itempic") name:@"图片"]];
            [config.models addObject:[YLT_AddInputModel modelImage:YLT_AccessoryImage(@"mes_itemphoto") name:@"相机"]];
            [config.models addObject:[YLT_AddInputModel modelImage:YLT_AccessoryImage(@"mes_itemcall") name:@"语音"]];
            [config.models addObject:[YLT_AddInputModel modelImage:YLT_AccessoryImage(@"mes_itemloc") name:@"语音"]];
            [config.models addObject:[YLT_AddInputModel modelImage:YLT_AccessoryImage(@"mes_friends") name:@"个人名片"]];
        } actionBlock:^(NSInteger index) {
            @strongify(self);
            if (self.addActionBlock) {
                self.addActionBlock(index);
            }
            switch (index) {
                case 0: {//相册
                    [[YLT_AuthorizationHelper shareInstance] YLT_AuthorizationType:YLT_PhotoLibrary success:^{
                        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
                        // 你可以通过block或者代理，来得到用户选择的照片.
                        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                            @strongify(self);
                            if (self.fileBlock) {
                                self.fileBlock(@{@"type":@(PhotoType), @"data":photos});
                            }
                            [self.configer.inputTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
                        }];
                        [self.YLT_CurrentVC presentViewController:imagePickerVc animated:YES completion:nil];
                    } failed:^{
                        [RMUniversalAlert showAlertInViewController:self.YLT_CurrentVC withTitle:@"提示" message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片", YLT_AppName] cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        }];
                    }];
                }
                    break;
                case 1: {//相机
                    [[YLT_AuthorizationHelper shareInstance] YLT_AuthorizationType:YLT_Camera success:^{
                        [YLT_PhotoHelper YLT_PhotoFromCameraAllowEdit:YES success:^(NSDictionary *info) {
                            UIImage *image = info[UIImagePickerControllerOriginalImage];
                            @strongify(self);
                            self.fileBlock(@{@"type":@(PhotoType), @"data":@[image]});
                            [self.configer.inputTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
                        } failed:^(NSError *error) {
                        }];
                    } failed:^{
                        [RMUniversalAlert showAlertInViewController:self.YLT_CurrentVC withTitle:@"提示" message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机", YLT_AppName] cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        }];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    return _addInputView;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_recordBtn setTitleColor:[@"515151" YLT_ColorFromHexString] forState:UIControlStateNormal];
        _recordBtn.layer.cornerRadius = 3;
        _recordBtn.layer.borderColor = [@"999999" YLT_ColorFromHexString].CGColor;
        _recordBtn.layer.borderWidth = 0.5;
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.recordBlock) {
                self.recordBlock(YLT_RecordStatusRecording);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [YLT_RecordProgressHUD YLT_Show];
                [[YLT_RecordManager manager] YLT_StartRecord];
            });
        }];
        
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchDragOutside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.recordBlock) {
                self.recordBlock(YLT_RecordStatusCancel);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [YLT_RecordProgressHUD YLT_RecordStatus:YLT_RecordStatusLooseToCancel];
            });
        }];
        
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchDragInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.recordBlock) {
                self.recordBlock(YLT_RecordStatusRecording);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [YLT_RecordProgressHUD YLT_RecordStatus:YLT_RecordStatusRecording];
            });
        }];
        
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.recordBlock) {
                self.recordBlock(YLT_RecordStatusSuccess);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [YLT_RecordProgressHUD YLT_RecordStatus:YLT_RecordStatusSuccess];
                [[YLT_RecordManager manager] YLT_CompleteRecord];
            });
        }];
        
        [[_recordBtn rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self.recordBlock) {
                self.recordBlock(YLT_RecordStatusCancel);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[YLT_RecordManager manager] YLT_CancelRecord];
                [YLT_RecordProgressHUD YLT_RecordStatus:YLT_RecordStatusCancel];
            });
        }];
    }
    return _recordBtn;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

