//
//  IndicatorView.swift
//  biary
//
//  Created by 이창현 on 29/06/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import UIKit

class IndicatorView: UIView {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var label: UILabel = UILabel()
    
    init(uiView: UIView) {
        super.init(frame: CGRect.zero)
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.3)
        container.isHidden = true
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(r: 68, g: 68, b: 68, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.isHidden = true
        
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.style =
            UIActivityIndicatorView.Style.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        
        label.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        label.center = loadingView.center
        label.text = "아아ㅓ마ㅣㅏㅇ러ㅣㅏㅓㅏㅣ러ㅏㅣㅇ라ㅓㅣㅁㅇㄴ러ㅣㅏ머ㅣㅏ"
        label.textColor = UIColor.white
        
        loadingView.addSubview(actInd)
        loadingView.insertSubview(label, aboveSubview: actInd)
        container.addSubview(loadingView)
        
        uiView.addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        container.isHidden = false
        loadingView.isHidden = false
        actInd.startAnimating()
    }
    
    func stop() {
        container.isHidden = true
        loadingView.isHidden = true
        actInd.stopAnimating()
    }
    
    func updateTextView(text: String) {
        label.text = text
    }
}
