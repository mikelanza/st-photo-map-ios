//
//  STCarouselOverlayRenderer.swift
//  STSTCarouselMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import MapKit
import STPhotoCore

enum STCarouselOverlayRendererError: LocalizedError {
    case noOverlayPathAvailable
    case noOverlayPointAvailable
    case noImageAvailable
}

class STCarouselOverlayRenderer: MKOverlayRenderer {
    private let carouselOverlay: STCarouselOverlay
    private var carouselOverlayLabel: STCarouselOverlayLabel
    private var carouselOverlayButton: STCarouselOverlayButton
    private var carouselOverlayTutorialLabel: STCarouselOverlayLabel
    
    private var overlayButtonRect: CGRect?
    
    private var visibleMapRect: MKMapRect
    
    private struct Elements {
        var strokeColor: CGColor
        var lineWidth: CGFloat
        var fillColor: CGColor
    }
    
    init(carouselOverlay: STCarouselOverlay, visibleMapRect: MKMapRect) {
        self.carouselOverlay = carouselOverlay
        self.visibleMapRect = visibleMapRect
        self.carouselOverlayLabel = STCarouselOverlayLabel(text: NSString(string: carouselOverlay.model.name))
        self.carouselOverlayButton = STCarouselOverlayButton(text: carouselOverlay.model.entityTitle())
        self.carouselOverlayTutorialLabel = STCarouselOverlayLabel(text: NSString(string: carouselOverlay.model.tutorialText))
        super.init(overlay: carouselOverlay)
    }
    
    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let rect = self.rect(for: self.carouselOverlay.boundingMapRect)
        
        context.saveGState()
        self.shouldDrawOverlayBorder(rect, zoomScale: zoomScale, in: context)
        self.shouldDrawOverlayImage(rect, in: context)
        self.shouldDrawOverlayLabel(rect, zoomScale: zoomScale, in: context)
        self.shouldDrawOverlayTutorialLabel(rect, zoomScale: zoomScale, in: context)
        context.restoreGState()
        
        self.shouldDrawOverlayButton(rect, zoomScale: zoomScale, visibleMapRect: mapRect, in: context)
    }
    
    private func drawRect(_ rect: CGRect, with color: CGColor, in context: CGContext) {
        self.action(context) {
            let rectangle = UIBezierPath(rect: rect)
            context.setFillColor(color)
            context.addPath(rectangle.cgPath)
            context.fillPath()
        }
    }
}

// MARK: - Auxiliary

extension STCarouselOverlayRenderer {
    func reload() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    private func overlayPath() throws -> CGPath {
        if let polyline = self.carouselOverlay.polyline {
            return self.pathForPoints(points: polyline.points(), pointCount: polyline.pointCount)
        } else if let polygon = self.carouselOverlay.polygon {
            return self.pathForPoints(points: polygon.points(), pointCount: polygon.pointCount)
        }
        throw STCarouselOverlayRendererError.noOverlayPathAvailable
    }
    
