//
//  GiftController.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/18.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit
import SeanPageView
class GiftController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.randomColor()
        self.automaticallyAdjustsScrollViewInsets = false
        let titles = ["土豪","热门","专属","常见"]
        let style = SeanPageViewStyle()
        style.isShowBottomLine = true
        
        let layout = SeanGiftLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.clos = 8
        layout.rows = 3
        
        let gitFrame = CGRect(x: 50, y: 100, width: view.bounds.width - 100, height: 300)
      let giftView = SeanGiftView(frame: gitFrame, titles: titles, style: style, isTitleTop: true, layout: layout)
        giftView.dataSource = self
        giftView.registerCell(cell: UICollectionViewCell.self, idenfier: "cell")
        giftView.delegate = self
        view.addSubview(giftView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GiftController : SeanGiftViewDataSource {
    
    func numberOfSections(_ collection: SeanGiftView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: SeanGiftView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 33
        }else if section == 1{
            return 50
        }else {
            return 80
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, giftView: SeanGiftView ,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}

extension GiftController : SeanGiftViewDelegate {
    
    func collectionView(_ giftView: SeanGiftView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item,indexPath.section)
    }
    
    
}






















