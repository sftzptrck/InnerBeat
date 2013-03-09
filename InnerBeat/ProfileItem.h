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
            tempoAllowMinutes:(int)tempoAllowMinutes
            tempoAllowSeconds:(int)tempoAllowSeconds
            tempoSensitivity:(int)tempoSensitivity;

@property (nonatomic, copy) NSString *profileName;
@property (nonatomic) int targetPaceHours;
@property (nonatomic) int targetPaceMinutes;
@property (nonatomic) int targetPaceSeconds;
@property (nonatomic) int tempoAllowMinutes;
@property (nonatomic) int tempoAllowSeconds;
@property (nonatomic) int tempoSensitivity;

@end
