//
//  CustomSegmentView.swift
//  test4
//
//  Created by Высоцкий Андрей on 12/18/19.
//  Copyright © 2019 Высоцкий Андрей. All rights reserved.
//

import Foundation
import UIKit

class CustomSegmentView: UIView {
    
    var didSelectItem: ((Int) -> ())?
    
    var elements = [""]
    
    var collectionView: UICollectionView!
    var cellTextFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    var unselectedCellTextColor = UIColor.hexStringToUIColor(hex: "#5e7198")
    var selectedCellTextColor = UIColor.white
    var cellHorizontalInset: CGFloat = 20
    
    var didSelectItemClosure: ((Int) -> ())?
    
    lazy var selectedBackView: UIView = {
        let indexPath = IndexPath(row: self.selectedIndex, section: 0)
        let firstCellFrame = self.collectionView(self.collectionView, cellForItemAt: indexPath).frame
        let view = GradientView(frame: CGRect.zero)
        view.startColor = UIColor.hexStringToUIColor(hex: "#0053ff")
        view.endColor = UIColor.hexStringToUIColor(hex: "#008bff")
        view.horizontalMode = true
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 14
        return view
    }()
    
    var selectedIndex = 0 {
        didSet {
            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
            guard let cellFrame = collectionView.cellForItem(at: indexPath)?.frame else {return}
            let oldFrame = self.selectedBackView.frame
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.3, options: .curveEaseInOut,
                           animations: {
                            self.selectedBackView.frame = CGRect(x: cellFrame.origin.x,
                                                                 y: oldFrame.origin.y,
                                                                 width: cellFrame.size.width,
                                                                 height: oldFrame.height)
            }, completion: nil)
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        self.collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        self.collectionView.register(CustomSegmentViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        
        self.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.addConstraintsStickSuperviewTo(edges: [.top, .bottom, .left, .right])
        
        self.collectionView.addSubview(self.selectedBackView)
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let indexPath = IndexPath(row: self.selectedIndex, section: 0)
        let selectedCellFrame = self.collectionView(self.collectionView, cellForItemAt: indexPath).frame
        let frame = CGRect(x: selectedCellFrame.origin.x,
                                        y: 44 / 2 - 28 / 2,
                                        width: selectedCellFrame.size.width,
                                        height: 28)
        self.selectedBackView.frame = frame
    }
    
}

extension CustomSegmentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomSegmentViewCell else {fatalError()}
        cell.textLabel.font = self.cellTextFont
        if indexPath.row == self.selectedIndex {
            cell.textLabel.textColor = self.selectedCellTextColor
        } else {
            cell.textLabel.textColor = self.unselectedCellTextColor
        }
        cell.layer.zPosition = 1
        cell.textLabel.text = "\(self.elements[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemClosure?(indexPath.row)
        self.selectedIndex = indexPath.row
        self.didSelectItem?(indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = self.elements[indexPath.row]
        let textSize = element.size(withAttributes: [NSAttributedString.Key.font: self.cellTextFont])
        return CGSize(width: textSize.width + self.cellHorizontalInset * 2, height: 44)
    }
    
}

class CustomSegmentViewCell: UICollectionViewCell {

    var textLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.textLabel)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            NSLayoutConstraint(item: self.textLabel, attribute: .centerX, relatedBy: .equal,
                               toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.textLabel, attribute: .centerY, relatedBy: .equal,
                               toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
    }
    
}
