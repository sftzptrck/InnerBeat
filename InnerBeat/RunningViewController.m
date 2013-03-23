//
//  RunningViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/15/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "RunningViewController.h"

@interface RunningViewController ()

@end

@implementation RunningViewController

#define distanceToUpdateEventInMeters 3
#define numLocationsToKeep 5
#define requiredHorizontalAccuracy 40.0f
#define minLocationsToUpdateDistance 2
#define secondsToCalculateDistance 10
#define maxAgeOfLocations 3

@synthesize playlist;
@synthesize profile;

- (id)init
{
    self = [super init];
    if (self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Running Time"];
        
        startTime = [NSDate date];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];

        totalDistance = 0.0;
        locationHistory = [NSMutableArray arrayWithCapacity:numLocationsToKeep];
        
        if ([CLLocationManager locationServicesEnabled]){
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager setDistanceFilter:distanceToUpdateEventInMeters];
            [locationManager startUpdatingLocation];
            
            lastDistanceCalculation = [NSDate timeIntervalSinceReferenceDate];
        }
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self testSongLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([CLLocationManager locationServicesEnabled]){
        [locationManager stopUpdatingLocation];
    }
}

- (void)setPlaylist:(NSArray *)p
{
    playlist = p;
    
}

- (void)setProfile:(ProfileItem *)p
{
    profile = p;
    
}

- (void)increaseTimerCount
{
    timerCount++;
    int seconds = timerCount % 60;
    int minutes = (timerCount / 60) % 60;
    int hours = timerCount / 3600;
    
    timerField.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
    int totalMinutes = minutes + (hours*60);
    float decAvgPace = (totalMinutes + (seconds/60.0))/(totalDistance/5280.0);
    int minPace = (int) decAvgPace;
    int secPace = (int) ((decAvgPace - minPace)*60);
    
    [averagePace setText:[NSString stringWithFormat:@"%02d:%02d", minPace, secPace]];
    
}

- (void)testSongLoad
{
    MPMediaItem *m = [playlist objectAtIndex:0];
    NSURL* url = [m valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSError * error = nil;
    AVAssetReader * reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (oldLocation == nil) return;
    BOOL isStaleLocation = [oldLocation.timestamp compare:startTime] == NSOrderedAscending;
    
    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0.0f && newLocation.horizontalAccuracy < requiredHorizontalAccuracy) {
     
        [locationHistory addObject:newLocation];
        if ([locationHistory count] > numLocationsToKeep) {
            [locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistance = NO;
        if ([locationHistory count] >= minLocationsToUpdateDistance) {
            canUpdateDistance = YES;
        }
        
        if (([NSDate timeIntervalSinceReferenceDate] - lastDistanceCalculation) > secondsToCalculateDistance) {
            lastDistanceCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (lastRecordedLocation != nil) ? lastRecordedLocation : oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = requiredHorizontalAccuracy;
            for (CLLocation *location in locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= maxAgeOfLocations) {
                    if (location.horizontalAccuracy < bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            if (canUpdateDistance) {
                totalDistance = totalDistance + (distance*3.28084);
                NSLog(@"Total:%f", totalDistance);
                float miles = totalDistance/5280.0;
                NSLog(@"MILES: %f", miles);
                int fraction = ((int)roundf(miles * 100)) % 100;
                NSLog(@"fraction: %d", fraction);
                int whole = (int)roundf(miles);
                NSLog(@"whole: %d", whole);
                [gpsField setText:[NSString stringWithFormat:@"%02d:%02d mi", whole, fraction]];
            }
            lastRecordedLocation = bestLocation;
        }
        
    }
    
}

- (void)dealloc
{
    [locationManager setDelegate:nil];
    [timer invalidate];
}

@end
