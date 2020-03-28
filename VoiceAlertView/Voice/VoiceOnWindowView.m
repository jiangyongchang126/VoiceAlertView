//
//  VoiceOnWindowView.m
//  GuoFangVersion2
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "VoiceOnWindowView.h"
#import "VoiceHeader.h"
#import "UIView+Rect.h"

#define kScreenWidthVoice [[UIScreen mainScreen] bounds].size.width
#define kScreenHeightVoice [[UIScreen mainScreen] bounds].size.height

#define kk_WIDTH self.frame.size.width
#define kk_HEIGHT self.frame.size.height
#define animateDuration 0.3       //位置改变动画时间
#define showDuration 0.1          //展开动画时间
#define statusChangeDuration  3.0    //状态改变时间
#define NewsTitleTop30               15
#define NewsTitleLeft30              15
#define TABBAR_VIEW_HIGHT   49.0f //tabbar高度

#define STATUS_BAR_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define NAV_HEIGHT          44.0f //导航栏高度
#define VIEW_ZERO_POSITION  (NAV_HEIGHT + STATUS_BAR_HEIGHT) //视图初始化位置
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface VoiceOnWindowView ()
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)NSDictionary *lastDict;
@property(nonatomic,strong)NSString *titleName;
@property(nonatomic,strong)UIPanGestureRecognizer *pan;

@end

@implementation VoiceOnWindowView

+ (instancetype)shareVoiceView{

    static VoiceOnWindowView *showRankView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        showRankView = [[self alloc]initWithFrame:CGRectMake(NewsTitleLeft30, kScreenHeightVoice-NewsTitleTop30-TABBAR_VIEW_HIGHT-50, kScreenWidthVoice-2*NewsTitleLeft30-100, 50)];
        showRankView.layer.masksToBounds = YES;
        showRankView.layer.cornerRadius = 5;
    });
    return showRankView;

//    VoiceOnWindowView *showRankView = [[VoiceOnWindowView alloc]initWithFrame:CGRectMake(NewsTitleLeft30, kScreenHeightVoice-NewsTitleTop30-TABBAR_VIEW_HIGHT-50, kScreenWidthVoice-2*NewsTitleLeft30-100, 50)];
//    showRankView.layer.masksToBounds = YES;
//    showRankView.layer.cornerRadius = 5;
//    return showRankView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
        
        [self updataSubViews];
    }
    return self;
}


- (void)updataSubViews {

    self.isOnScreen = NO;
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.coverView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    self.coverView.layer.masksToBounds = YES;
    self.coverView.layer.cornerRadius = 5;
    [self addSubview:self.coverView];
    
    self.titleLab = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(10, 5, self.width-90, 20)];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.font = [UIFont systemFontOfSize:14];
    [self.coverView addSubview:self.titleLab];

//    [self.titleLab scroll];
    
    self.timeLab = [[UILabel alloc]init];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textColor = [UIColor whiteColor];
    self.timeLab.frame = CGRectMake(10, 25, 200, 15);
    [self.coverView addSubview:self.timeLab];
    self.timeLab.text = @"00:00/00:00";

    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.frame = CGRectMake(self.width-30, 15, 20, 20);
    [self.closeBtn setImage:[UIImage imageNamed:@"white_close"] forState:UIControlStateNormal];
    [self.coverView addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(self.width-70, 15, 20, 20);
    [self.playBtn setImage:[UIImage imageNamed:@"white_pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"white_play"] forState:UIControlStateSelected];

    [self.coverView addSubview:self.playBtn];
    [self.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    self.pan.delaysTouchesBegan = NO;
    [self addGestureRecognizer:self.pan];
}

- (void)pauseAction{
    [[PlayVideoTool playerManager] pausePlay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VoiceWindowPlayerClick" object:@(1)];
    self.playBtn.selected = YES;
}

- (void)closeBtnAction{
    [[PlayVideoTool playerManager] killPlayer];

    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VoiceWindowPlayerClick" object:@(1)];

}

- (void)playBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 暂停
        [[PlayVideoTool playerManager] pausePlay];
    }else{
        // 播放
        [[PlayVideoTool playerManager] play];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VoiceWindowPlayerClick" object:@(sender.selected)];

}




-(void)setCurrentDict:(NSDictionary *)currentDict{
 
    _currentDict = currentDict;
    NSString *lastVoiceUrl = [self.lastDict objectForKey:@"voiceUrl"];
    
    NSString *str = [_currentDict objectForKey:@"status"];
    NSString *voiceUrl = [_currentDict objectForKey:@"voiceUrl"];
    NSString *title = [_currentDict objectForKey:@"title"];
    
    if ([str isEqualToString:@"play"]) {
        if ([PlayVideoTool playerManager].isPlaying) {
            // 正在播放
            if ([voiceUrl isEqualToString:lastVoiceUrl]) {
                // noting
            }else{
                [[PlayVideoTool playerManager] musicPlayWithMP3Url:voiceUrl];
            }
        }else{
            if ([voiceUrl isEqualToString:lastVoiceUrl]) {
                // noting
                [[PlayVideoTool playerManager] play];
            }else{
                [[PlayVideoTool playerManager] musicPlayWithMP3Url:voiceUrl];
            }
        }
    }else{
        [[PlayVideoTool playerManager] pausePlay];
    }
    self.lastDict = currentDict;
    @weakify(self);
    if ([self.titleName isEqualToString:title]) {
        
    }else{
        [self.titleLab setText:title];
    }
    self.titleName = title;
    [PlayVideoTool playerManager].passWithTime = ^(NSString * _Nonnull currentTime, NSString * _Nonnull totalTime) {
        @strongify(self);
        self.timeLab.attributedText = [self returnWithCurrentTime:currentTime totalTime:totalTime];
    };
    
}

-(NSMutableAttributedString *)returnWithCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime{
    
    NSMutableAttributedString * mString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",currentTime,totalTime]];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor grayColor]
                    range:NSMakeRange(0, mString.length)];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:NSMakeRange(0, currentTime.length)];
    
    return mString;
}


- (void)showInView:(UIView *)view{
    
    //    [view addSubview:self];
    self.isOnScreen = YES;

    CATransition *tran = [CATransition animation];
    tran.type = kCATransitionFade;
    tran.subtype = kCATransitionFromTop;
    tran.duration = 0.3;
    tran.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [self.layer addAnimation:tran forKey:@"animation"];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [view addSubview:self];
                         
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void)dismiss {
    self.isOnScreen = NO;

    CATransition *tran = [CATransition animation];
    tran.type = kCATransitionMoveIn;
    tran.subtype = kCATransitionFromBottom;
    tran.duration = 0.3;
    tran.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [self.layer addAnimation:tran forKey:@"animation"];
    
    [UIView animateWithDuration:.3
                     animations:^{
                         //                         self.coverView.frame = CGRectMake(0, self.height, self.width, self.coverHeight);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];

                     }];
}


- (void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [self stopAnimation];
//        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
        
        [self changBoundsabovePanPoint:panPoint];
        
    }
}

