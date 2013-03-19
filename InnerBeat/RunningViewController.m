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
        totalDistance = 0.0;
        
        if ([CLLocationManager locationServicesEnabled]){
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager setDistanceFilter:distanceToUpdateEventInMeters];
        }
        
        locationHistory = [NSMutableArray arrayWithCapacity:numLocationsToKeep];
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
    if ([CLLocationManager locationServicesEnabled]){
        [locationManager startUpdatingLocation];
    }
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
    if (oldLocation == nil){
        return;
    }
    
    BOOL staleLocation;
    
    if ([[oldLocation timestamp] compare:startTime] == NSOrderedAscending){
        staleLocation = TRUE;
    } else {
        staleLocation = FALSE;
    }
    
    if (!staleLocation && newLocation.horizontalAccuracy >= 0.0f && newLocation.horizontalAccuracy < requiredHorizontalAccuracy) {
     
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
                totalDistance += distance;
                [gpsField setText:[NSString stringWithFormat:@"%f", totalDistance]];
            }
            lastRecordedLocation = bestLocation;
        }
        
    }
    
}

- (void)dealloc
{
    [locationManager setDelegate:nil];
}

@end
