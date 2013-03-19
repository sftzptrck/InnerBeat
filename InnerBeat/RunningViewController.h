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
    CLLocationManager *locationManager;
    CLLocation *curLoc;
    CLLocation *lastRecordedLocation;
    CLLocationDistance totalDistance;
    NSMutableArray *locationHistory;
    NSDate *startTime;
    NSTimeInterval lastDistanceCalculation;
    
}
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) ProfileItem *profile;

@end
