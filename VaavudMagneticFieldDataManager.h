//
//  VaavudMagneticFieldDataManager.h
//  VaavudCore
//
//  Created by Andreas Okholm on 5/9/13.
//  Copyright (c) 2013 Andreas Okholm. All rights reserved.
//

#define preferedSampleFrequency 100 // actual is arround 63
#define LOG_OTHER NO

static double const STANDARD_FREQUENCY_START = 0.238;

static double const STANDARD_FREQUENCY_FACTOR = 1.07;
static double const I4_FREQUENCY_FACTOR = 1.16;
static double const I5_FREQUENCY_FACTOR = 1.04;

static int const FQ40_FFT_LENGTH = 64;
static int const FQ40_FFT_DATA_LENGTH = 50;

static double const FFT_PEAK_MAG_MIN_GENERAL = 5.0;
static double const FFT_PEAK_MAG_MIN_IPHONE6 = 2.5;



#import <Foundation/Foundation.h>

@class VaavudMagneticFieldDataManager;             //define class, so protocol can see VaavudMagneticFieldDataManager
@protocol VaavudMagneticFieldDataManagerDelegate   //define delegate protocol
- (void) magneticFieldValuesUpdated;               //define delegate method to be implemented within another class
@end //end protocol


@interface VaavudMagneticFieldDataManager : NSObject

+ (VaavudMagneticFieldDataManager *)sharedMagneticFieldDataManager;

- (void)start;
- (void)stop;

@property (readonly, nonatomic, strong) NSMutableArray *magneticFieldReadingsTime;
@property (readonly, nonatomic, strong) NSMutableArray *magneticFieldReadingsx;
@property (readonly, nonatomic, strong) NSMutableArray *magneticFieldReadingsy;
@property (readonly, nonatomic, strong) NSMutableArray *magneticFieldReadingsz;

@property (nonatomic, weak) id<VaavudMagneticFieldDataManagerDelegate> delegate;

@end
