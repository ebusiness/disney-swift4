//
//  CreatePlanTimeAndParkCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/21.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import UIKit

class CreatePlanTimeAndParkCell: UITableViewCell {

    let icon: UIImageView
    let titleLabel: UILabel
    let textFrame: UIView
    let detailLabel: UILabel

    init() {
        icon = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        textFrame = UIView(frame: .zero)
        detailLabel = UILabel(frame: .zero)
        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none
        backgroundColor = GlobalColor.viewBackgroundLightGray

        addSubIcon()
        addSubTitle()
        addSubTextFrame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubIcon() {
        icon.backgroundColor = UIColor.black
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 12).isActive = true
    }

    private func addSubTitle() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
    }

    private func addSubTextFrame() {
        textFrame.layer.borderColor = UIColor.black.cgColor
        textFrame.layer.borderWidth = 1
        addSubview(textFrame)
        textFrame.translatesAutoresizingMaskIntoConstraints = false
        textFrame.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        textFrame.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        textFrame.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        textFrame.heightAnchor.constraint(equalToConstant: 40).isActive = true

        addSubDetailLabel()
    }

    private func addSubDetailLabel() {
        textFrame.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.centerYAnchor.constraint(equalTo: textFrame.centerYAnchor).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: textFrame.leftAnchor, constant: 16).isActive = true
    }
}

class CreatePlanTimeAndParkParkCell: CreatePlanTimeAndParkCell {

    override init() {
        super.init()
        titleLabel.text = "选择园区"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class CreatePlanTimeAndParkDateCell: CreatePlanTimeAndParkCell {

    override init() {
        super.init()
        titleLabel.text = "选择日期"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class CreatePlanTimeAndParkInTimeCell: CreatePlanTimeAndParkCell {

    override init() {
        super.init()
        titleLabel.text = "入园时间"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class CreatePlanTimeAndParkOutTimeCell: CreatePlanTimeAndParkCell {

    override init() {
        super.init()
        titleLabel.text = "退园时间（可选）"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
