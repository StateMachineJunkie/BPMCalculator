//
//  ViewController.swift
//  BPMCalculator
//
//  Created by Michael A. Crawford on 5/25/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let bpmCalculator = BPMCalculator(maxSamples: 10)
    
    private var bpmLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 120, width: 80, height: 22))
        label.text = "BPM:"
        return label
    }()
    
    private var bpmValue: UILabel = {
        UILabel(frame: CGRect(x: 160, y: 120, width: 80, height: 22))
    }()
    
    private var sampleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.frame = CGRect(x: 60, y: 60, width: 200, height: 44)
        button.backgroundColor = .blue
        button.setTitle("Tap me, repeatedly!", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        return button
    }()
    
    private var stddevLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 150, width: 80, height: 22))
        label.text = "STDDEV:"
        return label
    }()
    
    private var stddevValue: UILabel = {
        UILabel(frame: CGRect(x: 160, y: 150, width: 80, height: 22))
    }()
    
    override func loadView() {
        let view = KeyView(with: sample)
        
        view.backgroundColor = .white
        view.addSubview(sampleButton)
        view.addSubview(bpmLabel)
        view.addSubview(bpmValue)
        view.addSubview(stddevLabel)
        view.addSubview(stddevValue)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        sampleButton.addTarget(self, action: #selector(sample), for: .touchUpInside)
    }
    
    @objc func sample(sender: AnyObject) {
        let result = bpmCalculator.inputSample()
        guard result.0 > 0 else { return }
        bpmValue.text = "\(result.0)"
        stddevValue.text = "\(result.1)"
    }
}
