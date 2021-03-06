//
//  ViewController.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/29.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import CircleProgressButton
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0

        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController : UIViewController {
    private let button = CircleProgressButton()
    override func loadView() {
        view.backgroundColor = .white

        button.backgroundColor = UIColor(hex: 0x333333)
        button.defaultImage = UIImage(named: "state0")!
        button.inProgressImage = UIImage(named: "state1")!
        button.suspendedImage = UIImage(named: "state2")!
        button.completedImage = UIImage(named: "completed")!
        button.inProgressStrokeColor = UIColor(hex: 0x51C300)
        button.suspendedStrokeColor = UIColor(hex: 0x99C377)
        button.completedStrokeColor = UIColor(hex: 0x51C300)
        button.isDebugEnabled = true
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    private var token: CircleProgressButton.DisposeToken?
    private var isExecutionStopped: Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        token = button.onTap { state in
             switch state {
             case .inProgress:
                print("suspend")
                self.isExecutionStopped = true
                self.button.suspend()
             case .completed:
                print("delete")
                self.button.reset()
             case .default:
                print("start")
                self.button.resume()
                self.isExecutionStopped = false
                self.updatePeriodically()
             case .suspended:
                print("resume")
                self.button.resume()
                self.isExecutionStopped = false
                self.updatePeriodically()
             }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.dispose()
    }

    private func updatePeriodically(_ after: TimeInterval = 0.05) {
        guard !isExecutionStopped else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after) {
            if self.button.progress < 99 {
                self.button.progress += 1.0
                self.updatePeriodically()
            } else {
                self.button.progress += 1.0
                self.button.complete()
            }
        }
    }
}
