//
//  AttrLabel.swift
//  AttrLabel
//
//  Created by ENUUI on 2017/8/6.
//  Copyright © 2017年 FUHUI. All rights reserved.
//

import UIKit

public class AttrLabel: UILabel {
    var alText: String? {
        didSet {
            if alText != nil {
                creatAttrText(alText!)
            }
        }
    }
}

extension AttrLabel {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let idx = touchAt(touch.preciseLocation(in: self))
            print(idx)
        }
        
    }
}
fileprivate let ALNotFond = -1
extension AttrLabel {
    fileprivate func creatAttrText(_ txt: String) {
        guard txt.characters.count > 0 else { return }
        
        
        let mAttrText = NSMutableAttributedString(string: txt)
        mAttrText.addAttributes([NSForegroundColorAttributeName: UIColor.black], range: NSMakeRange(0, txt.characters.count))
        mAttrText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)], range: NSMakeRange(0, txt.characters.count))
        
        self.attributedText = mAttrText
    }
    
    fileprivate func touchAt(_ point: CGPoint) -> CFIndex {
        var idx = ALNotFond
        
        var p = point
        
        // 初始化framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        
        // 创建path
        let path = CGMutablePath()
        path.addRect(self.bounds)
        
        // 绘制frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        // 获得CTLine数组
        let lines = CTFrameGetLines(frame)
        
        // 获得CTLine数组
        let numberOfLines = CFArrayGetCount(lines)
        
        // 获取每一行的origin
        var origins = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: numberOfLines)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        for i in 0..<numberOfLines {
            // 获取对应行的origin
            let origin = origins[i]
            // 获取每一行
            let line = CFArrayGetValueAtIndex(lines, i)
            let lineRef = unsafeBitCast(line, to: CTLine.self)
            
            
            // 获取每行的rect
            var ascent: CGFloat = 0.0, descent: CGFloat = 0.0, leading: CGFloat = 0.0
            let w = CGFloat(CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading))
            
            
            // 计算每行相对于label的y和maxy
            let style = self.attributedText?.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil)
            
            var lineSpace : CGFloat = 0.0
            
            if (style != nil) {
                lineSpace = (style as! NSParagraphStyle).lineSpacing
            }
            let lineH = ascent + fabs(descent) + leading
            let textH = lineH * CGFloat(numberOfLines) + lineSpace * CGFloat(numberOfLines - 1)
            let textY = (bounds.height - textH) * 0.5
            let lineY = textY + CGFloat(i) * (lineH + lineSpace)
            let maxY: CGFloat = lineY + lineH
            
            if p.y > maxY {
                break // 点击位置不在行中
            }
            
            if p.y >= lineY {
                p = CGPoint(x: p.x, y: maxY - p.y)
                if p.x >= origin.x && point.x < w + origin.x {
                    // 点击点相对行origin的位置
                    let relativePoint = CGPoint(x: p.x - origin.x, y: 0)
                    idx = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                    
                    break
                }
            }
            
        }
        return idx
    }
}
