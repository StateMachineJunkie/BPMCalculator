//
//  LegacyBPMCalculator.h
//  BPMCalculator
//
//  Created by Michael A. Crawford on 7/7/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LegacyBPMCalculator : NSObject

- (instancetype)initWithSize:(NSUInteger)size;
- (double)inputSample:(double *)stdDeviation;
- (void)reset;

@end
