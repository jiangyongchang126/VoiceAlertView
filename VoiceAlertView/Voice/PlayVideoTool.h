//
//  PlayVideoTool.h
//  test
//
//  Created by iMac on 2019/10/25.
//  Copyright © 2019 蒋永昌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PassWithValueWithTime)(NSString *currentTime,NSString *totalTime);
@interface PlayVideoTool : NSObject

@property(nonatomic,assign,getter=isPlaying)BOOL playing;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)PassWithValueWithTime passWithTime;
+ (instancetype)playerManager;


/**
 *  播放音乐
 */

- (void)musicPlayWithMP3Url:(NSString *)url;

- (void)play;
/**
 *  暂停音乐
 */

- (void)pausePlay;
- (void)killPlayer;

@end

NS_ASSUME_NONNULL_END
