//
//  ProfileItem.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/6/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileItem : NSObject

- (id)initWithProfileName:(NSString *)name
          targetPaceHours:(int)targetPaceHours
            targetPaceMinutes:(int)targetPaceMinutes
            targetPaceSeconds:(int)targetPaceSeconds
            audioAllowMinutes:(int)audioAllowMinutes
            audioAllowSeconds:(int)audioAllowSeconds
            audioSensitivity:(int)audioSensitivity
            tempoChangeOn:(BOOL)tempoChangeOn
            pitchChangeOn:(BOOL)pitchChangeOn;

@property (nonatomic, copy) NSString *profileName;
@property (nonatomic) int targetPaceHours;
@property (nonatomic) int targetPaceMinutes;
@property (nonatomic) int targetPaceSeconds;
@property (nonatomic) int audioAllowMinutes;
@property (nonatomic) int audioAllowSeconds;
@property (nonatomic) int audioSensitivity;
@property (nonatomic) BOOL tempoChangeOn;
@property (nonatomic) BOOL pitchChangeOn;

@end
