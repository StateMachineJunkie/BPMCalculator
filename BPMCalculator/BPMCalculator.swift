//
//  BPMCalculator.swift
//  BPMCalculator
//
//  Created by Michael A. Crawford on 5/25/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

/// Implementation of a BPM calculator algorithm. The BPMCalculator class keeps a
/// running average or mean for the beets per minute (BPM) based on the period in
/// between input events. The number of entries used to calculat ehte average is
/// determined when the calculator is created.
///
/// Along with the running average for the period, the standard deviation is also
/// calculated in order to indicate how accurate and stable the BPM calculation is.
/// In statistics, the standard deviation is a measure that is used to quanitfy the
/// amount of variation or dispersion of a set of data values. A low standard
/// deviation indicates that the data points tend to be close to the mean of the set,
/// while a high standard deviation indicates that the data points are spread out over
/// a wider range of values.
/// - Author: Michael Crawford
class BPMCalculator: NSObject {
    
    /// This array holds all of the samples use to calculate BPM and STDDEV
    private var buffer: [Double] = []
    
    /// Subscript index used to navigate `buffer`
    private var index: size_t = 0
    
    /// Timestamp for the previous sample
    private var lastTimestamp: UInt64?
    
    /// Maximum number of samples used for BPM and STDDEV calculations. This value
    /// is used to determine the size of `buffer`.
    private let maxSamples: size_t
    
    /// Mach time-base information used to calculate the period between the current
    /// and previous sample. This data is combined with timestamps returned from
    /// invoking `mach_absolute_time()`, this highes resolution time source I could
    /// find on the iOS/MacOS platform.
    private let timebaseInfo: UnsafeMutablePointer<mach_timebase_info_data_t>
    
    init(maxSamples: size_t) {
        self.maxSamples = maxSamples
        let pointer = UnsafeMutablePointer<mach_timebase_info_data_t>.alloc(1)
        mach_timebase_info(&pointer.memory)
        timebaseInfo = pointer
    }
    
    /// Invoke this method periodically. It's timestamp will be added to others and
    /// then used to calculate the current BPM and a new standard deviation.
    /// - returns: A tupple `(Double, Double)` containing the BPM value and the STDDEV
    /// value, in that order.
    func inputSample() -> (Double, Double) {
        var delta: UInt64 = 0
        
        // If the last time-stamp is valid, compute the elapsed time between then and
        // now. IF not, simply return a BPM value of zero since we don't have enough
        // information to compute a real BPM value. In either case, update the time-
        // stamp for the last sample so we can calculate the BPM value on the next
        // invocation.
        if let lastTimestamp = lastTimestamp {
            let now: UInt64 = mach_absolute_time()
            delta = now - lastTimestamp
            self.lastTimestamp = now
        } else {
            lastTimestamp = mach_absolute_time()
        }
        
        // If we have two time-stamps (denoted by the non-zero value of delta) we can
        // compute a BPM value. We can also store it in our history buffer and then
        // use that data to calculate the running average and the standard deviation.
        if delta > 0 {
            let elapsedTime = delta * UInt64(timebaseInfo.memory.numer) / UInt64(timebaseInfo.memory.denom)
            
            if ( buffer.count == index ) {
                buffer.append(Double(elapsedTime) * 1.0e-9)
            } else {
                buffer[index] = Double(elapsedTime) * 1.0e-9
            }
            index += 1
            
            // If we've reached the end of the buffer start filling in samples from
            // the beginning.
            if maxSamples == index {
                index = 0
            }
            
            var meanAccumulator: Double = 0.0
            var varianceAccumulator: Double = 0.0
            var sample: Double = 0.0
            
            // Note that instead of following a strict ring-buffer implementation for
            // processing the samples, I always start my calculations from the begin-
            // ning of the buffer. This won't effect the running-average calculation
            // but I'm no master mathematician so I can't say if it will effect the
            // the standard deviation calculation or not. I suspect it will but, for
            // the purposes of this demo implementation, I don't care. It is close
            // enought. If I were dropping this code into a product I'd look it up to
            // be sure or follow my gut and use a ring buffer. That means tracking the
            // head and the tail of the buffer and always processing the data from
            // one to the other.
            
            // Calculate the running average and standard deviation.
            for i in (0...buffer.count - 1) {
                sample = buffer[i]
                meanAccumulator += sample
                varianceAccumulator += ( sample * sample )
            }
            
            meanAccumulator /= Double(buffer.count)
            varianceAccumulator /= Double(buffer.count)
            varianceAccumulator -= (meanAccumulator * meanAccumulator)
            var stddev = sqrt(varianceAccumulator)
            var bpm = 1.0 / meanAccumulator
            bpm *= 60.0
            stddev *= 60.0
            return (bpm, stddev)
        }
        
        return (0.0, 0.0)
    }
    
    /// Reset the current running calculation of BPM and standard deviation by flush
    /// the internal sample buffer.
    func reset() {
        index = 0
        lastTimestamp = nil
    }
}
