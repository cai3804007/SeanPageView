//
//  SeanPageView.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

public class SeanPageView: UIScrollView {
    // MARK:- 定义属性
    fileprivate var titles : [String]
    fileprivate var style :SeanPageViewStyle
    fileprivate var childVcs:[UIViewController]
    fileprivate var parentVc:UIViewController
    fileprivate var titleView :SeanPageTitleView!
    fileprivate var contentView : SeanPageContentView!

    fileprivate var lastOffsetY: CGFloat = 0
    //使用头部
    fileprivate var currentTableView: UITableView?

    public var headerView:UIView?{
        didSet{
            configHeader()
        }
    }
    
   public init(frame: CGRect,style:SeanPageViewStyle,childVcs:[UIViewController],titles : [String],parentVc:UIViewController) {
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titles = titles
        super.init(frame: frame)
        configUI()
    }

    fileprivate func configHeader(){
        guard let header = self.headerView else {return}
        self.addSubview(header)
        for vc in self.childVcs {
            guard let tableView = vc.value(forKey: "tableView") as? UITableView else {return }
            tableView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.RawValue(UInt8(NSKeyValueObservingOptions.new.rawValue) | UInt8(NSKeyValueObservingOptions.old.rawValue))), context: nil)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(header.frame.height, 0, 0, 0)
            let view = UIView.init(frame: header.bounds)
            tableView.tableHeaderView = view
            titleView.frame.origin.y = header.frame.height
        }
         self.currentTableView = self.childVcs[0].value(forKey: "tableView") as? UITableView
        self.bringSubview(toFront: self.titleView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,let tableView = object as? UITableView else {return}
        if (self.currentTableView != tableView) {
            return
        }
        if keyPath != "contentOffset"{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }else{
            let offsetY = tableView.contentOffset.y
            self.lastOffsetY = offsetY
            if offsetY >= 0 && offsetY <= style.headerHeight{
                self.headerView?.frame = CGRect(x: 0, y: 0 - offsetY, width: self.frame.width, height: style.headerHeight)
                self.titleView.frame = CGRect(x: 0, y: style.headerHeight - offsetY, width: self.frame.width, height: style.titleHeight)
            }else if offsetY < 0 {
                self.headerView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: style.headerHeight)
                self.titleView.frame = CGRect(x: 0, y: style.headerHeight, width: self.frame.width, height: style.titleHeight)
            }else if offsetY > style.headerHeight{
                self.headerView?.frame = CGRect(x: 0, y: -style.headerHeight, width: self.frame.width, height: style.headerHeight)
                self.titleView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: style.titleHeight)
            }
        }
    }
}

extension SeanPageView {
    // MARK:- 设置界面
    fileprivate func configUI() {
         let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: style.titleHeight)
        titleView = SeanPageTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.white
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
        if style.isNeedHeader {
            chooseItemForIndex(self.titleView.currentIndex)
        }
    }
}

extension SeanPageView : SeanPageTitleViewDelegate {
    
    func titleView(_ titleView: SeanPageTitleView, selectedIndex index: Int) {
         contentView.setCurrentIndex(index)
        if style.isNeedHeader{
            chooseItemForIndex(index)
        }
    }
}
//滑动过后tableheader 偏移距离
extension SeanPageView{
    func chooseItemForIndex(_ index:NSInteger){
        self.currentTableView = self.childVcs[index].value(forKey: "tableView") as? UITableView
         for vc in self.childVcs {
            guard let tableView = vc.value(forKey: "tableView") as? UITableView else {return }
            if self.lastOffsetY >= 0 && self.lastOffsetY <= style.headerHeight{
                tableView.setContentOffset(CGPoint(x: 0, y: self.lastOffsetY), animated: false)
            }else if self.lastOffsetY < 0{
                 tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }else if self.lastOffsetY > style.headerHeight {
                var offsetY:CGFloat = 0
                if tableView.contentOffset.y > style.headerHeight{
                    offsetY = tableView.contentOffset.y - style.headerHeight
                }
                 tableView.setContentOffset(CGPoint(x: 0, y: style.headerHeight + offsetY), animated: false)
            }
        }
    }

}


























