//
//  MultiplePhotoCalloutView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit

protocol MultiplePhotoCalloutViewDelegate: NSObjectProtocol {
    func multiplePhotoCalloutView(view: MultiplePhotoCalloutView?, didSelect photoImageView: PhotoImageView?, at index: Int)
}

class MultiplePhotoCalloutView: UIView {
    private let photoIds: [String]
    private let count: Int
    
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 80
    let itemHeight: CGFloat = 80
    
    weak var contentView: UIView!
    
    weak var clusterLabelView: ClusterLabelView!
    var photoImageViews: [PhotoImageView] = []
    var photoLines: [UIBezierPath] = []
    
    weak var anchorView: UIView!
    
    weak var delegate: MultiplePhotoCalloutViewDelegate?
    
    init(photoIds: [String]) {
        self.photoIds = photoIds
        self.count = photoIds.count
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let contentViewPoint = self.convert(point, to: self.contentView)
        return self.contentView.hitTest(contentViewPoint, with: event)
    }
    
    func add(to view: UIView) {
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func getIndex(for photoId: String) -> Int? {
        return self.photoIds.firstIndex(where: { $0 == photoId })
    }
}

// MARK: - Photo image view delegate

extension MultiplePhotoCalloutView: PhotoImageViewDelegate {
    func photoImageView(view: PhotoImageView?, didSelect button: UIButton?) {
        guard let view = view, let index = self.photoImageViews.firstIndex(of: view) else { return }
        self.contentView?.bringSubviewToFront(view)
        self.delegate?.multiplePhotoCalloutView(view: self, didSelect: view, at: index)
    }
}

// MARK: - Draw rect

extension MultiplePhotoCalloutView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor(red: 53/255, green: 61/255, blue: 75/255, alpha: 1).setStroke()
        for path in self.photoLines {
            path.stroke()
        }
    }
    
    private func drawingElements() -> (startingRadians: Double, deltaRadians: Double, radius: CGFloat) {
        let count: Double = Double(self.count)
        let totalRadians = Measurement(value: 360, unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value
        let deltaRadians: Double = totalRadians / count
        let startingRadians: Double = Measurement(value: 90, unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value
        
        let radius: CGFloat
        if count <= 7 {
            radius = 80
        } else {
            radius = 100
        }
        
        return (startingRadians, deltaRadians, radius)
    }
}

// MARK: - Layout subviews

extension MultiplePhotoCalloutView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addPhotoLines()
    }
    
    func addPhotoLines() {
        self.photoLines.removeAll()
        
        let elements = self.drawingElements()
        let startingRadians = elements.startingRadians
        let deltaRadians = elements.deltaRadians
        let radius = elements.radius
        let offset: CGFloat = 12
        
        for i in 0..<self.count {
            let radiansDouble = (Double(i) * deltaRadians) + startingRadians
            let radians: CGFloat = CGFloat(radiansDouble)
            let start = CGPoint(x: self.contentView.center.x + (offset * cos(radians)), y: self.contentView.center.y + (offset * sin(radians)))
            let end = CGPoint(x: start.x + (radius * cos(radians)), y: start.y + (radius * sin(radians)))
            let path = UIBezierPath()
            path.lineWidth = 2.0 / UIScreen.main.scale
            path.move(to: start)
            path.addLine(to: end)
            self.photoLines.append(path)
        }
        
        self.setNeedsDisplay()
    }
}

// MARK: - Update subviews

extension MultiplePhotoCalloutView {
    public func setImage(photoId: String, image: UIImage?) {
        guard let index = self.getIndex(for: photoId) else { return }
        self.photoImageViews[index].setImage(image: image)
    }
    
    public func setIsLoading(photoId: String, isLoading: Bool) {
        guard let index = self.getIndex(for: photoId) else { return }
        self.photoImageViews[index].setLoading(loading: isLoading)
    }
    
    public func setIsSelected(photoId: String, isSelected: Bool) {
        guard let index = self.getIndex(for: photoId) else { return }
        self.photoImageViews[index].setSelected(selected: isSelected)
    }
}

