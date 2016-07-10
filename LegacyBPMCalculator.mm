//
//  LegacyBPMCalculator.mm
//  BPMCalculator
//
//  Created by Michael A. Crawford on 7/7/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

#import "BPMCalculator.h"
#import "LegacyBPMCalculator.h"

@interface LegacyBPMCalculator ()
{
    CD::BPMCalculator* bpmCalculator;   // C++ instance
}
@end

@implementation LegacyBPMCalculator

- (instancetype)initWithSize:(NSUInteger)size
{
    self = [super init];
    
    if ( self )
    {
        bpmCalculator = new CD::BPMCalculator(size);
    }
    
    return self;
}

- (double)inputSample:(double *)stdDeviation
{
    double bpm = bpmCalculator->inputSample(*stdDeviation);
    return bpm;
}

- (void)reset
{
    bpmCalculator->reset();
}


@end
