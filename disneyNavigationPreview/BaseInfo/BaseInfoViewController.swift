//
//  BaseInfoViewController.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class BaseInfoViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var collectionView: UICollectionView

    private let essentialCellIdentifier = "essentialCellIdentifier"

    private var visitPark = TokyoDisneyPark.land
    private var visitDate = Date()

    private struct CellLayout {
        static let essentialInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        static let essentialMinimumInteritemSpacing = CGFloat(4)
        static let essentialRatio = CGFloat(1.53)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = GlobalColor.viewBackgroundLightGray
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addSubCollectionView()
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func addSubCollectionView() {
        collectionView.register(BaseInfoEssentialCell.self, forCellWithReuseIdentifier: essentialCellIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func presentParkPicker() {
        let parkpicker = BaseInfoParkPickVC(park: visitPark)
        parkpicker
            .currentPark
            .asObservable()
            .subscribe(onNext: { [weak self] park in
                self?.visitPark = park
                self?.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
            })
            .disposed(by: disposeBag)
        present(parkpicker, animated: false, completion: nil)
    }

    private func presentDatePicker() {
        let datePicker = BaseInfoDatePickVC(date: visitDate)
        datePicker
            .currentDate
            .asObservable()
            .subscribe(onNext: { [weak self] date in
                self?.visitDate = date
                self?.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
            })
            .disposed(by: disposeBag)
        present(datePicker, animated: false, completion: nil)
    }
}

extension BaseInfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: essentialCellIdentifier, for: indexPath) as? BaseInfoEssentialCell else {
                fatalError("Unknown cell type")
            }
            if indexPath.item == 0 {
                cell.spec = .park(visitPark)
            } else {
                cell.spec = .date(visitDate)
            }
            return cell
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth - 12 - CellLayout.essentialMinimumInteritemSpacing - 12) / 2
            let cellHeight = cellWidth / CellLayout.essentialRatio
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return CellLayout.essentialMinimumInteritemSpacing
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return CellLayout.essentialInset
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                presentParkPicker()
            case 1:
                presentDatePicker()
            default:
                break
            }
        default:
            break
        }
    }
}
