//
//  SeanColor-Extension.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 随机颜色
    ///
    /// - Returns: UIColor
    public class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    /// 获取两个颜色RGB的差值
    ///
    /// - Parameters:
    ///   - firstColor: firstColor
    ///   - secondColor: secondColor
    /// - Returns: (CGFloat, CGFloat, CGFloa
    public class func getRGBDelta(_ firstColor: UIColor, _ secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = secondColor.getRGB()
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    /// 获取颜色的RGB值
    ///
    /// - Returns: (CGFloat, CGFloat, CGFloat)
    public func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = self.cgColor.components else {
            fatalError("保证普通颜色是RGB方式传入")
        }
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}

