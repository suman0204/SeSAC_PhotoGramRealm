//
//  NewHomeViewController.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/14.
//

import UIKit
import SnapKit
import RealmSwift

class NewHomeViewController: BaseViewController {
    
    let realm = try! Realm()
    
    var tasks: Results<DiaryTable>!
    let repository = DiaryTableRepository()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, DiaryTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(DiaryTable.self)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
//            content.textProperties.
            
            content.image = self.loadImageForDocument(fileName: "jack_\(itemIdentifier._id).jpg")
            content.imageProperties.maximumSize.height = 50
            content.imageProperties.maximumSize.width = 50
            
            content.text = itemIdentifier.diaryTitle
            content.textProperties.numberOfLines = 1
            
            content.secondaryText = itemIdentifier.contents
            content.secondaryTextProperties.numberOfLines = 1
            
            content.prefersSideBySideTextAndSecondaryText = false

            cell.contentConfiguration = content
            
            cell.accessories = [ .label(text: "\(itemIdentifier.diaryDate)") ]
        })
        
    }
    
    static func layout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
//    override func setConstraints() {
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
}

extension NewHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = tasks[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        
        return cell
    }
    
    
}
