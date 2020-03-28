//
//  ViewController.m
//  VoiceAlertView
//
//  Created by iMac on 2020/3/28.
//  Copyright © 2020 iMac. All rights reserved.
//

#import "ViewController.h"
#import "VoiceOnWindowView.h"
#define kWindow                                             [UIApplication sharedApplication].keyWindow
@interface ViewController ()

@property(nonatomic,strong)VoiceOnWindowView *voiceOnView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor cyanColor];
    playBtn.frame = CGRectMake(100, 100, 100, 40);
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    // Do any additional setup after loading the view.
}


- (void)playAction{
    
    NSDictionary *dic = @{
                          @"type":@"3",
                          @"ID":@"900f48dc379e4eee934381a480768c0e",
                          @"title":@"外交习语 | 首次G20领导人“云会议”，习近平怎么说？",
                          @"voiceUrl":@"http://xuexiguofang.oss-cn-beijing.aliyuncs.com/article/voice/1585351496845.mp3",
                          @"status":@"play"
                          };
    self.voiceOnView.currentDict = dic;
    if (!self.voiceOnView.isOnScreen) {
        [self.voiceOnView showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    
}

@end
