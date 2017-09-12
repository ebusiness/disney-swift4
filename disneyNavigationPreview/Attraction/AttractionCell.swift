//
//  AttractionCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/12.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import AlamofireImage
import UIKit

class AttractionCell: UICollectionViewCell, Localizable {

    var data: Attraction? {
        didSet {
            if let imagePath = data?.images.first, let url = URL(string: imagePath) {
                myImageView.af_setImage(withURL: url)
            }
        }
    }

    let localizeFileName = "Attraction"

    fileprivate let myImageView: UIImageView
    fileprivate let footer: UIView
    fileprivate let button: UIButton

    fileprivate let waitTimeContainer: UIView
    fileprivate let waitTimeIcon: UIImageView
    fileprivate let waitTimeLabel: UILabel
    fileprivate let waitTimeSeperator: UIView

    override init(frame: CGRect) {
        myImageView = UIImageView(frame: .zero)
        footer = UIView(frame: .zero)
        button = UIButton(type: .custom)

        waitTimeContainer = UIView(frame: .zero)
        waitTimeIcon = UIImageView(image: #imageLiteral(resourceName: "wait_time"))
        waitTimeLabel = UILabel(frame: .zero)
        waitTimeSeperator = UIView(frame: .zero)
        super.init(frame: frame)
        addSubImageView()
        addSubFooter()
        addSubButton()
        addSubWaitTimeContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubImageView() {
        myImageView.clipsToBounds = true
        myImageView.contentMode = .scaleAspectFill
        addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func addSubFooter() {
        footer.backgroundColor = UIColor.white
        addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        footer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        footer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    private func addSubButton() {
        button.backgroundColor = UIColor(red: 255, green: 186, blue: 0)
        button.tintColor = UIColor.white
        button.setImage(#imageLiteral(resourceName: "circle_plus"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "circle_plus"), for: .highlighted)
        let buttonTitle = NSAttributedString(string: " " + localize(for: "add to plan"),
                                             attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                                                          NSAttributedStringKey.foregroundColor: UIColor.black])
        button.setAttributedTitle(buttonTitle, for: .normal)
        footer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: footer.rightAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 104).isActive = true
    }

    private func addSubWaitTimeContainer() {
        addSubview(waitTimeContainer)

        waitTimeLabel.backgroundColor = UIColor.yellow
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(waitTimeIcon)
        container.addSubview(waitTimeLabel)
        waitTimeIcon.translatesAutoresizingMaskIntoConstraints = false
        waitTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        waitTimeIcon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        waitTimeIcon.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        waitTimeIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        waitTimeLabel.leftAnchor.constraint(equalTo: waitTimeIcon.rightAnchor).isActive = true
        waitTimeLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        waitTimeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        waitTimeLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        waitTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        waitTimeContainer.addSubview(container)
        container.centerXAnchor.constraint(equalTo: waitTimeContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: waitTimeContainer.centerYAnchor).isActive = true

        waitTimeSeperator.backgroundColor = UIColor(red: 196, green: 196, blue: 196)
        waitTimeContainer.addSubview(waitTimeSeperator)
        waitTimeSeperator.translatesAutoresizingMaskIntoConstraints = false
        waitTimeSeperator.leftAnchor.constraint(equalTo: waitTimeContainer.leftAnchor).isActive = true
        waitTimeSeperator.bottomAnchor.constraint(equalTo: waitTimeContainer.bottomAnchor).isActive = true
        waitTimeSeperator.heightAnchor.constraint(equalToConstant: 19).isActive = true
        waitTimeSeperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }

    fileprivate func layoutWaitTimeContainer() {
        fatalError("layoutWaitTimeContainer() need to be implemented in subclasses!")
    }

}

class AttractionCellFastpass: AttractionCell {

    private let fastpassContainer: UIView
    private let fastpassIcon: UIImageView
    private let fastpassLabel: UILabel
    private let fastpassSeperator: UIView

    override init(frame: CGRect) {
        fastpassContainer = UIView(frame: .zero)
        fastpassIcon = UIImageView(image: #imageLiteral(resourceName: "fastpass_icon"))
        fastpassLabel = UILabel(frame: .zero)
        fastpassSeperator = UIView(frame: .zero)
        super.init(frame: frame)

        addSubFastpassContainer()
        layoutWaitTimeContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubFastpassContainer() {
        footer.addSubview(fastpassContainer)
        fastpassContainer.translatesAutoresizingMaskIntoConstraints = false
        fastpassContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        fastpassContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        fastpassContainer.rightAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        fastpassContainer.widthAnchor.constraint(equalToConstant: 97).isActive = true

        fastpassLabel.text = localize(for: "fastpass")
        fastpassLabel.font = UIFont.systemFont(ofSize: 12)
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(fastpassIcon)
        container.addSubview(fastpassLabel)
        fastpassIcon.translatesAutoresizingMaskIntoConstraints = false
        fastpassLabel.translatesAutoresizingMaskIntoConstraints = false
        fastpassIcon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        fastpassIcon.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        fastpassIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        fastpassLabel.leftAnchor.constraint(equalTo: fastpassIcon.rightAnchor, constant: 4).isActive = true
        fastpassLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        fastpassLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        fastpassContainer.addSubview(container)
        container.centerXAnchor.constraint(equalTo: fastpassContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: fastpassContainer.centerYAnchor).isActive = true

        fastpassSeperator.backgroundColor = UIColor(red: 196, green: 196, blue: 196)
        fastpassContainer.addSubview(fastpassSeperator)
        fastpassSeperator.translatesAutoresizingMaskIntoConstraints = false
        fastpassSeperator.leftAnchor.constraint(equalTo: fastpassContainer.leftAnchor).isActive = true
        fastpassSeperator.bottomAnchor.constraint(equalTo: fastpassContainer.bottomAnchor).isActive = true
        fastpassSeperator.heightAnchor.constraint(equalToConstant: 19).isActive = true
        fastpassSeperator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }

    override func layoutWaitTimeContainer() {
        waitTimeContainer.translatesAutoresizingMaskIntoConstraints = false
        waitTimeContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        waitTimeContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        waitTimeContainer.rightAnchor.constraint(equalTo: fastpassContainer.leftAnchor).isActive = true
        waitTimeContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

}

class AttractionCellNoneFastpass: AttractionCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutWaitTimeContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutWaitTimeContainer() {
        waitTimeContainer.translatesAutoresizingMaskIntoConstraints = false
        waitTimeContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        waitTimeContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
        waitTimeContainer.rightAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        waitTimeContainer.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
