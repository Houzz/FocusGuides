//
//  ViewController.swift
//  FocusGuides
//
//  Created by Guy on 9/13/15.
//  Copyright © 2015 Houzz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var leftGuide = UIFocusGuide()
    var rightGuide = UIFocusGuide()
    var topGuide = UIFocusGuide()
    var bottomGuide = UIFocusGuide()
    var pins = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // add pins
        for _ in 0 ..< 10 {
            let pin = PinView(image: UIImage(named: "pin"))
            pin.center = CGPoint(x: CGFloat(arc4random_uniform(UInt32(view.bounds.size.width))), y: CGFloat(arc4random_uniform(UInt32(view.bounds.size.height))))
            view.addSubview(pin)
            pins.append(pin)
        }

        // add focus guides
        view.addLayoutGuide(topGuide)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[guide]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil,
            views: ["guide": topGuide]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide(1)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["guide": topGuide]))

        view.addLayoutGuide(bottomGuide)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[guide]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil,
            views: ["guide": bottomGuide]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[guide(1)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["guide": bottomGuide]))

        view.addLayoutGuide(leftGuide)
       NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil,
            views: ["guide": leftGuide]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[guide(1)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["guide": leftGuide]))

        view.addLayoutGuide(rightGuide)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil,
            views: ["guide": rightGuide]))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[guide(1)]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["guide": rightGuide]))
    }

    override var preferredFocusedView: UIView? {
        return pins.first
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        if let focusedView = UIScreen.mainScreen().focusedView as? PinView {
            if let nextView = findNextViewFromView(focusedView, searchAngle: 0) {
                rightGuide.enabled = true
                rightGuide.preferredFocusedView = nextView
            } else {
                rightGuide.enabled = false
            }

            if let nextView = findNextViewFromView(focusedView, searchAngle: M_PI) {
                leftGuide.enabled = true
                leftGuide.preferredFocusedView = nextView
            } else {
                leftGuide.enabled = false
            }

            if let nextView = findNextViewFromView(focusedView, searchAngle: -M_PI_2) {
                topGuide.enabled = true
                topGuide.preferredFocusedView = nextView
            } else {
                topGuide.enabled = false
            }

            if let nextView = findNextViewFromView(focusedView, searchAngle: M_PI_2) {
                bottomGuide.enabled = true
                bottomGuide.preferredFocusedView = nextView
            } else {
                bottomGuide.enabled = false
            }
        }
    }

    func findNextViewFromView(currentView: UIView, searchAngle: Double) -> UIView? {
        let currentViewCenter = currentView.center
        var foundView: UIView? = nil
        var distanceToFoundView: CGFloat = 0

        for aView in pins {
            if aView == currentView {
                continue
            }
            let location = aView.center
            let difference = CGPoint(x:location.x - currentViewCenter.x, y:location.y - currentViewCenter.y)
            var angle = fmod(Double(atan2(difference.y, difference.x)) - searchAngle, 2 * M_PI)
            if angle > M_PI {
                angle -= 2 * M_PI
            } else if angle < -M_PI {
                angle += 2 * M_PI
            }
            if angle > -M_PI_4 && angle < M_PI_4 {
                // it's in a good angle
                let distance2 = difference.x * difference.x + difference.y * difference.y
                if foundView == nil || distance2 < distanceToFoundView {
                    foundView = aView
                    distanceToFoundView = distance2
                }
            }
        }

        if foundView == nil {
            if searchAngle == 0 || searchAngle == M_PI {
                foundView = findViewAlongX(currentView, positive: searchAngle == 0)
            } else {
                foundView = findViewAlongY(currentView, positive: searchAngle > 0)
            }
        }

        return foundView
    }

    func findViewAlongX(currentView: UIView, positive: Bool) -> UIView? {
        let currentViewCenter = currentView.center
        var foundView: UIView? = nil
        var distanceToFoundView: CGFloat = 99999
        for aView in pins {
            if aView == currentView {
                continue
            }
            let location = aView.center
            let difference = CGPoint(x: location.x - currentViewCenter.x, y: location.y - currentViewCenter.y)
            if ((positive && difference.x > 0) || (!positive && difference.x < 0) && fabs(difference.y) < distanceToFoundView) {
                foundView = aView
                distanceToFoundView = fabs(difference.y)
            }
        }

        return foundView
    }

    func findViewAlongY(currentView: UIView, positive: Bool) -> UIView? {
        let currentViewCenter = currentView.center
        var foundView: UIView? = nil
        var distanceToFoundView: CGFloat = 99999
        for aView in pins {
            if aView == currentView {
                continue
            }
            let location = aView.center
            let difference = CGPoint(x: location.x - currentViewCenter.x, y: location.y - currentViewCenter.y)
            if ((positive && difference.y > 0) || (!positive && difference.y < 0) && fabs(difference.x) < distanceToFoundView) {
                foundView = aView
                distanceToFoundView = fabs(difference.x)
            }
        }

        return foundView
    }

}

