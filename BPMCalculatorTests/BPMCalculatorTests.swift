//
//  BPMCalculatorTests.swift
//  BPMCalculatorTests
//
//  Created by Michael A. Crawford on 7/8/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

import XCTest
@testable import BPMCalculator

class BPMCalculatorTests: XCTestCase {
    
    // I realize that trying to simulate a signal and then measure it again in
    // this way is flawed but our goal here is to excercise the code enough to
    // find programming errors and to also make sure that we can approximate
    // a correct result, without too much effort.
    
    /// The target beats per minute that we're trying to simulate and measure
    /// is arbitrary.
    static let targetBPM = 120.0
    
    /// We want to select a high enough sample count that we can get the system
    /// into a relatively stable state with regard to cache behavior, timer jitter
    /// etc.
    static let sampleCount = 50
    
    /// Instance under test.
    var bpmCalculator: BPMCalculator?
    
    /// We will signal here when we've input all of the samples
    var sampleExpectation: XCTestExpectation?
    
    /// We estimate the total time required to input the samples based on the
    /// target BPM, the period derived from said BPM and the total number of
    /// samples to be input. Ideally, we would try and measure first to see what
    /// the overhead is for inputting the samples and then subtract that overhead
    /// but this code is not that critical. Thus, I pad the timeout by a reasonable
    /// amount.
    let timeout = (Double(sampleCount) / (targetBPM / 60.0)) * 1.2
    
    /// The delay between samples is calculated based on the number of samples
    /// we need to see in a second in order to generate the required frequency
    /// (targetBPM). The generation and collection of each sample is assumed to
    /// be near instantaneous (from a human standpoint).
    let timeInterval = 1.0 / (targetBPM / 60.0)
    
    override func setUp() {
        super.setUp()
        bpmCalculator = BPMCalculator(maxSamples: 10)
    }
    
    override func tearDown() {
        bpmCalculator = nil
        super.tearDown()
    }
    
    func test() {
        sampleExpectation = expectationWithDescription("Completed sample input")
        XCTAssertNotNil(bpmCalculator)
        bpmCalculator!.reset()

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            for _ in 0..<BPMCalculatorTests.sampleCount {
                _ = self.bpmCalculator!.inputSample()
                NSThread.sleepForTimeInterval(self.timeInterval)
            }
            
            self.sampleExpectation!.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout) { (error) in
            let result = self.bpmCalculator!.inputSample()
            XCTAssertTrue(result.0 > 100.0, "Computed BPM was too low.")
            XCTAssertTrue(result.0 <= 120.0, "Computed BPM was too high!")
            XCTAssertTrue(result.1 > 0.1, "Standard deviation was too low.")
            XCTAssertTrue(result.1 < 2.0, "Standard deviation was too high!")
            print("\(BPMCalculatorTests.sampleCount) samples input with a inter-sample delay of \(self.timeInterval) seconds yielded a BPM value of \(result.0) with a standard deviation of \(result.1).")
        }
    }
    
}
