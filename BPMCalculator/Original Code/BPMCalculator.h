/*******************************************************************************
*  BPMCalculator.h
*
*  Purpose: Interface definition for BPMCalculator class.  This class keeps a
*			running average for the BPM based on the period in between input
*			events.  The number of entries used to calculate the average is de-
*			termmined when the calculator is instantiated.
*
*  $File$
*  $Author$
*  $Revision$
*  $Change$
*  $DateTime$
*
* Copyright (c) 2009-2011 Crawford Design Engineering, LLC.
*
*******************************************************************************/

#ifndef __BPM_CALCULATOR_H__
#define __BPM_CALCULATOR_H__

#include <mach/mach_time.h>

#include "stdlib.h"

namespace CD
{
	// ------------------------------
	// BPMCalculator class definition
	// ------------------------------
    class BPMCalculator
    {
    public:
        BPMCalculator(size_t maxSamples);
		~BPMCalculator(void);

		double inputSample(double& stddev);
        void reset(void);

    private:
		// disallow the following methods
        BPMCalculator(void);
		BPMCalculator(BPMCalculator const&);
		BPMCalculator& operator=(BPMCalculator const&);
        
		double* buffer_;
		size_t index_;
		uint64_t lastInputSampleTimestamp_;
		size_t const maxSamples_;
        mach_timebase_info_data_t timebaseInfo;
    };
}

#endif  /* __BPM_CALCULATOR_H__ */
