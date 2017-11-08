//
//  AttractionOtherCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/06.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class AttractionOtherCell: UICollectionViewCell {
    var payload: AnalysedAttractionDetail.Payload? {
        didSet {
            titleLabel.text = payload?.title
            textLabel.text = payload?.content

            if let type = payload?.type {
                switch type {
                case .appropriateFor:
                    icon.image = #imageLiteral(resourceName: "ic_accessibility_black_32px")
                case .attractionType:
                    icon.image = #imageLiteral(resourceName: "ic_dns_black_32px")
                case .barrierFree:
                    icon.image = #imageLiteral(resourceName: "ic_accessible_black_32px")
                case .capacity:
                    icon.image = #imageLiteral(resourceName: "ic_group_black_32px")
                case .duration:
                    icon.image = #imageLiteral(resourceName: "ic_access_time_black_32px")
                case .fastpassAttraction:
                    icon.image = #imageLiteral(resourceName: "ic_fastpass_32px")
                case .limited:
                    icon.image = #imageLiteral(resourceName: "ic_warning_black_32px")
                }
            }
        }
    }

    fileprivate let icon: UIImageView
    fileprivate let titleLabel: UILabel
    fileprivate let textLabel: UILabel

    override init(frame: CGRect) {
        icon = UIImageView(frame: .zero)
        titleLabel = UILabel()
        textLabel = UILabel()
        super.init(frame: frame)

        backgroundColor = UIColor.white

        addSubIcon()
        addSubTitleLabel()
        addSubTextLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubIcon() {
        icon.backgroundColor = GlobalColor.primaryRed
        icon.contentMode = .center
        icon.tintColor = UIColor.white
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 44).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        icon.layer.cornerRadius = 22
        icon.layer.masksToBounds = true
    }

    private func addSubTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
    }

    private func addSubTextLabel() {
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textColor = GlobalColor.grayText
        textLabel.numberOfLines = 0
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        textLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

    static func autoLayoutSize(payload: AnalysedAttractionDetail.Payload) -> CGSize {
        let width = UIScreen.main.bounds.width - 12 * 2

        let labelWithConstraint = width - 12 * 3 - 44
        let titleHeight = (payload.title as NSString).boundingRect(with: CGSize(width: labelWithConstraint, height: 0),
                                                                   options: .usesLineFragmentOrigin,
                                                                   attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)],
                                                                   context: nil).height
        let contentHeight = (payload.content as NSString).boundingRect(with: CGSize(width: labelWithConstraint, height: 0),
                                                                       options: .usesLineFragmentOrigin,
                                                                       attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)],
                                                                       context: nil).height
        let height = titleHeight + contentHeight + 12 * 2 + 6

        let imageHeight: CGFloat = 44 + 12 * 2
        return CGSize(width: width, height: max(height, imageHeight))
    }
}

class AttractionNoteCell: AttractionOtherCell, Localizable {

    let localizeFileName = "Attraction"

    var detail: AnalysedAttractionDetail? {
        didSet {
            if let detail = detail {
                icon.image = #imageLiteral(resourceName: "ic_sentiment_very_satisfied_black_32px")

                titleLabel.text = localize(for: "Attraction Note")
                let introduction = detail.parent.introductions

                if let introductionhtmlAttributedString = introduction.htmlAttributedString {
                    let mixed = NSMutableAttributedString(attributedString: introductionhtmlAttributedString)
                    let fullRange = NSRange(location: 0, length: mixed.string.count)
                    mixed.addAttribute(.foregroundColor, value: GlobalColor.grayText, range: fullRange)
                    textLabel.attributedText = mixed
                }
            }
        }
    }

    static func autoLayoutSize(detail: AnalysedAttractionDetail) -> CGSize {
        let width = UIScreen.main.bounds.width - 12 * 2

        let labelWithConstraint = width - 12 * 3 - 44
        let titleContent = NSLocalizedString("Attraction Note",
                                             tableName: "Attraction",
                                             comment: "")
        let titleHeight = (titleContent as NSString).boundingRect(with: CGSize(width: labelWithConstraint, height: 0),
                                                                  options: .usesLineFragmentOrigin,
                                                                  attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)],
                                                                  context: nil).height
        let imageHeight: CGFloat = 44 + 12 * 2
        guard let introductionhtmlAttributedString = detail.parent.introductions.htmlAttributedString  else {
            return CGSize(width: width, height: imageHeight)
        }
        let mixed = NSMutableAttributedString(attributedString: introductionhtmlAttributedString)
        let fullRange = NSRange(location: 0, length: mixed.string.count)
        mixed.addAttribute(.foregroundColor, value: GlobalColor.grayText, range: fullRange)
        mixed.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: fullRange)
        let contentHeight = mixed.boundingRect(with: CGSize(width: labelWithConstraint, height: 0),
                                               options: .usesLineFragmentOrigin,
                                               context: nil).height
        let height = titleHeight + contentHeight + 12 * 2 + 6
        return CGSize(width: width, height: max(height, imageHeight))
    }
}
