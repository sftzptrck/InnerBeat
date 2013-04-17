//
//  ProfileItem.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/6/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileItem.h"

@implementation ProfileItem
@synthesize profileName, targetPaceHours, targetPaceMinutes, targetPaceSeconds, audioAllowMinutes, audioAllowSeconds, audioSensitivity, tempoChangeOn, pitchChangeOn;

- (id)initWithProfileName:(NSString *)name targetPaceHours:(int)tPaceHours targetPaceMinutes:(int)tPaceMinutes targetPaceSeconds:(int)tPaceSeconds audioAllowMinutes:(int)aAllowMinutes audioAllowSeconds:(int)aAllowSeconds audioSensitivity:(int)aSensitivity tempoChangeOn:(BOOL)tChangeOn pitchChangeOn:(BOOL)pChangeOn
{
    self = [super init];
    
    if (self){
        [self setProfileName:name];
        [self setTargetPaceHours:tPaceHours];
        [self setTargetPaceMinutes:tPaceMinutes];
        [self setTargetPaceSeconds:tPaceSeconds];
        [self setAudioAllowMinutes:aAllowMinutes];
        [self setAudioAllowSeconds:aAllowSeconds];
        [self setAudioSensitivity:aSensitivity];
        [self setTempoChangeOn:tChangeOn];
        [self setPitchChangeOn:pChangeOn];
    }
    
    return self;
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@", profileName];
    
    return descriptionString;
}

@end
