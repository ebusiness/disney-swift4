//
//  TimelineCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/09.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class TimeLineBlackCell: UICollectionReusableView {

    let timeLabel: UILabel
    let lineView: UIView

    override init(frame: CGRect) {
        timeLabel = UILabel(frame: .zero)
        lineView = UIView(frame: .zero)
        super.init(frame: frame)

        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubLabel()
        addSubLine()
    }

    private func addSubLabel() {
        timeLabel.text = "10:00"
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor(white: 0.631, alpha: 1)
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.rightAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func addSubLine() {
        lineView.backgroundColor = UIColor(white: 0.631, alpha: 1)
        addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineView.leftAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
    }

}

class TimeLineWhiteCell: UICollectionViewCell {

    let titleLabel: UILabel
    let ribbon: UIView
    var event: AnalysedTimeline.Event? {
        didSet {
            if let event = event {
                tintColor = event.tintColor
                titleLabel.text = event.name
            }
        }
    }
    override var tintColor: UIColor! {
        didSet {
            ribbon.backgroundColor = tintColor
            backgroundColor = UIColor(baseColor: tintColor, alpha: 0.33)
            titleLabel.textColor = tintColor
        }
    }

    override init(frame: CGRect) {
        titleLabel = UILabel(frame: .zero)
        ribbon = UIView(frame: .zero)
        super.init(frame: frame)

        addSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubTitleLabel()
        addSubRibbon()
    }

    private func addSubTitleLabel() {
        titleLabel.text = "日照香炉生紫烟"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -4).isActive = true
    }

    private func addSubRibbon() {
        addSubview(ribbon)
        ribbon.translatesAutoresizingMaskIntoConstraints = false
        ribbon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        ribbon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        ribbon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        ribbon.widthAnchor.constraint(equalToConstant: 2).isActive = true
    }

}
