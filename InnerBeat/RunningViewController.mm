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

static const NSUInteger kDistanceFilter = 5; // The minimum distance (meters) for which we want to receive location updates
static const NSUInteger kNumLocationHistoriesToKeep = 5; // The number of history locations to keep so we can look back at them and see what is the most accurate
static const NSUInteger kNumSpeedHistoriesToAverage = 3; // The number of speeds to keep in history so we can average to get current speed
static const CGFloat kRequiredHorizontalAccuracy = 15.0; // The required accuracy in meters for a location.
static const NSUInteger kMinLocationsNeededToUpdateDistanceAndSpeed = 3; // The number of locations needed in history to update distance and speed
static const NSUInteger kDistanceAndSpeedCalculationInterval = 3; // The interval (seconds) at which we calculate the user's distance and speed
static const NSUInteger kValidLocationHistoryDeltaInterval = 3; // The maximum valid age in seconds of a location stored in the location history
static const NSUInteger kPrioritizeFasterSpeeds = 1; // if > 0, the currentSpeed and complete speed history will automatically be set to the new speed if the new speed is faster than the average speed
static const NSUInteger kDefaultSensitivityNormalizer = 10; // Music will adjust if pace is slower or faster than this number of minutes
static const NSUInteger kMaximumSensitivityNormalizer = 1;
static const NSUInteger kMinimumSensitivityNormalizer = 20;
static const CGFloat kSlowestTempo = 2.0; // The slowest the music tempo will go
static const CGFloat kFastestTempo = 0.5; // The fastest the music tempo will go

@synthesize locationManager, lastRecordedLocation, lastDistanceCalculation, playlist, profile, totalDistance, currentSpeed, locationHistory, speedHistory, startTime, timer, isPaused, player, slider;


