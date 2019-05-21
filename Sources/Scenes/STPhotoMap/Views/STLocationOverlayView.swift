//
//  STLocationOverlayView.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 21/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

protocol STLocationOverlayViewDelegate: NSObjectProtocol {
    func locationOverlayView(view: STLocationOverlayView?, didSelectPhoto photoId: String)
}

class STLocationOverlayView: UIView {
    struct Model {
        var photoId: String
        var title: String?
        var time: String?
        var description: String?
        
        init(photoId: String, title: String?, time: String?, description: String?) {
            self.photoId = photoId
            self.title = title
            self.time = time
            self.description = description
        }
    }
    
    var model: Model {
        didSet {
            DispatchQueue.main.async {
                self.updateSubviews()
            }
        }
    }
    
    weak var delegate: STLocationOverlayViewDelegate?
    
    private weak var labelContainerView: UIStackView!
    private weak var titleLabel: UILabel!
    private weak var timeLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    
    private weak var accessoryView: UIView!
    private weak var accessoryImageView: UIView!
    
    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        self.setupView()
        self.setupSubviews()
        self.setupSubviewsConstraints()
        self.updateSubviews()
        self.setupGestureRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subviews update

extension STLocationOverlayView {
    private func updateSubviews() {
        self.updateDescriptionLabel()
    }
    
    private func updateDescriptionLabel() {
        if let description = self.model.description {
            self.descriptionLabel?.isHidden = description.isEmpty
        } else {
            self.descriptionLabel?.isHidden = true
        }
    }
}

// MARK: - Gesture recognizers

extension STLocationOverlayView {
    private func setupGestureRecognizers() {
        self.setupTapGestureRecognizer()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(STLocationOverlayView.didTouchUpInside))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Actions

extension STLocationOverlayView {
    @objc func didTouchUpInside() {
        self.delegate?.locationOverlayView(view: self, didSelectPhoto: self.model.photoId)
    }
}

// MARK: - Subviews configuration

extension STLocationOverlayView {
    private func setupView() {
        self.layer.borderWidth = 5.0 / UIScreen.main.scale
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    private func setupSubviews() {
        self.setupLabelContainerView()
        self.setupTitleLabel()
        self.setupTimeLabel()
        self.setupDescriptionLabel()
        self.setupAccessoryView()
        self.setupAccessoryImageView()
    }
    
    private func setupLabelContainerView() {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.spacing = 4.0
        self.addSubview(view)
        self.labelContainerView = view
    }
    
    private func setupTitleLabel() {
        let label = self.label()
        label.text = self.model.title
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.blue
        self.labelContainerView?.addArrangedSubview(label)
        self.titleLabel = label
    }
    
    private func setupTimeLabel() {
        let label = self.label()
        label.text = self.model.time
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.darkGray
        self.labelContainerView?.addArrangedSubview(label)
        self.timeLabel = label
    }
    
    private func setupDescriptionLabel() {
        let label = self.label()
        label.text = self.model.description
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.darkGray
        self.labelContainerView?.addArrangedSubview(label)
        self.descriptionLabel = label
    }
    
    private func label() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }
    
    private func setupAccessoryView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        self.addSubview(view)
        self.accessoryView = view
    }
    
    private func setupAccessoryImageView() {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage()
        self.accessoryView?.addSubview(imageView)
        self.accessoryImageView = imageView
    }
}

// MARK: - Subviews constraints configuration

extension STLocationOverlayView {
    private func setupSubviewsConstraints() {
        self.setupLabelContainerViewConstraints()
        self.setupAccessoryViewConstraints()
        self.setupAccessoryImageViewConstraints()
    }
    
    private func setupLabelContainerViewConstraints() {
        self.labelContainerView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.labelContainerView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.labelContainerView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.labelContainerView?.trailingAnchor.constraint(equalTo: self.accessoryView.leadingAnchor, constant: -10).isActive = true
    }
    
    private func setupAccessoryViewConstraints() {
        self.accessoryView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.accessoryView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.accessoryView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupAccessoryImageViewConstraints() {
        self.accessoryImageView?.centerXAnchor.constraint(equalTo: self.accessoryView.centerXAnchor).isActive = true
        self.accessoryImageView?.centerYAnchor.constraint(equalTo: self.accessoryView.centerYAnchor).isActive = true
        self.accessoryImageView?.widthAnchor.constraint(equalTo: self.accessoryImageView.heightAnchor, multiplier: 1.0).isActive = true
        self.accessoryImageView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.accessoryImageView?.leadingAnchor.constraint(equalTo: self.accessoryView.leadingAnchor, constant: 10).isActive = true
        self.accessoryImageView?.trailingAnchor.constraint(equalTo: self.accessoryView.trailingAnchor, constant: -10).isActive = true
    }
}
