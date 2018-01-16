//
//  SeanPageViewStyle.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

public class SeanPageViewStyle {
    /// 是否是滚动的Title
    public  var isScrollEnable : Bool = false
    /// 普通Title颜色
    public var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    public var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    /// Title字体大小
    public var font : UIFont = UIFont.systemFont(ofSize: 15.0)
    /// 滚动Title的字体间距
    public var titleMargin : CGFloat = 20
    /// title的高度
    public  var titleHeight : CGFloat = 44
    
    /// 是否显示底部滚动条
    public var isShowBottomLine : Bool = false
    /// 底部滚动条的颜色
    public  var bottomLineColor : UIColor = UIColor.orange
    /// 底部滚动条的高度
    public  var bottomLineH : CGFloat = 2
    
    
    /// 是否进行缩放
    public var isNeedScale : Bool = false
    public  var scaleRange : CGFloat = 1.2
    //是否需要头视图
    public var isNeedHeader: Bool = false
    //头视图高度
    public var headerHeight: CGFloat = 0.0
    /// 是否显示遮盖
    public  var isShowCover : Bool = false
    /// 遮盖背景颜色
    public var coverBgColor : UIColor = UIColor.lightGray
    /// 文字&遮盖间隙
    public var coverMargin : CGFloat = 5
    /// 遮盖的高度
    public var coverH : CGFloat = 25
    /// 设置圆角大小
    public var coverRadius : CGFloat = 12
    
    required public init() {
        
    }
    
    
}
