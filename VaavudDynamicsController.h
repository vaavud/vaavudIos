//
//  vaavudDynamicsController.h
//  VaavudCore
//
//  Created by Andreas Okholm on 5/19/13.
//  Copyright (c) 2013 Andreas Okholm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#define accAndGyroSampleFrequency 5
#define FFTForEvery 3

// Thresholds for isValid
#define accelerationMaxForValid 0.4 // g acc/(9.82 m/s^2)
#define angularVelocityMaxForValid 0.4 // rad/s (maybe deg/s or another unit)
#define orientationDeviationMaxForValid 0.63 // rad  (36) degrees


@protocol VaavudDynamicsControllerDelegate

- (void)dynamicsIsValid:(BOOL)validity;

@end

@interface VaavudDynamicsController : NSObject <CLLocationManagerDelegate>

- (void)start;
- (void)stop;

@property (nonatomic) BOOL isValid;

@property (nonatomic, weak) id<VaavudDynamicsControllerDelegate> vaavudCoreController;

@end
