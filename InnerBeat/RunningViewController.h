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
#import <CoreLocation/CoreLocation.h>
#import "PlaylistItem.h"
#import "ProfileItem.h"

@interface RunningViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UILabel *gpsField;
    IBOutlet UILabel *timerField;
    IBOutlet UILabel *targetPace;
    IBOutlet UILabel *averagePace;
    
    CLLocationManager *locationManager;
    CLLocation *curLoc;
    CLLocation *lastRecordedLocation;
    CLLocationDistance totalDistance;
    NSMutableArray *locationHistory;
    NSDate *startTime;
    NSTimer *timer;
    NSTimeInterval lastDistanceCalculation;
    int timerCount;
    
}
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) ProfileItem *profile;

- (IBAction)pauseOrResume:(id)sender;

@end