// MARK: - Subviews

extension MultiplePhotoCalloutView {
    private func setupSubviews() {
        self.setupContentView()
        self.setupAnchorView()
        self.setupClusterLabelView()
        self.setupPhotoImageViews()
    }
    
    private func setupContentView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.contentView = view
    }
    
    private func setupAnchorView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        self.contentView?.addSubview(view)
        self.anchorView = view
    }
    
    private func setupClusterLabelView() {
        let view = ClusterLabelView()
        view.setCount(count: self.count)
        view.alpha = 0.5
        self.contentView.addSubview(view)
        self.clusterLabelView = view
    }
    
    private func setupPhotoImageViews() {
        for _ in 0..<self.count {
            let photoImageView = PhotoImageView()
            photoImageView.delegate = self
            photoImageView.translatesAutoresizingMaskIntoConstraints = false
            photoImageView.clipsToBounds = true
            self.contentView.addSubview(photoImageView)
            self.photoImageViews.append(photoImageView)
        }
    }
}

// MARK: - Subviews constraints

extension MultiplePhotoCalloutView {
    private func setupSubviewsConstraints() {
        self.setupContentViewConstraints()
        self.setupAnchorViewConstraints()
        self.setupClusterLabelViewConstraints()
        self.setupPhotoImageViewsConstraints()
    }
    
    private func setupContentViewConstraints() {
        self.contentView?.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
        self.contentView?.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor).isActive = true
        self.contentView?.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
        self.contentView?.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor).isActive = true
        self.contentView?.widthAnchor.constraint(greaterThanOrEqualTo: self.clusterLabelView.widthAnchor, multiplier: 1.0).isActive = true
        self.contentView?.heightAnchor.constraint(greaterThanOrEqualTo: self.clusterLabelView.heightAnchor, multiplier: 1.0).isActive = true
        
        let elements = self.drawingElements()
        let radius = elements.radius
        self.contentView?.topAnchor.constraint(greaterThanOrEqualTo: self.anchorView.topAnchor, constant: radius).isActive = true
        self.contentView?.bottomAnchor.constraint(greaterThanOrEqualTo: self.anchorView.bottomAnchor, constant: radius).isActive = true
        if self.count > 2 {
            self.contentView?.leadingAnchor.constraint(greaterThanOrEqualTo: self.anchorView.leadingAnchor, constant: radius).isActive = true
            self.contentView?.trailingAnchor.constraint(greaterThanOrEqualTo: self.anchorView.trailingAnchor, constant: radius).isActive = true
        }
        
        self.contentView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.contentView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupAnchorViewConstraints() {
        self.anchorView?.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.anchorView?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.anchorView?.widthAnchor.constraint(equalToConstant: self.itemWidth).isActive = true
        self.anchorView?.heightAnchor.constraint(equalToConstant: self.itemHeight).isActive = true
    }
    
    func setupClusterLabelViewConstraints() {
        self.clusterLabelView?.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.clusterLabelView?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    func setupPhotoImageViewsConstraints() {
        let elements = self.drawingElements()
        let startingRadians = elements.startingRadians
        let deltaRadians = elements.deltaRadians
        let radius = elements.radius
        
        for (index, photoImageView) in self.photoImageViews.enumerated() {
            photoImageView.widthAnchor.constraint(equalToConstant: self.itemWidth).isActive = true
            photoImageView.heightAnchor.constraint(equalToConstant: self.itemHeight).isActive = true
            
            let radiansDouble = (Double(index) * deltaRadians) + startingRadians
            let radians: CGFloat = CGFloat(radiansDouble)
            photoImageView.centerXAnchor.constraint(equalTo: self.anchorView.centerXAnchor, constant: radius * cos(radians)).isActive = true
            photoImageView.centerYAnchor.constraint(equalTo: self.anchorView.centerYAnchor, constant: radius * sin(radians)).isActive = true
        }
    }
}
