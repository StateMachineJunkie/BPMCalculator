//
//  LegacyBPMCalculatorProxy.m
//  BPMCalculator
//
//  Created by Michael A. Crawford on 7/7/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

#import "LegacyBPMCalculator.h"
#import "LegacyBPMCalculatorProxy.h"

@interface LegacyBPMCalculatorProxy ()
{
    LegacyBPMCalculator* bpmCalculator;
}
@end

@implementation LegacyBPMCalculatorProxy

- (instancetype)initWithSize:(NSUInteger)size
{
    self = [super init];
    
    if ( self )
    {
        bpmCalculator = [[LegacyBPMCalculator alloc] initWithSize:size];
    }
    
    return self;
}

- (double)inputSample:(double *)stddev
{
    return [bpmCalculator inputSample:stddev];
}

- (void)reset
{
    return [bpmCalculator reset];
}

@end
