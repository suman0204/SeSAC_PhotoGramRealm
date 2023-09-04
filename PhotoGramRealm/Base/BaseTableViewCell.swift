//
//  BaseTableViewCell.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    @available(*, unavailable) // 아래의 구문은 절대 사용될 일 없다고 명시
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setConstraints() {}
}
