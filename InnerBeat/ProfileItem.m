//
//  ProfileItem.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/6/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileItem.h"

@implementation ProfileItem
@synthesize profileName, targetPaceHours, targetPaceMinutes, targetPaceSeconds, tempoAllowMinutes, tempoAllowSeconds, tempoSensitivity;

- (id)initWithProfileName:(NSString *)name targetPaceHours:(int)tPaceHours targetPaceMinutes:(int)tPaceMinutes targetPaceSeconds:(int)tPaceSeconds tempoAllowMinutes:(int)tAllowMinutes tempoAllowSeconds:(int)tAllowSeconds tempoSensitivity:(int)tSensitivity
{
    self = [super init];
    
    if (self){
        [self setProfileName:name];
        [self setTargetPaceHours:tPaceHours];
        [self setTargetPaceMinutes:tPaceMinutes];
        [self setTargetPaceSeconds:tPaceSeconds];
        [self setTempoAllowMinutes:tPaceMinutes];
        [self setTempoAllowSeconds:tAllowSeconds];
        [self setTempoSensitivity:tSensitivity];
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
