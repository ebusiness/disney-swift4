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
            } else {
                myImageView.image = nil
            }

            if let waitTime = data?.realtime?.waitTime {
                let waitTimeColor = WaitTimeColor(waitTime: waitTime)
                let waitTimeText = NSAttributedString(string: "\(waitTime)",
                    attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
                                 NSAttributedStringKey.foregroundColor: waitTimeColor.value])
                let waitTimeUnit = NSAttributedString(string: localize(for: "minute"),
                                                      attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
                                                                   NSAttributedStringKey.foregroundColor: UIColor.black])
                let fullText = NSMutableAttributedString()
                fullText.append(waitTimeText)
                fullText.append(waitTimeUnit)
                waitTimeLabel.attributedText = fullText
            } else {
                let waitTimeColor = WaitTimeColor(waitTime: 35)
                let waitTimeText = NSAttributedString(string: "--",
                    attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
                                 NSAttributedStringKey.foregroundColor: waitTimeColor.value])
                let waitTimeUnit = NSAttributedString(string: localize(for: "minute"),
                                                      attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
                                                                   NSAttributedStringKey.foregroundColor: UIColor.black])
                let fullText = NSMutableAttributedString()
                fullText.append(waitTimeText)
                fullText.append(waitTimeUnit)
                waitTimeLabel.attributedText = fullText
            }

            if let name = data?.name {
                nameLabel.text = name
            } else {
                nameLabel.text = nil
            }

            if let area = data?.area {
                areaLabel.text = area
            } else {
                areaLabel.text = nil
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

    fileprivate let nameContainer: UIView
    fileprivate let nameLabel: UILabel
    fileprivate let areaLabel: UILabel
    fileprivate let areaIcon: UIView

    override init(frame: CGRect) {
        myImageView = UIImageView(frame: .zero)
        footer = UIView(frame: .zero)
        button = UIButton(type: .custom)

        waitTimeContainer = UIView(frame: .zero)
        waitTimeIcon = UIImageView(image: #imageLiteral(resourceName: "wait_time"))
        waitTimeLabel = UILabel(frame: .zero)
        waitTimeSeperator = UIView(frame: .zero)

        nameContainer = UIView(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        areaLabel = UILabel(frame: .zero)
        areaIcon = UIView(frame: .zero)
        super.init(frame: frame)
        addSubImageView()
        addSubFooter()
        addSubButton()
        addSubWaitTimeContainer()
        addSubNameContainer()
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
                                             attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
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

        waitTimeLabel.textAlignment = .right
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        waitTimeIcon.tintColor = UIColor(red: 166, green: 166, blue: 166)
        container.addSubview(waitTimeIcon)
        container.addSubview(waitTimeLabel)
        waitTimeIcon.translatesAutoresizingMaskIntoConstraints = false
        waitTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        waitTimeIcon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        waitTimeIcon.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        waitTimeIcon.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        waitTimeLabel.leftAnchor.constraint(equalTo: waitTimeIcon.rightAnchor, constant: -5).isActive = true
        waitTimeLabel.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        waitTimeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        waitTimeLabel.widthAnchor.constraint(equalToConstant: 42).isActive = true
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

    private func addSubNameContainer() {
        addSubview(nameContainer)

        nameLabel.font = UIFont.boldSystemFont(ofSize: 10)
        nameContainer.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: nameContainer.leftAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: nameContainer.topAnchor, constant: 7).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: nameContainer.rightAnchor, constant: -12).isActive = true

        areaIcon.backgroundColor = UIColor.red
        areaIcon.layer.cornerRadius = 1
        areaIcon.layer.masksToBounds = true
        nameContainer.addSubview(areaIcon)
        areaIcon.translatesAutoresizingMaskIntoConstraints = false
        areaIcon.leftAnchor.constraint(equalTo: nameContainer.leftAnchor, constant: 12).isActive = true
        areaIcon.bottomAnchor.constraint(equalTo: nameContainer.bottomAnchor, constant: -5).isActive = true
        areaIcon.widthAnchor.constraint(equalToConstant: 2).isActive = true
        areaIcon.heightAnchor.constraint(equalToConstant: 8).isActive = true

        areaLabel.font = UIFont.boldSystemFont(ofSize: 8)
        nameContainer.addSubview(areaLabel)
        areaLabel.translatesAutoresizingMaskIntoConstraints = false
        areaLabel.leftAnchor.constraint(equalTo: areaIcon.rightAnchor, constant: 3).isActive = true
        areaLabel.bottomAnchor.constraint(equalTo: areaIcon.bottomAnchor).isActive = true
    }

    fileprivate func layoutNameContainer() {
        nameContainer.translatesAutoresizingMaskIntoConstraints = false
        nameContainer.leftAnchor.constraint(equalTo: footer.leftAnchor).isActive = true
        nameContainer.rightAnchor.constraint(equalTo: waitTimeContainer.leftAnchor).isActive = true
        nameContainer.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
        nameContainer.bottomAnchor.constraint(equalTo: footer.bottomAnchor).isActive = true
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
        layoutNameContainer()
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
        fastpassLabel.font = UIFont.boldSystemFont(ofSize: 10)
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
        layoutNameContainer()
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

private enum WaitTimeColor {
    case nobody
    case prettyVacant
    case vacant
    case normal
    case littleCrowded
    case crowded
    case prettyCrowded
    case deadly
    init(waitTime: Int) {
        switch waitTime {
        case _ where waitTime < 15:
            self = .nobody
        case 15...24:
            self = .prettyVacant
        case 25...34:
            self = .vacant
        case 35...39:
            self = .normal
        case 40...49:
            self = .littleCrowded
        case 50...59:
            self = .crowded
        case 60...69:
            self = .prettyCrowded
        default:
            self = .deadly
        }
    }
    var value: UIColor {
        switch self {
        case .nobody:
            return UIColor(hex: "4CAF50")
        case .prettyVacant:
            return UIColor(hex: "8BC34A")
        case .vacant:
            return UIColor(hex: "CDDC39")
        case .normal:
            return UIColor(hex: "FFEB3B")
        case .littleCrowded:
            return UIColor(hex: "FFC107")
        case .crowded:
            return UIColor(hex: "FF9800")
        case .prettyCrowded:
            return UIColor(hex: "FF5722")
        case .deadly:
            return UIColor(hex: "F44336")
        }
    }
}
