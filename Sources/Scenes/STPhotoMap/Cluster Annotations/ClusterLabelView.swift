//
//  ClusterLabelView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 Streetography. All rights reserved.
//

import UIKit

protocol ClusterLabelViewDelegate: NSObjectProtocol {
    func clusterLabelView(view: ClusterLabelView?, didSelect button: UIButton?)
}

class ClusterLabelView: UIView {
    private let cornerRadius: CGFloat = 12
    private let width: CGFloat = 60
    private let height: CGFloat = 60
    
    private weak var contentView: UIView!
    private weak var label: UILabel!
    private weak var button: UIButton!
    
    weak var delegate: ClusterLabelViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCount(count: Int) {
        self.label?.text = String(count)
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
}

// MARK: - Subviews configuration

extension ClusterLabelView {
    private func setupSubviews() {
        self.setupContentView()
        self.setupCountLabel()
        self.setupButton()
    }
    
    private func setupContentView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = self.cornerRadius
        view.backgroundColor = UIColor(red: 53/255, green: 61/255, blue: 75/255, alpha: 1)
        self.addSubview(view)
        self.contentView = view
    }
    
    private func setupCountLabel() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        self.contentView?.addSubview(label)
        self.label = label
    }
    
    private func setupButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(ClusterLabelView.touchUpInsideClusterButton), for: .touchUpInside)
        button.layer.cornerRadius = self.cornerRadius
        self.contentView?.addSubview(button)
        self.button = button
    }
}

// MARK: - Actions

extension ClusterLabelView {
    @objc func touchUpInsideClusterButton() {
        self.delegate?.clusterLabelView(view: self, didSelect: self.button)
    }
}

// MARK: - Subviews constraints configuration

extension ClusterLabelView {
    private func setupSubviewsConstraints() {
        self.setupContentViewConstraints()
        self.setupCountLabelConstraints()
        self.setupButtonConstraints()
    }
    
    private func setupContentViewConstraints() {
        self.contentView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView?.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        self.contentView?.heightAnchor.constraint(equalToConstant: self.height).isActive = true
    }
    
    private func setupCountLabelConstraints() {
        self.label?.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.label?.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    private func setupButtonConstraints() {
        self.button?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.button?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.button?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.button?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
}
