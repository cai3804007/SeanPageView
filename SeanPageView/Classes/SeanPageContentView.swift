//
//  SeanPageContentView.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

private let kContentCell = "kContentCell"

@objc protocol SeanPageContentViewDelegate : class {
    func contentView(_ contentView : SeanPageContentView,progress : CGFloat, sourceIndex : Int, targetIndex : Int)
    
    @objc optional func contentViewEndScroll(_ contentView : SeanPageContentView)
}




class SeanPageContentView: UIView {

    // MARK:- 对外属性
    weak var delegate : SeanPageContentViewDelegate?
    
    // MARK:- 定义属性
    fileprivate var childsVc : [UIViewController]
    fileprivate weak var parentVc : UIViewController!
    //是否是点击
    fileprivate var isClick : Bool = false
    fileprivate var startOffSexX :CGFloat = 0
    
    // MARK:- 控件属性
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.bounds.size
        layout.scrollDirection = .horizontal
        
        let  collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    
    
    
    init(frame: CGRect,childsVc : [UIViewController], parentVc : UIViewController) {
        self.childsVc = childsVc
        self.parentVc = parentVc
       super.init(frame: frame)
        configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
// MARK:- 设置界面
extension SeanPageContentView {
    func configUI() {
        // 1.将所有的控制器添加到父控制器中
        for vc in childsVc{
            parentVc.addChildViewController(vc)
        }
        
        // 2.添加UICollectionView
        addSubview(collectionView)
    }
}



// MARK:- 设置UICollectionView的数据源
extension SeanPageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childsVc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCell, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        // 2.添加view
        let childVc = self.childsVc[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK:- 设置UICollectionView的代理
extension SeanPageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         isClick = false
         startOffSexX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isClick { return }
        // 1.定义获取的数据
        var progress : CGFloat = 0
        //之前Index
        var sourceIndex : Int = 0
        //目标的Index
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        if currentOffsetX > startOffSexX {  //左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX/scrollViewW)
//             progress = (currentOffsetX - startOffSexX)/scrollViewW 有问题
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX/scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childsVc.count {
                targetIndex = childsVc.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffSexX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{ //右滑
            // 1.计算progress
           progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW))
//            progress = (startOffSexX - currentOffsetX)/scrollViewW   有问题
            
            // 2.计算tagetIndex
            targetIndex = Int(currentOffsetX/scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childsVc.count {
                sourceIndex = childsVc.count - 1
            }
        }
        
        // 3.将数据传递给代理
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         delegate?.contentViewEndScroll?(self)
        scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll?(self)
        }else{
            // 不禁止会有bug
            scrollView.isScrollEnabled = false
        }
    }
}

// MARK:- 暴露在外的方法
extension SeanPageContentView {
    func setCurrentIndex (_ currentIndex : Int){
        isClick = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}























