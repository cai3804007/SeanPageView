//
//  SeanPageView.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

public class SeanPageView: UIView {
    // MARK:- 定义属性
    fileprivate var titles : [String]
    fileprivate var style :SeanPageViewStyle
    fileprivate var childVcs:[UIViewController]
    fileprivate var parentVc:UIViewController
    
    fileprivate var titleView :SeanPageTitleView!
    fileprivate var contentView : SeanPageContentView!

    
   public init(frame: CGRect,style:SeanPageViewStyle,childVcs:[UIViewController],titles : [String],parentVc:UIViewController) {
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titles = titles
        super.init(frame: frame)
        configUI()
    }
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SeanPageView {
    // MARK:- 设置界面
    fileprivate func configUI() {
         let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: style.titleHeight)
        titleView = SeanPageTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contenFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
         contentView = SeanPageContentView(frame: contenFrame, childsVc: self.childVcs, parentVc: self.parentVc)
        contentView.delegate = self
//        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        addSubview(contentView)
    }
}

extension SeanPageView : SeanPageContentViewDelegate {
    func contentView(_ contentView: SeanPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    func contentViewEndScroll(_ contentView: SeanPageContentView) {
         titleView.contenViewDidEndScroll()
    }
}

extension SeanPageView : SeanPageTitleViewDelegate {
    
    func titleView(_ titleView: SeanPageTitleView, selectedIndex index: Int) {
        
         contentView.setCurrentIndex(index)
    }
}



























