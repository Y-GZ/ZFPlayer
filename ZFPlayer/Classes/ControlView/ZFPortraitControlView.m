//
//  ZFPortraitControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFPortraitControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import "UIImageView+ZFCache.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayerConst.h>
#else
#import "ZFPlayerConst.h"
#endif

@interface ZFPortraitControlView () <ZFSliderViewDelegate>

/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间 
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UIButton *muteBtn;

@property (nonatomic, strong) UIButton *giftBtn;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIImageView *avatarImage;

@property (nonatomic, strong) UILabel *nameLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation ZFPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self addSubview:self.bottomToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.moreBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.muteBtn];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self addSubview:self.avatarImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.giftBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        [self resetControlView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    CGFloat min_margin = 10;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 44 + (iPhoneX ? 44 : 20);
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.backBtn.frame = CGRectMake(min_margin, min_h - 44, 44, 44);
    
    self.moreBtn.frame = CGRectMake(self.topToolView.zf_right - 44 - min_margin, min_h - 44, 44, 44);
    
    min_h = iPhoneX ? 100 : 73;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15;
    min_y = 32;
    min_w = 30;
    min_h = 30;
    
    self.avatarImage.frame = CGRectMake(min_x, self.bottomToolView.zf_top - 40, 40, 40);
    self.nameLabel.frame = CGRectMake(min_x + 50, self.avatarImage.zf_top, self.bottomToolView.zf_width - min_x - 116, 40);
    self.titleLabel.frame = CGRectMake(min_x, self.avatarImage.zf_top - 30, self.bottomToolView.zf_width - min_x - 76, 20);
    self.giftBtn.frame = CGRectMake(self.bottomToolView.zf_width - 66, self.avatarImage.zf_bottom - 50, 46, 46);
    
    self.muteBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    min_x = self.muteBtn.zf_right + 8;
    
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.playOrPauseBtn.zf_right + 4;
    min_y = 0;
    min_w = 62;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_w = 62;
    min_x = self.bottomToolView.zf_width - min_w - min_margin;
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        self.playOrPauseBtn.alpha = 0;
    } else {
        self.topToolView.zf_y = 0;
        self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        self.playOrPauseBtn.alpha = 1;
    }
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    [self.player enterFullScreen:YES animated:YES];
}

- (void)backBtnClickAction:(UIButton *)sender {
    self.player.lockedScreen = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)addMuteBtnSel:(SEL)selector actionTaget:(id)target {
    __weak typeof(target)weakTarget = target;
    [self.muteBtn addTarget:weakTarget action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)addGiftBtnSel:(SEL)selector actionTaget:(id)target {
    __weak typeof(target)weakTarget = target;
    [self.giftBtn addTarget:weakTarget action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)addMoreBtnSel:(SEL)selector actionTaget:(id)target {
    __weak typeof(target)weakTarget = target;
    [self.moreBtn addTarget:weakTarget action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeMuteStatus:(BOOL)isMute {
    NSString *imageStr = @"ijk_mute";
    if (!isMute) {
        imageStr = @"ijk_volume";
    }
    [self.muteBtn setImage:ZFPlayer_Image(imageStr) forState:UIControlStateNormal];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @zf_weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @zf_strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                if (self.sliderValueChanged) self.sliderValueChanged(value);
            }
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

#pragma mark - public method 

/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
}

- (void)showControlView {
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title hostAvatar:(NSString *_Nullable)avatar hostName:(NSString *_Nullable)name fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.nameLabel.text = name;
    if (avatar != nil) {
        [self.avatarImage setImageWithURLString:avatar placeholderImageName:nil];
    }
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - setter

- (void)setFullScreenMode:(ZFFullScreenMode)fullScreenMode {
    _fullScreenMode = fullScreenMode;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:ZFPlayer_Image(@"ZFPlayer_fullscreen") forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:ZFPlayer_Image(@"ijk_mute") forState:UIControlStateNormal];
    }
    return _muteBtn;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage imageNamed:@"home_gift_send"] forState:UIControlStateNormal];
    }
    return _giftBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
        _moreBtn.tintColor = [UIColor whiteColor];
    }
    return _moreBtn;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImage.layer.cornerRadius = 20;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatarImage.layer.borderWidth = 2;
    }
    return _avatarImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _nameLabel;
}

@end
