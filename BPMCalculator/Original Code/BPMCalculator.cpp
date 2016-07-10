/*******************************************************************************
*  BPMCalculator.cpp
*
*  Purpose: Implementation of a BPM calculation algorithm.  The BPMCalculator
*			class keeps a running average for the BPM based on the period in
*			between input events.  The number of entries used to calculate the
*			average is determined when the calculator is created.
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

#include <math.h>
#include <memory.h>

#include "BPMCalculator.h"

namespace CD
{
	/***************************************************************************
    * Function:     BPMCalculator
    *
    * Description:  Constructor; makes the BPM calculator ready use by caller.
	*
    * Arguments:    maxSamples - The maximum number of samples used to calculate
    *                            the average BPM.
    *
    * Return value: None
    *
    ***************************************************************************/
    BPMCalculator::BPMCalculator(size_t maxSamples) :
		buffer_(0),
		index_(0),
		lastInputSampleTimestamp_(0L),
		maxSamples_(maxSamples)
	{
		buffer_ = new double[maxSamples];
		memset(&buffer_[0], 0, maxSamples * sizeof(double));
        mach_timebase_info(&timebaseInfo);
    }

	/***************************************************************************
    * Function:     ~BPMCalculator
    *
    * Description:  Destructor; releases all allocated resources used by the
	*				given instance of BPMCalculator.
	*
    * Arguments:    None
    *
    * Return value: None
    *
    ***************************************************************************/
	BPMCalculator::~BPMCalculator()
	{
		delete [] buffer_;
	}
    
	/***************************************************************************
    * Function:     inputSample
    *
    * Description:  Addes the given sample to the set and then uses it in
	*				calculating a running average agains all the samples in the
	*				set.
	*
    * Arguments:    stddev - The standard deviation of the returned BPM value.
    *                        This is an output value designed to give the caller
    *                        information regarding the spread of the samples
    *                        used to calculate BPM.  This lets the caller know
    *                        how reliable the return value is.  I recommend that
    *                        the returned BPM and standard deviation be ignored
    *                        until at least maxSamples have been provided by the
    *                        caller.
    *
    * Return value: double value that is the computed BPM. 
    *
    ***************************************************************************/
	double
	BPMCalculator::inputSample(double& stddev)
	{
    	uint64_t delta = 0;
   		// 
		// If the last time-stamp is valid compute the elapsed time between then
		// and now.  If not, simply return a BPM value of zero since we don't
		// have enough information to compute the BPM value.  In either case,
		// update the time stamp for the last sample so we can calculate the
		// BPM value on the next invocation.
		//
		if ( lastInputSampleTimestamp_ )
		{
			uint64_t now = mach_absolute_time();
			delta = now - lastInputSampleTimestamp_;
			lastInputSampleTimestamp_ = now;
		}
		else
		{
			lastInputSampleTimestamp_ = mach_absolute_time();
		}
   		// 
		// If we have two time-stamps (denoted by the existence of delta) we can
		// compute a BPM value.  We can also store it in our history buffer and
		// then use that data to calculate the running average.
		//
		if ( delta )
		{
            uint64_t elapsedTime = delta * timebaseInfo.numer / timebaseInfo.denom;
			buffer_[index_++] = double((elapsedTime + 0.0) * 1.0e-9);

			if ( maxSamples_ == index_ )
			{
				index_ = 0;
			}

            // Calculate the running average and the standard deviation.
			double meanAccumulator = 0.0;
            double varianceAccumulator = 0.0;
            double sample = 0.0;
			int divisor = 0;

			for ( size_t i = 0; i < maxSamples_; ++i )
			{
				divisor++;
                sample = buffer_[i];
				meanAccumulator += sample;
                varianceAccumulator += ( sample * sample );
			}

			meanAccumulator /= divisor;
            varianceAccumulator /= divisor;
            varianceAccumulator -= (meanAccumulator * meanAccumulator);
            stddev = sqrt(varianceAccumulator);
			double bpm = 1.0 / meanAccumulator;
			bpm *= 60.0;
            stddev *= 60.0;
			return bpm;
		}

		return 0.0;
	}
    
	/***************************************************************************
    * Function:     reset
    *
    * Description:  Reset the calculator's internal state so that all history is
    *               lost and it can be used to calculate the BPM value and stan-
    *               dard deviation for a new series of samples.
	*
    * Arguments:    None
    *
    * Return value: None 
    *
    ***************************************************************************/
    void
    BPMCalculator::reset()
    {
        index_ = 0;
        lastInputSampleTimestamp_ = 0L;
        memset(&buffer_[0], 0, maxSamples_ * sizeof(double));
    }
}
