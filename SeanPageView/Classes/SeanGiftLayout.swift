//
//  SeanGiftLayout.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/18.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit

public class SeanGiftLayout: UICollectionViewFlowLayout {
    //一行几个
   public var clos : Int = 4
    //有几行
   public var rows : Int = 2
    
   public var prePageCount : Int = 0
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate var maxWidth : CGFloat = 0
}

extension SeanGiftLayout {
    override public func prepare() {
        // 3.获取组数
        let sectionCount = collectionView!.numberOfSections
        // 4.获取每组有多少个Item
        prePageCount = 0
        self.cellAttrs.removeAll()
        for i in 0..<sectionCount {
            // 4.1一组的个数
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                // 4.2 创建对应的indexPath
                let indexPath = IndexPath(item: j, section: i)
                // 4.3根据indexPath获取相对应的UICollectionViewLayoutAttributes
                let attr = self.layoutAttributesForItem(at: indexPath)
                
                cellAttrs.append(attr!)
            }
            prePageCount += (itemCount - 1) / (clos * rows) + 1
        }
        // 5.计算最大Y值
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension SeanGiftLayout {
    // 返回所有的布局属性
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    //返回单独cell的布局
    override  public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 0.计算item的高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(clos - 1))/CGFloat(clos)
        // 2.计算item的宽度
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1))/CGFloat(rows)
        // 4.3根据创建的indexPath创建 UICollectionViewLayoutAttributes
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath  )
        // 4.4计算j在该组的第几页
        let page = indexPath.item / (clos * rows )
        // 4.5 计算j在该组的第几个
        let index = indexPath.item % (clos * rows)
        // 4.6 计算在该组的第几行
        let sectionLine = index / clos
        // 4.7 计算在该行的第几个
        let lineNumber = index % clos
        
        let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(sectionLine)
        
        let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(lineNumber)
        attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        return attr
    }
}

extension SeanGiftLayout {
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}



























