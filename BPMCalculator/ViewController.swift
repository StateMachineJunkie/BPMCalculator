//
//  ViewController.swift
//  BPMCalculator
//
//  Created by Michael A. Crawford on 5/25/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bpmCalculator = BPMCalculator(maxSamples: 10)
    var BPMLabel: UILabel?
    var BPMValue: UILabel?
    var sampleButton: UIButton?
    var STDDEVLabel: UILabel?
    var STDDEVValue: UILabel?
    
    override func loadView() {
        // view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        view.backgroundColor = UIColor.whiteColor()
        
        // sample-button
        sampleButton = UIButton(type: .DetailDisclosure)
        sampleButton!.frame = CGRect(x: 60, y: 60, width: 200, height: 44)
        sampleButton!.backgroundColor = UIColor.whiteColor()
        view.addSubview(sampleButton!)
        
        // BPM display
        BPMLabel = UILabel(frame: CGRect(x: 60, y: 120, width: 80, height: 22))
        view.addSubview(BPMLabel!)
        
        BPMValue = UILabel(frame: CGRect(x: 160, y: 120, width: 80, height: 22))
        view.addSubview(BPMValue!)
        
        // STDDEV display
        STDDEVLabel = UILabel(frame: CGRect(x: 60, y: 150, width: 80, height: 22))
        view.addSubview(STDDEVLabel!)
        
        STDDEVValue = UILabel(frame: CGRect(x: 160, y: 150, width: 80, height: 22))
        view.addSubview(STDDEVValue!)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        guard let BPMLabel = BPMLabel,
            //            let sampleButton = sampleButton,
            let STDDEVLabel = STDDEVLabel else { return }
        BPMLabel.text = "BPM:"
        sampleButton!.addTarget(self, action: #selector(sample(_:)), forControlEvents: .TouchUpInside)
        //sampleButton.titleLabel!.text = "Tap Me!"
        STDDEVLabel.text = "STDDEV:"
    }
    
    func sample(sender: AnyObject) {
        let result = bpmCalculator.inputSample()
        guard let BPMValue = BPMValue,
            let STDDEVValue = STDDEVValue where result.0 > 0 else { return }
        BPMValue.text = "\(result.0)"
        STDDEVValue.text = "\(result.1)"
    }
}

