//
//  LegacyBPMCalculatorProxy.h
//  BPMCalculator
//
//  Created by Michael A. Crawford on 7/7/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LegacyBPMCalculatorProxy : NSObject

- (instancetype)initWithSize:(NSUInteger)size;
- (double)inputSample:(double *)stddev;
- (void)reset;

@end
