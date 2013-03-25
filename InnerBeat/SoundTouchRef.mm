//
//  SoundTouch.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/24/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "SoundTouchRef.h"
#import "SoundTouch.h"

@interface SoundTouchRef()
{
    soundtouch::SoundTouch soundTouchEngine;
}
-(void)setupSoundTouch;

@end

@implementation SoundTouchRef

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setupSoundTouch];
    }
    
    return self;
}

- (float)tempo
{
    
    return tempo;
}

-(void)setupSoundTouch
{
    int sampleRate = 44100;
    int channels = 2;
    soundTouchEngine.setSampleRate(sampleRate);
    soundTouchEngine.setChannels(channels);
    soundTouchEngine.setTempoChange(0.0f);
    soundTouchEngine.setPitchSemiTones(0.0f);
    soundTouchEngine.setRateChange(0.0f);
    soundTouchEngine.setSetting(SETTING_USE_QUICKSEEK, TRUE);
    soundTouchEngine.setSetting(SETTING_USE_AA_FILTER, FALSE);
    
}

-(void)setTempo:(float)newTempo
{
    tempo = newTempo;
    soundTouchEngine.setTempo(newTempo);
}

-(void)stop
{
    soundTouchEngine.clear();
}

@end