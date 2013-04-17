//
//  ProfileItemStore.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/6/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileItem.h"

@interface ProfileItemStore : NSObject
{
    NSMutableArray *allProfiles;
}

+ (ProfileItemStore *)sharedStore;

- (NSArray *)allProfiles;
- (ProfileItem *)addProfile:(NSString *)name
               targetPaceHours:(int)targetPaceHours
                targetPaceMinutes:(int)targetPaceMinutes
                targetPaceSeconds:(int)targetPaceSeconds
                audioAllowMinutes:(int)audioAllowMinutes
                audioAllowSeconds:(int)audioAllowSeconds
                audioSensitivity:(int)audioSensitivity
                tempoChangeOn:(BOOL)tempoChangeOn
                pitchChangeOn:(BOOL)pitchChangeOn;
- (int)addProfile:(ProfileItem *)profile;
- (void)removeProfile:(ProfileItem *)p;

@end