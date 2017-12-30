//
//  SeanGiftView.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/18.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit


public protocol SeanGiftViewDataSource :class {
   func numberOfSections(_ giftView : SeanGiftView) -> Int
   func collectionView(_ giftView: SeanGiftView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView,giftView: SeanGiftView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public protocol SeanGiftViewDelegate {
     func collectionView(_ giftView: SeanGiftView, didSelectItemAt indexPath: IndexPath)
}



public class SeanGiftView: UIView {
    
    // MARK:- 外部属性
   public var dataSource : SeanGiftViewDataSource?
   public var delegate : SeanGiftViewDelegate?
    
    // MARK:- 数据
    fileprivate var titles : [String]
    fileprivate var style : SeanPageViewStyle
    fileprivate var isTop : Bool
    fileprivate var layout : SeanGiftLayout
    fileprivate var sourceIndex :IndexPath = IndexPath(item: 0, section: 0)
    
    // MARK:- 控件
    fileprivate var collectionView : UICollectionView!
    fileprivate var titleView : SeanPageTitleView!
    fileprivate var pageControl : UIPageControl!

    
   public init(frame: CGRect, titles : [String], style : SeanPageViewStyle, isTitleTop : Bool,layout : SeanGiftLayout) {
        self.titles = titles
        self.style = style
        self.isTop = isTitleTop
        self.layout = layout
        super.init(frame: frame)
        configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
  

}

extension SeanGiftView {
    
    // MARK:- 布局界面
    fileprivate func configUI() {
        // 1.创建titleView
        let titleY = isTop ? 0 :bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = SeanPageTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
         addSubview(titleView)
        
        // 2.创建pageControl
        let pageHeight : CGFloat = 20
        let pageY = isTop ? (bounds.height - pageHeight) : (bounds.height - pageHeight - style.titleHeight)
        let pageFrame = CGRect(x: 0, y: pageY, width: bounds.width, height: pageHeight)
        
        pageControl = UIPageControl(frame: pageFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        addSubview(pageControl)
        pageControl.backgroundColor = UIColor.randomColor()
        
        // 3.创建contentView 
        let collectionY = isTop ? style.titleHeight : 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - style.titleHeight - pageHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.randomColor()
            addSubview(collectionView)
    }
}

// MARK:- 对外暴露方法
extension SeanGiftView {
   public func registerCell(cell : AnyClass?, idenfier : String ){
        collectionView.register(cell, forCellWithReuseIdentifier: idenfier)
    }
   public func registerNib(nib : UINib, idenfier : String){
        collectionView.register(nib, forCellWithReuseIdentifier: idenfier)
    }
}

// MARK:- UICollectionViewDataSource 
extension SeanGiftView : UICollectionViewDataSource {
    //返回每组多少个
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = self.dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0{
            pageControl.numberOfPages = (itemCount - 1) / (layout.clos * layout.rows) + 1
        }
        
      return  itemCount
    }
    //返回cell
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return  self.dataSource!.collectionView(collectionView, giftView: self, cellForItemAt: indexPath)
    }
    //返回多少组
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource!.numberOfSections(self) 
    }
    
}

// MARK:- UICollectionViewDelegate
extension SeanGiftView : UICollectionViewDelegate {
    //点击Cell
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.collectionView(self, didSelectItemAt: indexPath)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    // 结束时判断pageControl的位置
   fileprivate func scrollViewEndScroll() {
        // 1.取出显示在collectionView上面的一个点
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        // 2.判断cell是否显示在collectionView上 取出indexPath
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
    if sourceIndex.section != indexPath.section {
        // 3.1算出每组个数
         let itemCount = self.dataSource?.collectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
        // 3.2修改pageControl的个数
        pageControl.numberOfPages = (itemCount - 1)/(layout.clos * layout.rows) + 1
        
        // 3.3.调整TitleView的位置
        titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndex.section, targetIndex: indexPath.section)
        // 3.4 记录最新的indexPath
        sourceIndex = indexPath
    }
      pageControl.currentPage = indexPath.item / (layout.clos * layout.rows)
    
    }
}

extension SeanGiftView : SeanPageTitleViewDelegate {
    
    func titleView(_ titleView: SeanPageTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
    
}


























