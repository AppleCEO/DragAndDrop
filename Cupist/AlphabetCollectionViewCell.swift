//
//  AlphabetCollectionViewCell.swift
//  Cupist
//
//  Created by joon-ho kil on 2020/03/29.
//  Copyright © 2020 joon-ho kil. All rights reserved.
//

import UIKit

class AlphabetCollectionViewCell: UICollectionViewCell {
  static let ID = "AlphabetCollectionViewCell"
    
  let textLabel = UILabel()
  let orderLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = .black
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    label.font = .systemFont(ofSize: 15)
    label.textAlignment = .center
    label.isHidden = true
    return label
  }()
    
  override init(frame: CGRect) {
    super.init(frame:frame)

    self.addSubview(self.textLabel)
    self.addSubview(self.orderLabel)
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false
    let centerXConst = self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    let centerYConst = self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    NSLayoutConstraint.activate([centerXConst, centerYConst])
    self.orderLabel.translatesAutoresizingMaskIntoConstraints = false
    let topConst = self.orderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3)
    let trailingConst = self.orderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3)
    let heightConst = self.orderLabel.heightAnchor.constraint(equalToConstant: 20)
    let widthConst = self.orderLabel.widthAnchor.constraint(equalToConstant: 20)
    NSLayoutConstraint.activate([topConst, trailingConst, heightConst, widthConst])
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func awakeFromNib() {
      super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    textLabel.text = nil
  }
}