- (void)changBoundsabovePanPoint:(CGPoint)panPoint{
    
    if(panPoint.x <= kScreenWidth/2)
    {
        
        if (panPoint.y <= kk_HEIGHT/2+VIEW_ZERO_POSITION) {
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_WIDTH/2 + NewsTitleLeft30, kk_HEIGHT/2+VIEW_ZERO_POSITION);
            }];
        }else if (panPoint.y >= kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT){
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_WIDTH/2+ NewsTitleLeft30, kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT);
            }];
        }else{
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kk_WIDTH/2+ NewsTitleLeft30, panPoint.y);
            }];
        }
//        if(panPoint.y <= kk_HEIGHT/2+VIEW_ZERO_POSITION && panPoint.x >= kk_WIDTH/2)
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kk_WIDTH/2 + NewsTitleLeft30, kk_HEIGHT/2+VIEW_ZERO_POSITION);
//            }];
//        }
//        else if(panPoint.y >= kScreenHeight-kk_HEIGHT/2 && panPoint.x >= kk_WIDTH/2)
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kk_WIDTH/2+ NewsTitleLeft30, kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT);
//            }];
//        }
//        else if (panPoint.x < kk_WIDTH/2 && panPoint.y > kScreenHeight-kk_HEIGHT/2)
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kk_WIDTH/2+NewsTitleLeft30, kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT);
//            }];
//        }
//        else
//        {
//            CGFloat pointy = panPoint.y < kk_HEIGHT/2 ? kk_HEIGHT/2+VIEW_ZERO_POSITION :panPoint.y;
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kk_WIDTH/2+NewsTitleLeft30, pointy);
//            }];
//        }
    }
    else if(panPoint.x > kScreenWidth/2)
    {
        if (panPoint.y <= kk_HEIGHT/2+VIEW_ZERO_POSITION) {
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kScreenWidth-kk_WIDTH/2- NewsTitleLeft30, kk_HEIGHT/2+VIEW_ZERO_POSITION);
            }];
        }else if (panPoint.y >= kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT){
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kScreenWidth-kk_WIDTH/2- NewsTitleLeft30, kScreenHeight-kk_HEIGHT/2-TABBAR_VIEW_HIGHT);
            }];
        }else{
            
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kScreenWidth-kk_WIDTH/2- NewsTitleLeft30, panPoint.y);
            }];
        }
        
        
//        if(panPoint.y <= 40+kk_HEIGHT/2 && panPoint.x < kScreenWidth-kk_WIDTH/2-20 )
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(panPoint.x, kk_HEIGHT/2);
//            }];
//        }
//        else if(panPoint.y >= kScreenHeight-40-kk_HEIGHT/2 && panPoint.x < kScreenWidth-kk_WIDTH/2-20)
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(panPoint.x, kScreenHeight-kk_HEIGHT/2);
//            }];
//        }
//        else if (panPoint.x > kScreenWidth-kk_WIDTH/2-20 && panPoint.y < kk_HEIGHT/2)
//        {
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kScreenWidth-kk_WIDTH/2, kk_HEIGHT/2);
//            }];
//        }
//        else
//        {
//            CGFloat pointy = panPoint.y > kScreenHeight-kk_HEIGHT/2 ? kScreenHeight-kk_HEIGHT/2 :panPoint.y;
//            [UIView animateWithDuration:animateDuration animations:^{
//                self.center = CGPointMake(kScreenWidth-kk_WIDTH/2, pointy);
//            }];
//        }
    }
    
}

- (void)stopAnimation{
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonAnimation) object:nil];
    
}

- (void)changeStatus
{
//    [UIView animateWithDuration:1.0 animations:^{
////        _mainImageButton.alpha = sleepAlpha;
//    }];
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat x = self.center.x < 20+kk_WIDTH/2 ? 0 :  self.center.x > kScreenWidth - 20 -kk_WIDTH/2 ? kScreenWidth : self.center.x;
        CGFloat y = self.center.y < 40 + kk_HEIGHT/2 ? 0 : self.center.y > kScreenHeight - 40 - kk_HEIGHT/2 ? kScreenHeight : self.center.y;
        
        //禁止停留在4个角
        if((x == 0 && y ==0) || (x == kScreenWidth && y == 0) || (x == 0 && y == kScreenHeight) || (x == kScreenWidth && y == kScreenHeight)){
            y = self.center.y;
        }
        self.center = CGPointMake(x, y);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
