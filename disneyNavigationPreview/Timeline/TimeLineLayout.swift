//
//  TimeLineLayout.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/08.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class TimeLineLayout: UICollectionViewLayout {
    static let supplementaryKindBlack = "supplementaryKindBlack"

    var blackHeight: CGFloat = 22
    var blackLineSpacing: CGFloat = 108

    var whiteLeftMargin: CGFloat = 40
    var whiteInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 6)

    var startTime: CGFloat = 8

    private var contentSize = CGSize.zero
    private var supplementaryBlackSize = CGSize.zero

    private var blackLayoutAttributes = [UICollectionViewLayoutAttributes]()
    private var whiteLayoutAttributes = [WhiteLayoutAttributes]()

    //swiftlint:disable:next function_body_length
    override func prepare() {
        blackLayoutAttributes.removeAll()
        whiteLayoutAttributes.removeAll()
        if let collectionView = collectionView {
            let numberOfSections = collectionView.numberOfSections
            if numberOfSections > 0 {
                let screenWidth = UIScreen.main.bounds.width
                contentSize = CGSize(width: screenWidth,
                                     height: CGFloat(numberOfSections)*blackHeight+(CGFloat(numberOfSections)-1)*blackLineSpacing)
                supplementaryBlackSize = CGSize(width: screenWidth,
                                                height: blackHeight)
                for i in 0..<numberOfSections {
                    let indexPath = IndexPath(item: 0, section: i)
                    let supplementaryBlackAttributes = layoutAttributesForSupplementaryView(ofKind: TimeLineLayout.supplementaryKindBlack,
                                                                                            at: indexPath)!
                    blackLayoutAttributes.append(supplementaryBlackAttributes)
                }
            }

            // 整理时间信息
            var glasses = [TimeLineLayoutHourGlass]()
            if let delegate = collectionView.delegate as? UICollectionViewDelegateTimeLineLayout {
                for i in 0..<numberOfSections {
                    let numberOfItems = collectionView.numberOfItems(inSection: i)
                    if numberOfItems > 0 {
                        for j in 0..<numberOfItems {
                            let indexPath = IndexPath(item: j, section: i)
                            if let start = delegate.collectionView?(collectionView, startTimeAt: indexPath),
                                let duration = delegate.collectionView?(collectionView, durationAt: indexPath) {
                                let glass = TimeLineLayoutHourGlass(indexPath: indexPath, start: start, duration: duration)
                                glasses.append(glass)
                            }
                        }
                    }
                }
            }

            // 详细整理分布状态
            for glass in glasses {
                let concerned = whiteLayoutAttributes.filter({ attribute -> Bool in
                    return attribute.hourGlass.start <= glass.start && (attribute.hourGlass.start + attribute.hourGlass.duration) > glass.start
                })
                let attributes = WhiteLayoutAttributes(forCellWith: glass.indexPath)
                attributes.zIndex = 10
                attributes.hourGlass = glass
                if concerned.isEmpty {
                    // 全空
                    attributes.group = attributes
                    whiteLayoutAttributes.append(attributes)
                } else {
                    let segment = concerned[0].denominator
                    let group = concerned[0].group
                    let sorted = concerned.sorted(by: { (lds, rds) -> Bool in
                        return lds.at < rds.at
                    })
                    var rooms = [Int](repeating: -1, count: segment)
                    for idx in 0..<sorted.count {
                        let at = sorted[idx].at
                        let numerator = sorted[idx].numerator
                        for c in 0..<numerator {
                            rooms[at + c - 1] = idx + 1
                        }
                    }

                    if let idx = rooms.index(of: -1) {
                        // 有空位
                        var len = 0
                        for idy in idx..<rooms.count {
                            if rooms[idy] == -1 {
                                len += 1
                            } else {
                                break
                            }
                        }
                        let at = idx + 1
                        let numerator = len
                        let denominator = segment
                        attributes.at = at
                        attributes.numerator = numerator
                        attributes.denominator = denominator
                        attributes.group = group
                        whiteLayoutAttributes.append(attributes)
                    } else {
                        // 无空位
                        var multier = -1
                        for ix in 0..<sorted.count where sorted[ix].numerator > 1 {
                            multier = ix
                            break
                        }
                        if multier != -1 {
                            // 可以挤出位置
                            sorted[multier].numerator = sorted[multier].numerator - 1
                            attributes.numerator = 1
                            attributes.at = sorted[multier].at + sorted[multier].numerator
                            attributes.denominator = segment
                            attributes.group = group
                            whiteLayoutAttributes.append(attributes)
                        } else {
                            // 只能重算宽度
                            for attr in whiteLayoutAttributes where attr.group == group {
                                attr.denominator = segment + 1
                                if attr.at + attr.numerator > segment && !concerned.contains(attr) {
                                    attr.numerator += 1
                                }
                            }
                            attributes.numerator = 1
                            attributes.at = segment + 1
                            attributes.denominator = segment + 1
                            attributes.group = group
                            whiteLayoutAttributes.append(attributes)
                        }
                    }
                }
            }

            // 具体定位
            for attr in whiteLayoutAttributes {
                let screenWidth = UIScreen.main.bounds.width
                let availableWidth = screenWidth - whiteLeftMargin

                let x = whiteLeftMargin + availableWidth * CGFloat(attr.at - 1) / CGFloat(attr.denominator) + whiteInset.left
                let width = availableWidth * CGFloat(attr.numerator) / CGFloat(attr.denominator) - whiteInset.left - whiteInset.right

                let y = (attr.hourGlass.start - startTime) * (blackHeight + blackLineSpacing) + blackHeight / 2 + whiteInset.top

                let height = attr.hourGlass.duration * (blackHeight + blackLineSpacing) - whiteInset.bottom - whiteInset.top

                attr.frame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == TimeLineLayout.supplementaryKindBlack {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
            attributes.frame = frameForSupplementaryView(ofKind: elementKind, at: indexPath)
            return attributes
        } else {
            return nil
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
        for object in blackLayoutAttributes {
            if object.frame.intersects(rect) {
                result.append(object)
            }
        }
        for object in whiteLayoutAttributes {
            if object.frame.intersects(rect) {
                result.append(object)
            }
        }
        return result
    }

    private func frameForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> CGRect {
        if elementKind == TimeLineLayout.supplementaryKindBlack {
            let y = CGFloat(indexPath.section) * (blackHeight + blackLineSpacing)
            return CGRect(origin: CGPoint(x: 0, y: y),
                          size: supplementaryBlackSize)
        } else {
            return .zero
        }
    }

}

@objc
protocol UICollectionViewDelegateTimeLineLayout: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, startTimeAt indexPath: IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, durationAt indexPath: IndexPath) -> CGFloat
}

class WhiteLayoutAttributes: UICollectionViewLayoutAttributes {
    var left: [WhiteLayoutAttributes]?
    var right: [WhiteLayoutAttributes]?
    var at = 1
    var numerator = 1
    var denominator = 1
    var hourGlass: TimeLineLayoutHourGlass!
    var group: WhiteLayoutAttributes?
}

struct TimeLineLayoutHourGlass {
    let indexPath: IndexPath
    let start: CGFloat
    let duration: CGFloat
}