- (id)init
{
    self = [super init];
    if (self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Running Time"];

        totalDistance = 0.0;
        isPaused = false;
        
        if ([CLLocationManager locationServicesEnabled]){
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [locationManager setDistanceFilter:kDistanceFilter];
            
            locationHistory = [NSMutableArray arrayWithCapacity:kNumLocationHistoriesToKeep];
            speedHistory = [NSMutableArray arrayWithCapacity:kNumSpeedHistoriesToAverage];
            [self resetLocationUpdates];
            
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
    [targetPace setText:[NSString stringWithFormat:@"%02d:%02d min/mi", profile.targetPaceMinutes, profile.targetPaceSeconds]];
    [self loadMusic];
}

- (void)loadMusic
{
    MPMediaItem *mediaItem = [playlist objectAtIndex:0];
    
    NSURL *inUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
    
	NSLog(@"path = %@", inUrl);
    
	NSError *error = nil;
    
	mDiracAudioPlayer = [[DiracAudioPlayer alloc] initWithContentsOfURL:inUrl channels:1 error:&error];		// LE only supports 1 channel!
	[mDiracAudioPlayer setDelegate:self];
	[mDiracAudioPlayer setNumberOfLoops:1];
	
	[mDiracAudioPlayer play];
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
    if (!isPaused){
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
        
        int minDiff = profile.targetPaceMinutes - minPace;
        int secDiff = profile.targetPaceSeconds - secPace;
        
        int sensitivity = profile.tempoSensitivity;
        int plusMinusSecs = 0;
        
        if (sensitivity == 50){
            plusMinusSecs = (kDefaultSensitivityNormalizer)*60;
        } else if (sensitivity > 50){
            float sensFactor = (sensitivity - 50)/50.0;
            plusMinusSecs = (kDefaultSensitivityNormalizer-((int)(kDefaultSensitivityNormalizer - kMaximumSensitivityNormalizer)*sensFactor))*60;
        } else{
            float sensFactor = (50 - sensitivity)/50.0;
            plusMinusSecs = (kDefaultSensitivityNormalizer+((int)(kMinimumSensitivityNormalizer - kDefaultSensitivityNormalizer)*sensFactor))*60;
        }
        
        float factor = 0.0;
        // Running too fast - slow the music down
        if ((minDiff > 0 || (minDiff == 0 && secDiff > 0)) && (minDiff > profile.tempoAllowMinutes || (minDiff == profile.tempoAllowMinutes && secDiff > profile.tempoAllowSeconds))){
            
            int totalSecs = (minDiff*60 + secDiff) - (profile.tempoAllowMinutes*60 + profile.tempoAllowSeconds);
            
            float normalize = totalSecs/plusMinusSecs;
            
            if (normalize > 1){
                factor = kSlowestTempo;
            } else{
                factor = normalize + 1.0;
            }
        } else if ((minDiff < 0 || (minDiff == 0 && secDiff < 0)) && (abs(minDiff) > profile.tempoAllowMinutes || (abs(minDiff) == profile.tempoAllowMinutes && abs(secDiff) > profile.tempoAllowSeconds))){ // Running too slow - speed up the music
            int totalSecs = (abs(minDiff)*60 + abs(secDiff)) - (profile.tempoAllowMinutes*60 + profile.tempoAllowSeconds);
            
            float normalize = ((float)totalSecs)/plusMinusSecs;
            if (normalize > 1){
                factor = kFastestTempo;
            } else{
                factor = normalize*(-kFastestTempo)+1;
            }
            
        } else { // Running just right
            factor = 1;
        }
         
        [mDiracAudioPlayer changeDuration:factor];
    
        [speedField setText:[NSString stringWithFormat:@"%.4f mi/h", currentSpeed]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (oldLocation == nil) return;
    BOOL isStaleLocation = [oldLocation.timestamp compare:startTime] == NSOrderedAscending;
    
    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy < kRequiredHorizontalAccuracy) {
     
        [locationHistory addObject:newLocation];
        if ([locationHistory count] > kNumLocationHistoriesToKeep) {
            [locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistanceAndSpeed = NO;
        if ([locationHistory count] >= kMinLocationsNeededToUpdateDistanceAndSpeed) {
            canUpdateDistanceAndSpeed = YES;
        }
        
        if (([NSDate timeIntervalSinceReferenceDate] - lastDistanceCalculation) > kDistanceAndSpeedCalculationInterval) {
            lastDistanceCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (lastRecordedLocation != nil) ? lastRecordedLocation : oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (CLLocation *location in locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
                    if (location.horizontalAccuracy < bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            
            if (canUpdateDistanceAndSpeed) {
                totalDistance = totalDistance + (distance*3.28084);
                float miles = totalDistance/5280.0;
                int fraction = ((int)roundf(miles * 100)) % 100;
                int whole = (int)roundf(miles);
                [gpsField setText:[NSString stringWithFormat:@"%02d:%02d mi", whole, fraction]];
            }
            lastRecordedLocation = bestLocation;
            
            NSTimeInterval timeSinceLastLocation = [bestLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
            
            if (timeSinceLastLocation > 0){
                CGFloat speed = distance / timeSinceLastLocation;
                if (speed <= 0 && [speedHistory count] == 0){
                    
                } else {
                    [speedHistory addObject:[NSNumber numberWithDouble:speed]];
                }
                if ([speedHistory count] > kNumSpeedHistoriesToAverage){
                    [speedHistory removeObjectAtIndex:0];
                }
                if ([speedHistory count] > 1){
                    double totalSpeed = 0;
                    for (NSNumber *speedNumber in speedHistory){
                        totalSpeed += [speedNumber doubleValue];
                    }
                    if (canUpdateDistanceAndSpeed){
                        double newSpeed = totalSpeed / (double)[speedHistory count];
                        if (kPrioritizeFasterSpeeds > 0 && speed > newSpeed){
                            newSpeed = speed;
                            [speedHistory removeAllObjects];
                            for (int i=0; i<kNumSpeedHistoriesToAverage; i++){
                                [speedHistory addObject:[NSNumber numberWithDouble:newSpeed]];
                            }
                        }
                        currentSpeed = newSpeed;
                    }
                }
            }
        }
        
    }
    
}

- (IBAction)pauseOrResume:(id)sender
{
    if (!isPaused){
        [locationManager stopUpdatingLocation];
        [mDiracAudioPlayer pause];
        //[self resetLocationUpdates];
        self.view.backgroundColor = [UIColor grayColor];
        isPaused = true;
    } else{
        [locationManager startUpdatingLocation];
        [mDiracAudioPlayer play];
        self.view.backgroundColor = [UIColor whiteColor];
        isPaused = false;
    }
}

- (void)resetLocationUpdates
{
    startTime = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    [locationManager setDelegate:nil];
    [timer invalidate];
}


- (void) mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
