//
//  swiftSVG.swift
//  biary
//
//  Created by 이창현 on 26/02/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import UIKit
import SwiftSVG

extension UIButton
{
    func setSvgImgFnc(svgImjFileNameVar: String, ClrVar: UIColor)
    {
        
        setImage((getSvgImgFnc(svgImjFileNameVar: svgImjFileNameVar, ClrVar : ClrVar)), for: .normal)
    }
}

func getSvgImgFnc(svgImjFileNameVar: String, ClrVar: UIColor) -> UIImage
{
    let svgURL = Bundle.main.url(forResource: svgImjFileNameVar, withExtension: "svg")
    let svgVyuVar = UIView(SVGURL: svgURL!)
    
    /* The width, height and viewPort are set to 100
     
     <svg xmlns="http://www.w3.org/2000/svg"
     width="100%" height="100%"
     viewBox="0 0 100 100">
     
     So we need to set UIView Rect also same
     */
    
    svgVyuVar.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    for svgVyuLyrIdx in svgVyuVar.layer.sublayers!
    {
        for subSvgVyuLyrIdx in svgVyuLyrIdx.sublayers!
        {
            
            if (subSvgVyuLyrIdx.isKind(of: CAShapeLayer.self))
            {
                let SvgShpLyrIdx = subSvgVyuLyrIdx as? CAShapeLayer
                SvgShpLyrIdx!.fillColor = ClrVar.cgColor
            }
        }
    }
    return svgVyuVar.getImgFromVyuFnc()
}

extension UIView
{
    func getImgFromVyuFnc() -> UIImage
    {
        UIGraphicsBeginImageContext(self.frame.size)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image!
    }
}
