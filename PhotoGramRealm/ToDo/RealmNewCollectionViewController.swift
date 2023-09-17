//
//  RealmNewCollectionViewController.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/14.
//

import UIKit
import SnapKit
import RealmSwift

class RealmNewCollectionViewController: BaseViewController {
    
    let realm = try! Realm()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var list: Results<ToDoTable>!

    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ToDoTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = realm.objects(ToDoTable.self)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //itemIdentifier = list[indexPath.item]
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.image = itemIdentifier.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
//            content.image = UIImage(systemName: "pencil")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 할일"
            cell.contentConfiguration = content
        })
        
    }
    
    static func layout() -> UICollectionViewLayout {
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
}

extension RealmNewCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = list[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        
        return cell
    }
    
    
}
