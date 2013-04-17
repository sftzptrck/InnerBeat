//
//  ProfileItemStore.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/6/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileItemStore.h"
#import "ProfileItem.h"

@implementation ProfileItemStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self){
        allProfiles = [[NSMutableArray alloc] init];
        [self addProfile:@"Default" targetPaceHours:0 targetPaceMinutes:90 targetPaceSeconds:0 audioAllowMinutes:5 audioAllowSeconds:0 audioSensitivity:50 tempoChangeOn:true pitchChangeOn:false];
    }
    
    return self;
}

+ (ProfileItemStore *)sharedStore
{
    static ProfileItemStore *sharedStore = nil;
    if (!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

- (NSArray *)allProfiles
{
    return allProfiles;
}

- (ProfileItem *)addProfile:(NSString *)name targetPaceHours:(int)targetPaceHours targetPaceMinutes:(int)targetPaceMinutes targetPaceSeconds:(int)targetPaceSeconds audioAllowMinutes:(int)audioAllowMinutes audioAllowSeconds:(int)audioAllowSeconds audioSensitivity:(int)audioSensitivity tempoChangeOn:(BOOL)tempoChangeOn pitchChangeOn:(BOOL)pitchChangeOn
{
    ProfileItem *p = [[ProfileItem alloc] initWithProfileName:name targetPaceHours:targetPaceHours targetPaceMinutes:targetPaceMinutes targetPaceSeconds:targetPaceSeconds audioAllowMinutes:audioAllowMinutes audioAllowSeconds:audioAllowSeconds audioSensitivity:audioSensitivity tempoChangeOn:tempoChangeOn pitchChangeOn:pitchChangeOn];
    
    [allProfiles addObject:p];
    
    return p;
}

- (int)addProfile:(ProfileItem *)profile
{
    [allProfiles addObject:profile];
    
    return [allProfiles count] - 1;
}

- (void)removeProfile:(ProfileItem *)p
{
    [allProfiles removeObjectIdenticalTo:p];
}

@end
