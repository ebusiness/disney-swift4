//
//  BaseInfoViewController.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2017/9/5.
//  Copyright © 2017年 ebuser. All rights reserved.
//

import RxSwift
import UIKit

final class BaseInfoViewController: UIViewController, Localizable {

    let localizeFileName = "BaseInfo"

    private let disposeBag = DisposeBag()

    private var collectionView: UICollectionView

    private let essentialCellIdentifier = "essentialCellIdentifier"
    private let tagCellIdentifier = "tagCellIdentifier"
    private let headerCellIdentifier = "headerCellIdentifier"

    /// tags from server
    private var allTags = [VisitorTag]()
    private let defaultTagIds = ["58faed6067847695d6cfee06",
                                 "58fd5a2867847695d6cfee0d"]

    /// tags in collection view
    /// 0: empty
    /// 1: selected
    /// 2: unselected
    private var shownTags = [[VisitorTag]]()

    private var visitPark = TokyoDisneyPark.land
    private var visitDate = Date()

    private struct CellLayout {
        static let essentialInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        static let essentialMinimumInteritemSpacing = CGFloat(4)
        static let essentialRatio = CGFloat(1.53)

        static let tagInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        static let tagMinimumInteritemSpacing = CGFloat(8)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = BaseInfoColor.baseInfoViewBackground
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addNavigationItem()
        addSubCollectionView()
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestVisitorTags()
    }

    private func addNavigationItem() {
        let save = UIBarButtonItem(barButtonSystemItem: .save,
                                   target: self,
                                   action: #selector(handleNextButton(sender:)))
        navigationItem.setRightBarButton(save, animated: false)

        let logo = UIImageView(image: #imageLiteral(resourceName: "nav_bar_logo"))
        navigationItem.titleView = logo
    }

    private func addSubCollectionView() {
        collectionView.register(BaseInfoEssentialCell.self, forCellWithReuseIdentifier: essentialCellIdentifier)
        collectionView.register(BaseInfoTagCell.self, forCellWithReuseIdentifier: tagCellIdentifier)
        collectionView.register(BaseInfoHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerCellIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func requestVisitorTags() {
        let tagsRequest = API.Visitor.tags
        tagsRequest.request([VisitorTag].self) { [weak self] visitorTags, _ in
            guard let strongSelf = self else {
                return
            }
            if let visitorTags = visitorTags {
                strongSelf.allTags = visitorTags
                let empty = [VisitorTag]()
                var selectedGroup = [VisitorTag]()
                var unselectedGroup = [VisitorTag]()

                strongSelf.allTags.forEach { model in
                    if strongSelf.defaultTagIds.contains(model.id) {
                        selectedGroup.append(model)
                    } else {
                        unselectedGroup.append(model)
                    }
                }

                strongSelf.shownTags.append(empty)
                strongSelf.shownTags.append(selectedGroup)
                strongSelf.shownTags.append(unselectedGroup)

                strongSelf.collectionView.reloadSections(IndexSet(integersIn: 1...2))
            }
        }
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

    @objc
    func handleNextButton(sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        appDelegate.switchToHomepage()
    }
}

extension BaseInfoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1, 2:
            if shownTags.isEmpty {
                return 0
            } else {
                return shownTags[section].count
            }
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
        case 1, 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as? BaseInfoTagCell else {
                fatalError("Unexpected cell class")
            }
            cell.visitorTag = shownTags[indexPath.section][indexPath.item]
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
        case 1, 2:
            return shownTags[indexPath.section][indexPath.item].getCellSize()
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return CellLayout.essentialMinimumInteritemSpacing
        case 1, 2:
            return CellLayout.tagMinimumInteritemSpacing
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return CellLayout.essentialInset
        case 1, 2:
            return CellLayout.tagInset
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
        case 1:
            let destination = IndexPath(item: 0, section: 2)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)
        case 2:
            let destination = IndexPath(item: collectionView.numberOfItems(inSection: 1), section: 1)
            let temp = shownTags[indexPath.section].remove(at: indexPath.item)
            shownTags[destination.section].insert(temp, at: destination.item)

            collectionView.moveItem(at: indexPath, to: destination)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        switch section {
        case 0:
            return .zero
        case 1, 2:
            let width = UIScreen.main.bounds.width
            let height = CGFloat(24)
            return CGSize(width: width, height: height)
        default:
            fatalError()
        }

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: headerCellIdentifier,
                                                  for: indexPath) as? BaseInfoHeaderCell else {
                                                    fatalError("Unexpected cell class")
            }

            if indexPath.section == 0 {
                headerView.title = ""
            } else if indexPath.section == 1 {
                headerView.title = localize(for: "selectedTags")
            } else {
                headerView.title = localize(for: "unselectedTags")
            }
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}
