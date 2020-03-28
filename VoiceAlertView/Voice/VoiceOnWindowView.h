//
//  VoiceOnWindowView.h
//  GuoFangVersion2
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayVideoTool.h"
#import "AutoScrollLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceOnWindowView : UIView

@property(nonatomic,strong)AutoScrollLabel *titleLab;

@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,assign)BOOL isOnScreen;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)NSDictionary *currentDict;

+ (instancetype)shareVoiceView;

- (void)showInView:(UIView *)view;
- (void)closeBtnAction;
- (void)pauseAction;

@end

NS_ASSUME_NONNULL_END
