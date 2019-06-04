//
//  STCarouselOverlayButton.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import MapKit

class STCarouselOverlayButton {
    private let fontSize: CGFloat = 8.0
    
    let text: NSString
    
    init(text: NSString) {
        self.text = text
    }
    
    init(text: String) {
        self.text = NSString(string: text)
    }
    
    func draw(_ context: CGContext, at point: CGPoint, in rect: CGRect, visibleMapRect: MKMapRect, zoomScale: MKZoomScale) -> CGRect {
        let textFontSize = self.fontSize
        let textRect = self.textRect(point, fontSize: textFontSize, zoomScale: zoomScale)
        let accessoryRect = self.accessoryRect(textRect)
        let accessoryCircleRect = self.accessoryCircleRect(accessoryRect)
        let containerRect = self.containerRect(textRect, accessoryRect: accessoryRect, fontSize: textFontSize, zoomScale: zoomScale)
        let accessoryArrowPath = self.accessoryArrowPath(accessoryCircleRect)
        
        self.drawContainer(containerRect, in: context)
        self.drawText(textRect, fontSize: textFontSize, zoomScale: zoomScale, in: context)
        self.drawAccessoryOval(accessoryCircleRect, in: context)
        self.drawAccessoryArrow(accessoryArrowPath, in: context)
        
        return containerRect
    }
    
    private func action(_ context: CGContext, with block: () -> Void) {
        UIGraphicsPushContext(context)
        context.saveGState()
        block()
        context.restoreGState()
        UIGraphicsPopContext()
    }
}

// MARK: - Text

extension STCarouselOverlayButton {
    private func drawText(_ rect: CGRect, fontSize: CGFloat, zoomScale: MKZoomScale, in context: CGContext) {
        self.action(context) {
            self.text.draw(in: rect, withAttributes: self.textAttributes(fontSize, zoomScale: zoomScale))
        }
    }
    
    private func textBoundsSize(_ fontSize: CGFloat, _ zoomScale: MKZoomScale) -> CGSize {
        let attributes = self.textAttributes(fontSize, zoomScale: zoomScale)
        return self.textSize(attributes)
    }
    
    private func textRect(_ center: CGPoint, fontSize: CGFloat, zoomScale: MKZoomScale) -> CGRect {
        let size = self.textBoundsSize(fontSize, zoomScale)
        return CGRect(origin: center, size: size)
    }
    
    private func textSize(_ attributes: [NSAttributedString.Key : Any]) -> CGSize {
        return self.text.size(withAttributes: attributes)
    }
    
    private func textPadding(_ attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let text: NSString = "X"
        return text.size(withAttributes: attributes).width
    }
    
    private func textAttributes(_ fontSize: CGFloat, zoomScale: MKZoomScale) -> [NSAttributedString.Key : Any] {
        let scaledFontSize = self.scaledFontSize(fontSize: fontSize, zoomScale: zoomScale)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.lineBreakMode = .byTruncatingTail
        return [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: scaledFontSize),
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.paragraphStyle : paragraphStyle
        ]
    }
    
    private func scaledFontSize(fontSize: CGFloat, zoomScale: MKZoomScale) -> CGFloat {
        let roadWidth = MKRoadWidthAtZoomScale(zoomScale)
        let ratioZoomScale = 1 / zoomScale
        
        let scale: CGFloat
        switch ratioZoomScale {
            case pow(2, 0): scale = 0.3; break
            case pow(2, 1): scale = 0.3; break
            case pow(2, 2): scale = 0.3; break
            case pow(2, 3): scale = 0.3; break
            case pow(2, 4): scale = 0.3; break
            case pow(2, 5): scale = 0.4; break
            case pow(2, 6): scale = 0.5; break
            case pow(2, 7): scale = 0.7; break
            case pow(2, 8): scale = 0.9; break
            case pow(2, 9): scale = 0.9; break
            case pow(2, 10): scale = 1.2; break
            case pow(2, 11): scale = 1.2; break
            case pow(2, 12): scale = 1.2; break
            case pow(2, 13): scale = 1.2; break
            case pow(2, 14): scale = 1.5; break
            case pow(2, 15)...: scale = 1.5; break
            default: scale = 1; break
        }
        return fontSize * roadWidth * scale
    }
}

// MARK: - Accessory

extension STCarouselOverlayButton {
    private func accessoryRect(_ textRect: CGRect) -> CGRect {
        return CGRect(x: textRect.maxX,
                      y: textRect.minY,
                      width: textRect.size.height,
                      height: textRect.size.height)
    }
    
    private func accessoryCircleRect(_ accessoryRect: CGRect) -> CGRect {
        let width = 2 * accessoryRect.size.width / 3
        let height = 2 * accessoryRect.size.height / 3
        return CGRect(x: accessoryRect.midX - (width / 2),
                      y: accessoryRect.midY - (height / 2),
                      width: width,
                      height: height)
    }
    
    private func drawAccessoryOval(_ rect: CGRect, in context: CGContext) {
        self.action(context) {
            let path = UIBezierPath(ovalIn: rect)
            UIColor.white.setFill()
            path.fill()
        }
    }
    
    private func drawAccessoryArrow(_ path: UIBezierPath, in context: CGContext) {
        self.action(context) {
            let color = UIColor(red: 0.171, green: 0.672, blue: 0.980, alpha: 1)
            color.setFill()
            path.fill()
        }
    }
    
    private func accessoryArrowPath(_ rect: CGRect) -> UIBezierPath {
        let width = rect.size.width
        let halfWidth = width / 2
        let quarterWidth = halfWidth / 2
        let eighthWidth = quarterWidth / 2
        
        let height = rect.size.height
        let halfHeight = height / 2
        let quarterHeight = halfHeight / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX + eighthWidth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - eighthWidth, y: rect.midY - quarterHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - quarterHeight))
        path.addLine(to: CGPoint(x: rect.midX + quarterWidth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + quarterHeight))
        path.addLine(to: CGPoint(x: rect.midX - eighthWidth, y: rect.midY + quarterHeight))
        path.addLine(to: CGPoint(x: rect.midX + eighthWidth, y: rect.midY))
        path.close()
        
        return path
    }
}

// MARK: - Outer container

extension STCarouselOverlayButton {
    private func drawContainer(_ rect: CGRect, in context: CGContext) {
        self.action(context) {
            let color = UIColor(red: 0.171, green: 0.672, blue: 0.980, alpha: 1)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height / 2)
            color.setFill()
            path.fill()
        }
    }
    
    private func containerRect(_ textRect: CGRect, accessoryRect: CGRect, fontSize: CGFloat, zoomScale: MKZoomScale) -> CGRect {
        let padding: CGFloat = self.textPadding(self.textAttributes(fontSize, zoomScale: zoomScale))
        let width = textRect.size.width + accessoryRect.size.width + padding
        let height = textRect.size.height
        return CGRect(x: textRect.origin.x - padding,
                      y: textRect.origin.y,
                      width: width,
                      height: height)
    }
}
