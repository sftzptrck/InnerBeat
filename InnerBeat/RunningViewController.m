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
    
        [speedField setText:[NSString stringWithFormat:@"%.4f mi/h", currentSpeed]];
    }
}

- (void)testSongLoad
{
    MPMediaItem *m = [playlist objectAtIndex:0];
    NSURL* url = [m valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    AVAssetTrack *audioTrack = [[asset tracks] objectAtIndex:0];
    AVMutableAudioMixInputParameters *inputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
    
    MTAudioProcessingTapCallbacks callbacks;
    callbacks.version = kMTAudioProcessingTapCallbacksVersion_0;
    callbacks.clientInfo = (__bridge void *)(self);
    callbacks.init = init;
    callbacks.prepare = prepare;
    callbacks.process = process;
    callbacks.unprepare = unprepare;
    callbacks.finalize = finalize;
    
    MTAudioProcessingTapRef tap;
    OSStatus err = MTAudioProcessingTapCreate(kCFAllocatorDefault, &callbacks, kMTAudioProcessingTapCreationFlag_PostEffects, &tap);
    
    if (err || !tap){
        NSLog(@"Unable to create the Audio Processing Tap");
        return;
    }
    
    inputParams.audioTapProcessor = tap;
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = @[inputParams];
    playerItem.audioMix = audioMix;
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [self.player play];
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
        //[self resetLocationUpdates];
        self.view.backgroundColor = [UIColor grayColor];
        isPaused = true;
    } else{
        [locationManager startUpdatingLocation];
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

void init(MTAudioProcessingTapRef Tap, void *clientInfo, void **tapStorageOut)
{
    NSLog(@"Initializing the Audio Tap Processor");
    *tapStorageOut = clientInfo;
}

void finalize(MTAudioProcessingTapRef tap)
{
    NSLog(@"Finalizing the Audio Tap Processor");
}

void prepare(MTAudioProcessingTapRef tap, CMItemCount maxFrames, const AudioStreamBasicDescription *processingFormat)
{
    NSLog(@"Preparing the Audio Tap Processor");
}

void unprepare(MTAudioProcessingTapRef tap)
{
    NSLog(@"Unpreparing the Audio Tap Processor");
}

void process(MTAudioProcessingTapRef tap, CMItemCount numberFrames,
             MTAudioProcessingTapFlags flags, AudioBufferList *bufferListInOut,
             CMItemCount *numberFramesOut, MTAudioProcessingTapFlags *flagsOut)
{
    OSStatus err = MTAudioProcessingTapGetSourceAudio(tap, numberFrames, bufferListInOut,
                                                      flagsOut, NULL, numberFramesOut);
    if (err) NSLog(@"Error from GetSourceAudio: %ld", err);
    
    RunningViewController *self = (__bridge RunningViewController *) MTAudioProcessingTapGetStorage(tap);
    
    Float32 *bufA = bufferListInOut->mBuffers[0].mData;
    Float32 *bufB = bufferListInOut->mBuffers[1].mData;
    
    
    //float scalar = self.slider.value;
    
    //vDSP_vsmul(bufferListInOut->mBuffers[LAKE_RIGHT_CHANNEL].mData, 1, &scalar, bufferListInOut->mBuffers[LAKE_RIGHT_CHANNEL].mData, 1, bufferListInOut->mBuffers[LAKE_RIGHT_CHANNEL].mDataByteSize / sizeof(float));
    //vDSP_vsmul(bufferListInOut->mBuffers[LAKE_LEFT_CHANNEL].mData, 1, &scalar, bufferListInOut->mBuffers[LAKE_LEFT_CHANNEL].mData, 1, bufferListInOut->mBuffers[LAKE_LEFT_CHANNEL].mDataByteSize / sizeof(float));
}
@end
