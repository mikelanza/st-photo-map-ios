//
//  PhotoImageView.swift
//  STPhotoMap
//
//  Created by Dimitri Strauneanu on 16/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import UIKit

protocol PhotoImageViewDelegate: NSObjectProtocol {
    func photoImageView(view: PhotoImageView?, didSelect button: UIButton?)
}

class PhotoImageView: UIView {
    private let cornerRadius: CGFloat = 8
    
    private weak var imageView: UIImageView?
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var button: UIButton!
    
    weak var delegate: PhotoImageViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
        self.setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage?) {
        self.imageView?.image = image
    }
    
    func setLoading(loading: Bool) {
        if loading {
            self.activityIndicatorView?.startAnimating()
            self.activityIndicatorView?.isHidden = false
        } else {
            self.activityIndicatorView?.isHidden = true
            self.activityIndicatorView?.stopAnimating()
        }
    }
    
    func setSelected(selected: Bool) {
        if selected {
            self.backgroundColor = UIColor(red: 73/255, green: 175/255, blue: 253/255, alpha: 1.0)
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}

// MARK: - Subviews configuration

extension PhotoImageView {
    private func setupSubviews() {
        self.setupContentView()
        self.setupImageView()
        self.setupActivityIndicatorView()
        self.setupButton()
    }
    
    private func setupContentView() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.cornerRadius
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.cornerRadius
        imageView.backgroundColor = UIColor(red: 53/255, green: 61/255, blue: 75/255, alpha: 1)
        self.addSubview(imageView)
        self.imageView = imageView
    }
    
    private func setupActivityIndicatorView() {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = UIColor.white
        self.addSubview(view)
        self.activityIndicatorView = view
    }
    
    private func setupButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(PhotoImageView.touchUpInsidePhotoButton), for: .touchUpInside)
        button.layer.cornerRadius = self.cornerRadius
        button.backgroundColor = UIColor.clear
        self.addSubview(button)
        self.button = button
    }
}

// MARK: - Actions

extension PhotoImageView {
    @objc func touchUpInsidePhotoButton() {
        self.delegate?.photoImageView(view: self, didSelect: self.button)
    }
}

// MARK: - Subviews constraints configuration

extension PhotoImageView {
    private func setupSubviewsConstraints() {
        self.setupImageViewConstraints()
        self.setupActivityIndicatorViewConstraints()
        self.setupButtonConstraints()
    }
    
    private func setupImageViewConstraints() {
        let padding: CGFloat = 4
        self.imageView?.topAnchor.constraint(equalTo: self.topAnchor, constant: padding).isActive = true
        self.imageView?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding).isActive = true
        self.imageView?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding).isActive = true
        self.imageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding).isActive = true
    }
    
    private func setupActivityIndicatorViewConstraints() {
        self.activityIndicatorView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicatorView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupButtonConstraints() {
        self.button?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.button?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.button?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.button?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
