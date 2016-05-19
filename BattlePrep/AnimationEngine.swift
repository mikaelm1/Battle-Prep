//
//  AnimationEngine.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 5/19/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    static let screenBounds = UIScreen.mainScreen().bounds
    
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(screenBounds.width, CGRectGetMidY(screenBounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-screenBounds.width, CGRectGetMidY(screenBounds))
    }
    
    let animationDelay = 0.8
    
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]!
    
    init(constraints: [NSLayoutConstraint]) {
        for con in constraints {
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenRightPosition.x
        }
        
        self.constraints = constraints
    }
    
    func animateOnScreen(delay: Double?) {
        let d = delay == nil ? animationDelay * Double(NSEC_PER_SEC) : delay! * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        
        dispatch_after(time, dispatch_get_main_queue()) { 
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.constraints[index]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                moveAnim.dynamicsFriction += 10 + CGFloat(index)
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index += 1
            } while index < self.constraints.count
        }
    }
    
    func animateOffScreen(delay: Double?) {
        let d = delay == nil ? animationDelay * Double(NSEC_PER_SEC) : delay! * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.constraints[index]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                moveAnim.dynamicsFriction += 10 + CGFloat(index)
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index += 1
            } while index < self.constraints.count
        }
    }
    
    func animateToPosition(constraint: NSLayoutConstraint, position: CGPoint, completionHandler: ((POPAnimation!, Bool) -> Void)) {
        
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        moveAnim.toValue = NSValue(CGPoint: position)
        moveAnim.springSpeed = 8
        moveAnim.springBounciness = 8
        moveAnim.completionBlock = completionHandler
        constraint.pop_addAnimation(moveAnim, forKey: "animateToPosition")
    }
    
}











