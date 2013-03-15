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

- (ProfileItem *)addProfile:(NSString *)name targetPaceHours:(int)targetPaceHours targetPaceMinutes:(int)targetPaceMinutes targetPaceSeconds:(int)targetPaceSeconds tempoAllowMinutes:(int)tempoAllowMinutes tempoAllowSeconds:(int)tempoAllowSeconds tempoSensitivity:(int)tempoSensitivity
{
    ProfileItem *p = [[ProfileItem alloc] initWithProfileName:name targetPaceHours:targetPaceHours targetPaceMinutes:targetPaceMinutes targetPaceSeconds:targetPaceSeconds tempoAllowMinutes:tempoAllowMinutes tempoAllowSeconds:tempoAllowSeconds tempoSensitivity:tempoSensitivity];
    
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
