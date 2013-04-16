//
//  RunningViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/15/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DiracAudioPlayer.h"
#import <CoreLocation/CoreLocation.h>
#import <Accelerate/Accelerate.h>
#import "PlaylistItem.h"
#import "ProfileItem.h"

@interface RunningViewController : UIViewController <CLLocationManagerDelegate,MPMediaPickerControllerDelegate>
{
    IBOutlet UILabel *gpsField;
    IBOutlet UILabel *timerField;
    IBOutlet UILabel *targetPace;
    IBOutlet UILabel *averagePace;
    IBOutlet UILabel *speedField;
    
    int timerCount;
    
    DiracAudioPlayer *mDiracAudioPlayer;
	
	MPMediaPickerController *mPicker;
    MPMusicPlayerController *mPlayer;
    MPMediaQuery *mQuery;
    MPMediaPredicate *mPredicate;
    
    UIColor *savedBackground;
    
}
@property (nonatomic) BOOL isPaused;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastRecordedLocation;
@property (nonatomic) NSTimeInterval lastDistanceCalculation;
@property (nonatomic, readonly) CLLocationDistance totalDistance;
@property (nonatomic, readonly) double currentSpeed;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) ProfileItem *profile;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) NSMutableArray *speedHistory;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVPlayer *player;
@property (strong, nonatomic) IBOutlet UISlider *slider;

- (IBAction)pauseOrResume:(id)sender;
- (void)resetLocationUpdates;

@end
