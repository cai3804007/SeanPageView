//
//  SeanPageTitleView.swift
//  SeanPageView
//
//  Created by  luoht on 2017/6/15.
//  Copyright © 2017年 Sean. All rights reserved.
//

import UIKit


// MARK:- 协议部分

protocol SeanPageTitleViewDelegate : class {
    func titleView (_ titleView : SeanPageTitleView , selectedIndex index : Int)
}



class SeanPageTitleView: UIView {
    
    // MARK:- 对外属性
    weak var delegate : SeanPageTitleViewDelegate?
    
    // MARK:- 控件
    fileprivate lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView (frame: self.bounds);
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    //底部分割线
    fileprivate lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let h : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return bottomLine
    }()
    //底部滚动条
    fileprivate lazy var lineView : UIView = {
        let lineView = UIView()
        lineView.backgroundColor = self.style.bottomLineColor
        return lineView
    }()
    //遮盖物
    fileprivate lazy var coverView : UIView = {
       let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        return coverView
    }()
    
    // MARK:- 数组
    fileprivate var titles : [String]
    fileprivate var titleLabels = [UILabel]()
    // MARK:- 自定义属性
    fileprivate var style :SeanPageViewStyle
    fileprivate var currentIndex : Int = 0
    
    // MARK:- 计算属性
    fileprivate lazy var normalRGB : (r : CGFloat, g : CGFloat, b :CGFloat) = self.getRGB(self.style.normalColor)
     fileprivate lazy var selectedRGB : (r : CGFloat, g : CGFloat, b :CGFloat) = self.getRGB(self.style.selectedColor)

    init(frame: CGRect,titles:[String],style:SeanPageViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        addSubview(scrollView)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- 创建控件
extension SeanPageTitleView {
    
    func configUI (){
        // 1.添加Scrollview
        addSubview(scrollView)
        
        // 2.添加底部分割线
        addSubview(bottomLine)
        
        // 3.设置所有的标题Label
        creatLabel()
        
        // 4.设置Label的位置
        setLabelLocation()
        
        // 5.设置底部的滚动条
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        // 6.设置遮盖的View
        if style.isShowCover {
            setupCoverView()
        }
    }
    
   fileprivate func creatLabel (){
        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title;
            label.font = style.font
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.tag = index
            
            let tap = UITapGestureRecognizer(target: self, action:  #selector(titleLabelClick(tap:)))
            
            label.addGestureRecognizer(tap)
            
            titleLabels.append(label)
            
            scrollView.addSubview(label)
        }
    }

   fileprivate func setLabelLocation (){
        var titleX :CGFloat = 0.0
        let titleY :CGFloat = 0.0
        var titleW :CGFloat = 0.0
        let titleH :CGFloat = style.titleHeight
        let count = titleLabels.count
        for (index,label) in titleLabels.enumerated(){
            if style.isScrollEnable {
                let size = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:style.font], context: nil).size
                titleW = size.width
                if index==0 {
                    titleX = style.titleMargin * 0.5
                }else{
                    let leftLabel = titleLabels[index-1]
                    titleX = leftLabel.frame.maxX + style.titleMargin
                }
            }else{
                titleW = frame.width/CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            // 放大的代码
            if index == 0 {
                let scale = style.isNeedScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        //设置scrollView的ContenSize
        if style.isScrollEnable {
            let lastLabel = titleLabels.last
            scrollView.contentSize = CGSize(width: (lastLabel?.frame.maxX)! + style.titleMargin * 0.5, height: 0)
        }
    }
    
   fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = (titleLabels.first?.frame)!
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = bounds.height - style.bottomLineH
    }
    
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels.first!
        var coverW = firstLabel.frame.width + style.coverMargin * 2
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
    
        if style.isScrollEnable {
             coverX -= style.coverMargin
            coverW += style.coverMargin
        }
        coverView.frame = CGRect(x: coverW, y: coverY, width: coverW, height: coverH)
        coverView.center = firstLabel.center
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK:- 事件处理
extension SeanPageTitleView {
    
    @objc func titleLabelClick (tap : UITapGestureRecognizer){
        // 0.获取点击的label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 1.如果和之前是同一个 直接return
        if currentLabel.tag == currentIndex {return}
        
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换颜色
        oldLabel.textColor = style.normalColor
        currentLabel.textColor = style.selectedColor
        
        // 3.保存下标
        currentIndex = currentLabel.tag
        
        // 5.通知代理
        self.delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 6. 设置居中显示
        contenViewDidEndScroll()
        
        // 7.调整线的显示
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.width
            })
        }
        
        // 8.调整比例
        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform.init(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        // 9.遮盖物调整
        if style.isShowCover {
              UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.size.width = currentLabel.frame.width + self.style.coverMargin * 2
                self.coverView.center = currentLabel.center
              })
        }
    }
    
  
    
}


// MARK:- 对外暴露的方法
extension SeanPageTitleView {
    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int,targetIndex : Int){
        // 1.取出sourceIndex和targetIndex
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.颜色的渐变
        // 2.1 取出变化的范围
        let colorDelta = UIColor.getRGBDelta(style.selectedColor, style.normalColor)
        
        // 3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - colorDelta.0 * progress, g: selectedRGB.1 - colorDelta.1 * progress, b: selectedRGB.2 - colorDelta.2 * progress)
        
        // 3.2 变化targetIndex
        targetLabel.textColor = UIColor(r: normalRGB.0 + colorDelta.0 * progress, g: normalRGB.1 + colorDelta.1 * progress, b: normalRGB.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        // 5.计算滚动范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 6.放大的比例
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta * progress, y: style.scaleRange - scaleDelta * progress)
            
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta * progress, y: 1.0 + scaleDelta * progress)
        }
        
        // 7.计算遮盖物移动
        if style.isShowCover {
             coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }

    func getRGB(_ color : UIColor ) -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = color.cgColor.components else {
            fatalError("保证普通颜色是RGB方式传入")
        }
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
     
    
    
    func contenViewDidEndScroll() {
       // 0.如果不需要滚动
        guard style.isScrollEnable else {  return  }
        
        // 1.获取目标的label
        let targetLabel = titleLabels[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffSet = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffSet {
            offSetX = maxOffSet
        }
        scrollView.setContentOffset(CGPoint(x: offSetX, y:0), animated: true)
       
        
    }
    
    
    
    
}
























