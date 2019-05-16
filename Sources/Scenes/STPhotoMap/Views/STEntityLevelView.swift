//
//  STEntityLevelView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 17/04/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

public class STEntityLevelView: UIView {
    public struct Model {
        var title: String?
        var image: UIImage?
    }
    
    public var model: Model? {
        didSet {
            DispatchQueue.main.async {
                self.imageView?.image = self.model?.image
                self.titleLabel?.text = self.model?.title
            }
        }
    }
    
    private weak var containerView: UIView!
    private weak var imageView: UIImageView!
    private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    public init(model: Model) {
        super.init(frame: .zero)
        self.model = model
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        DispatchQueue.main.async {
            self.fadeIn()
            
            let duration = STPhotoMapStyle.shared.entityLevelViewModel.showDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(duration), execute: {
                self.dismiss()
            })
        }
    }
    
    public func dismiss() {
        DispatchQueue.main.async {
            self.fadeOut(completion: { (finished) in
                if finished {
                    self.removeFromSuperview()
                }
            })
        }
    }
}

// MARK: - Subviews configuration

extension STEntityLevelView {
    private func setupSubviews() {
        self.setupContainerView()
        self.setupImageView()
        self.setupTitleLabel()
    }
    
    private func setupContainerView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = STPhotoMapStyle.shared.entityLevelViewModel.backgroundColor
        view.layer.cornerRadius = STPhotoMapStyle.shared.entityLevelViewModel.cornerRadius
        view.layer.shadowColor = STPhotoMapStyle.shared.entityLevelViewModel.shadowColor
        view.layer.shadowRadius = STPhotoMapStyle.shared.entityLevelViewModel.shadowRadius
        self.addSubview(view)
        self.containerView = view
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.model?.image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.containerView?.addSubview(imageView)
        self.imageView = imageView
    }
    
    private func setupTitleLabel() {
        let label = UILabel()
        label.text = self.model?.title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = STPhotoMapStyle.shared.entityLevelViewModel.titleColor
        label.font = STPhotoMapStyle.shared.entityLevelViewModel.titleFont
        self.containerView?.addSubview(label)
        self.titleLabel = label
    }
}

// MARK: - Constraints configuration

extension STEntityLevelView {
    private func setupSubviewsConstraints() {
        self.setupContainerViewConstraints()
        self.setupImageViewConstraints()
        self.setupTitleLabelConstraints()
    }
    
    private func setupContainerViewConstraints() {
        self.containerView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.containerView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupImageViewConstraints() {
        let size = CGSize(width: 60, height: 60)
        
        self.imageView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        self.imageView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.imageView?.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30).isActive = true
        self.imageView?.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 60).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -60).isActive = true
        self.imageView?.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
    }
    
    private func setupTitleLabelConstraints() {
        self.titleLabel?.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
        self.titleLabel?.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        self.titleLabel?.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -30).isActive = true
        self.titleLabel?.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        self.titleLabel?.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
    }
}

private extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