    private func pathForPoints(points: UnsafeMutablePointer<MKMapPoint>, pointCount: Int) -> CGPath {
        let path: CGMutablePath = CGMutablePath()
        var isPathEmpty: Bool = true
        for i in 0..<pointCount {
            let point = self.point(for: points[i])
            if isPathEmpty {
                path.move(to: point)
                isPathEmpty = false
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
    
    private func setNeedsDisplayInMainThread(_ mapRect: MKMapRect, zoomScale: MKZoomScale) {
        DispatchQueue.main.async {
            self.setNeedsDisplay(mapRect, zoomScale: zoomScale)
        }
    }
    
    private func point(_ rect: CGRect) throws -> CGPoint {
        var points: [CGPoint] = []
        if let polyline = self.carouselOverlay.polyline {
            points = self.points(multipoint: polyline)
        } else if let polygon = self.carouselOverlay.polygon {
            points = self.points(multipoint: polygon)
        }
        return try self.point(points: points, in: rect)
    }
    
    private func mapPoints(multipoint: MKMultiPoint) -> [MKMapPoint] {
        var mapPoints: [MKMapPoint] = []
        let points: UnsafeMutablePointer<MKMapPoint> = multipoint.points()
        for i in 0..<multipoint.pointCount {
            mapPoints.append(points[i])
        }
        return mapPoints
    }
    
    private func points(multipoint: MKMultiPoint) -> [CGPoint] {
        let mapPoints = self.mapPoints(multipoint: multipoint)
        return mapPoints.map({ self.point(for: $0) })
    }
    
    private func point(points: [CGPoint], in rect: CGRect) throws -> CGPoint {
        guard let point = points.first(where: { $0.y == rect.maxY }) else {
            throw STCarouselOverlayRendererError.noOverlayPointAvailable
        }
        return point
    }
    
    private func action(_ context: CGContext, with block: () -> Void) {
        UIGraphicsPushContext(context)
        context.saveGState()
        block()
        context.restoreGState()
        UIGraphicsPopContext()
    }
    
    func didSelectEntityOverlayAtCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return self.carouselOverlay.containsCoordinate(coordinate: coordinate)
    }
    
    func didSelectEntityButtonAtCoordinate(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let point = self.point(for: MKMapPoint(coordinate))
        return self.overlayButtonRect?.contains(point) == true
    }
}

// MARK: - Overlay border

extension STCarouselOverlayRenderer {
    private func shouldDrawOverlayBorder(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) {
        try? self.drawOverlayBorder(rect, zoomScale: zoomScale, in: context)
    }
    
    private func drawOverlayBorder(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) throws {
        let path = try self.overlayPath()
        let elements = Elements(strokeColor: self.carouselOverlay.model.strokeColor.cgColor,
                                lineWidth: self.carouselOverlay.model.lineWidth / zoomScale,
                                fillColor: self.carouselOverlay.model.fillColor.cgColor)
        self.addBorderPath(path, in: context)
        self.styleBorderPath(path, with: elements, in: context)
    }
    
    private func addBorderPath(_ path: CGPath, in context: CGContext) {
        context.addPath(path)
    }
    
    private func styleBorderPath(_ path: CGPath, with elements: Elements, in context: CGContext) {
        context.setStrokeColor(elements.strokeColor)
        context.setLineWidth(elements.lineWidth)
        context.strokePath()
    }
}

// MARK: - Overlay button

extension STCarouselOverlayRenderer {
    private func shouldDrawOverlayButton(_ rect: CGRect, zoomScale: MKZoomScale, visibleMapRect: MKMapRect, in context: CGContext) {
        if self.carouselOverlay.model.shouldDrawEntityButton {
            try? self.drawOverlayButton(rect, zoomScale: zoomScale, visibleMapRect: self.visibleMapRect, in: context)
        }
    }
    
    private func drawOverlayButton(_ rect: CGRect, zoomScale: MKZoomScale, visibleMapRect: MKMapRect, in context: CGContext) throws {
        let point = try self.point(rect)
        self.overlayButtonRect = self.carouselOverlayButton.draw(context, at: point, in: rect, visibleMapRect: visibleMapRect, zoomScale: zoomScale)
    }
}

// MARK: - Overlay title label

extension STCarouselOverlayRenderer {
    private func shouldDrawOverlayLabel(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) {
        if self.carouselOverlay.model.shouldDrawLabel {
            self.drawOverlayLabel(rect, zoomScale: zoomScale, in: context)
        }
    }
    
    private func drawOverlayLabel(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) {
        let location = self.carouselOverlay.model.location
        let radius = self.carouselOverlay.model.radius
        let labelRect = self.rectForLabelLocation(location, radius: radius)
        self.carouselOverlayLabel.draw(context, rect: labelRect, zoomScale: zoomScale)
    }
    
    private func rectForLabelLocation(_ location: STLocation, radius: Double) -> CGRect {
        let centerCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let radius = MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude) * radius
        let centerPoint = self.point(for: MKMapPoint(centerCoordinate))
        let path = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        return path.bounds
    }
}

// MARK: - Overlay tutorial label

extension STCarouselOverlayRenderer {
    private func shouldDrawOverlayTutorialLabel(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) {
        if self.carouselOverlay.model.shouldDrawTutorialLabel {
            try? self.drawOverlayTutorialShadowOverlay(rect, in: context)
            try? self.drawOverlayTutorialLabel(rect, zoomScale: zoomScale, in: context)
        }
    }
    
    private func drawOverlayTutorialShadowOverlay(_ rect: CGRect, in context: CGContext) throws {
        try self.clipTutorialOverlay(context)
        self.drawRect(rect, with: UIColor.black.withAlphaComponent(0.7).cgColor, in: context)
    }
    
    private func clipTutorialOverlay(_ context: CGContext) throws {
        let path = try self.overlayPath()
        
        context.addPath(path)
        context.clip()
    }
    
    private func drawOverlayTutorialLabel(_ rect: CGRect, zoomScale: MKZoomScale, in context: CGContext) throws {
        let location = self.carouselOverlay.model.location
        let radius = self.carouselOverlay.model.radius
        let labelRect = self.rectForLabelLocation(location, radius: radius)
        self.carouselOverlayTutorialLabel.text = NSString(string: self.carouselOverlay.model.tutorialText)
        self.carouselOverlayTutorialLabel.draw(context, rect: labelRect, zoomScale: zoomScale)
    }
}

// MARK: - Overlay image

extension STCarouselOverlayRenderer {
    private func shouldDrawOverlayImage(_ rect: CGRect, in context: CGContext) {
        try? self.drawOverlayImage(rect, in: context)
    }
    
    private func drawOverlayImage(_ rect: CGRect, in context: CGContext) throws {
        guard let image = self.carouselOverlay.model.photoImage else {
            throw STCarouselOverlayRendererError.noImageAvailable
        }
        
        try self.clipImage(context)
        
        self.action(context) {
            var xf: CGFloat = image.size.width / rect.size.width
            var yf: CGFloat = image.size.height / rect.size.height
            let m: CGFloat = min(xf, yf)
            xf /= m
            yf /= m
            context.scaleBy(x: xf, y: yf)
            image.draw(in: rect)
        }
    }
    
    private func clipImage(_ context: CGContext) throws {
        let path = try self.overlayPath()
        
        context.addPath(path)
        context.clip()
    }
}
