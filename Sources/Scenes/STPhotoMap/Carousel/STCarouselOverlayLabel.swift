//
//  STCarouselOverlayLabel.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

class STCarouselOverlayLabel {
    private let maximumFontSize: CGFloat = 12.0
    private let minimumFontSize: CGFloat = 2.0
    private let fontSizeStep: CGFloat = 1
    
    var text: NSString
    
    init(text: NSString) {
        self.text = text
    }
    
    func draw(_ context: CGContext, rect: CGRect, zoomScale: MKZoomScale) {
        UIGraphicsPushContext(context)
        context.saveGState()
        
        var fontSize = self.maximumFontSize
        
        while fontSize >= self.minimumFontSize {
            let attributes = self.textAttributes(fontSize, zoomScale: zoomScale)
            let size = self.textSize(attributes)
            
            if size.width > rect.size.width {
                fontSize -= self.fontSizeStep
            } else {
                let drawingRect = CGRect(x: rect.origin.x + floor((rect.size.width - size.width) / 2),
                                         y: rect.origin.y + floor((rect.size.height - size.height) / 2),
                                         width: size.width,
                                         height: size.height)
                self.text.draw(in: drawingRect, withAttributes: attributes)
                break
            }
        }
        
        context.restoreGState()
        UIGraphicsPopContext()
    }
    
    private func textSize(_ attributes: [NSAttributedString.Key : Any]) -> CGSize {
        return self.text.size(withAttributes: attributes)
    }
    
    private func textAttributes(_ fontSize: CGFloat, zoomScale: MKZoomScale) -> [NSAttributedString.Key : Any] {
        let roadWidth: CGFloat = MKRoadWidthAtZoomScale(zoomScale)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byClipping
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize * roadWidth),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -1.0,
            NSAttributedString.Key.strokeColor : UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ]
    }
}
