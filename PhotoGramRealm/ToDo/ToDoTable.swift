//
//  ToDoTable.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/08.
//

import Foundation
import RealmSwift

class ToDoTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId //Primary Key가 없어도 오류가 나진 않지만 있는게 좋다 - 35회차 강의자료
    @Persisted var title: String
    @Persisted var favorite: Bool
    
    //To Many Relationship (일대다 / 단방향)
    @Persisted var detail: List<DetailTable>

    //To One RealationShip (일대일) EmbeddedObject(무조건 옵셔널 필수), 별도의 테이블이 생성되는 형태는 아님
    @Persisted var memo: Memo?
    
    convenience init(title: String, favorite: Bool) {
        self.init()
        
        self.title = title
        self.favorite = favorite
        
    }
}

class DetailTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var detail: String
    @Persisted var deadline: Date
    
    //Inverse Relationship Property (LinkingObjects)
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<ToDoTable>
    
    convenience init(detail: String, deadline: Date) {
        self.init()
        
        self.detail = detail
        self.deadline = deadline
        
    }
}


class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
}
