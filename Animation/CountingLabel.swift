//
//  CountingLabel.swift
//  Animation
//
//  Created by anyRTC on 2020/9/23.
//  Copyright © 2020 linshun. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    fileprivate let startValue: Double
    fileprivate var displayLink: CADisplayLink?
    fileprivate let endValue: Double
    fileprivate let animationDuration: Double
    fileprivate let animationStartDate = Date()
    
    init(startValue: Double , endValue:Double,animationDuration: Double ) {
        self.startValue = startValue
        self.endValue = endValue
        self.animationDuration = animationDuration
        super.init(frame:.zero)
        self.backgroundColor = .backgroundColor
        self.textColor = .white
        self.layer.cornerRadius = 5
        self.text = "\(startValue)"
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 18)
        displayLink = CADisplayLink (target: self, selector: #selector(handleUpdate))
        displayLink!.add(to: .main, forMode: .default)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleUpdate() {
        
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        
        if elapsedTime > animationDuration {
            self.text = "\(endValue)"
            // displayLink!.remove(from: .main, forMode: .default)
            displayLink?.invalidate()
            displayLink = nil
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.text = "\(Int(value))"
        }
        
        //        self.countingLabel.text =  "\(startValue)"
        //        startValue += 1
        //
        //        if startValue > endValue
        //        {
        //            startValue = endValue
        //        }
        //        let seconds = Date().timeIntervalSince1970
        //        self.countingLabel.text = "\(seconds)"
        
    }
}
