//
//  ViewController.swift
//  SeanPageView
//
//  Created by SeanLink on 12/30/2017.
//  Copyright (c) 2017 SeanLink. All rights reserved.
//

import UIKit
import SeanPageView
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let titles = ["热门","爆笑","全都是人的啊","最新","最热","你看看谁最美呢你看一看啊"]
        let style = SeanPageViewStyle()
        style.isScrollEnable = true
        style.isShowBottomLine = true
        style.isShowCover = true
        style.isNeedHeader = true
        style.headerHeight = 200
        let pageViewFrame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.bounds.height - 64)
        //        let titleView = SeanPageTitleView(frame: titleFrame, titles: titles, style: style)
        //    view.addSubview(titleView)
        
        var childsVc = [ItemTableController]()
        
        for  _ in 0..<titles.count {
            let vc = ItemTableController()
            vc.view.backgroundColor = UIColor.randomColor()
            vc.tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(style.headerHeight, 0, 0, 0)
            childsVc.append(vc)
        }
        
        
        let pageView = SeanPageView(frame: pageViewFrame, style: style, childVcs: childsVc, titles: titles, parentVc: self)
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: style.headerHeight))
        pageView.headerView = headerView
        headerView.backgroundColor = UIColor.randomColor()
        view.addSubview(pageView)
        
        
    }
    
    
    @IBAction func nextBtnClikc(_ sender: Any) {
        
        let gift = GiftController()
        navigationController?.pushViewController(gift, animated: true)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

