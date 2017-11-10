//
//  AttractionChartCell.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/11/08.
//  Copyright © 2017 ebuser. All rights reserved.
//

import UIKit

class AttractionChartCell: UICollectionViewCell {
    var data: AnalysedWaitTime? {
        didSet {
            chart.reloadData()
        }
    }

    private let chart: WaitTimeChart

    private let chartCornerRadius = CGFloat(4)
    private let chartSize = CGSize(width: UIScreen.main.bounds.width - 24,
                                   height: (UIScreen.main.bounds.width - 24) * 0.5)

    override init(frame: CGRect) {
        chart = WaitTimeChart(frame: CGRect.zero)
        super.init(frame: frame)

        configChart()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configChart() {
        chart.tintColor = UIColor.white
        chart.backgroundColor = GlobalColor.primaryRed
        chart.layer.cornerRadius = chartCornerRadius
        chart.layer.masksToBounds = true

        chart.title = nil
        chart.delegate = self
        chart.dataSource = self

        addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        chart.widthAnchor.constraint(equalToConstant: chartSize.width).isActive = true
        chart.topAnchor.constraint(equalTo: topAnchor).isActive = true
        chart.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension AttractionChartCell: WaitTimeChartDelegate, WaitTimeChartDataSource {
    var title: String? {
        if let date = data?.date {
            return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        } else {
            return nil
        }
    }

    var firstIndex: Int? {
        return data?.firstRealtimeIndex
    }

    var lastIndex: Int? {
        return data?.lastRealtimeIndex
    }

    var maxIndex: Int? {
        return data?.maxIndex
    }

    var chartType: WaitTimeChartType {
        if let data = data {
            switch data.type {
            case .mix:
                return .mix
            case .realtimeOnly:
                return .realtimeOnly
            case .simOnly:
                return .simOnly
            }
        } else {
            return .mix
        }
    }

    func chartContentSize() -> CGSize {
        let fullSize = chartSize
        return CGSize(width: fullSize.width, height: fullSize.height - 24)
    }

    func chartTitleHeight() -> CGFloat {
        return 24
    }

    func numberOfVerticalAxis() -> Int {
        return 3
    }

    func titleForVerticalAxis(at: Int) -> String? {
        guard let data = data else {
            return nil
        }
        if at == 1 {
            return "\(data.scale / 2) min"
        } else if at == 2 {
            return "\(data.scale) min"
        } else {
            return nil
        }
    }

    func numberOfHorizontalAxis() -> Int {
        return 57
    }

    func titleForHorizontalAxis(at: Int) -> String? {
        if at % 4 == 0 {
            return "\(8 + at / 4)"
        } else {
            return nil
        }
    }

    func valueOfMaxVerticalAxis() -> CGFloat {
        guard let data = data else {
            return 99999
        }
        return CGFloat(data.scale)
    }

    func valueOfMinVerticalAxis() -> CGFloat {
        return 0
    }

    func value(at: Int) -> CGFloat? {
        if let realTime = data?.realtime {
            if at < realTime.count {
                if let waitTime = realTime[at]?.waitTime {
                    return CGFloat(waitTime)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func simValue(at: Int) -> CGFloat? {
        if let simTime = data?.prediction {
            if at < simTime.count {
                if let waitTime = simTime[at]?.waitTime {
                    return CGFloat(waitTime)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}
