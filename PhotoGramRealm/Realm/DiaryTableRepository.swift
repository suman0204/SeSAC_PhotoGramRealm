//
//  DiaryTableRepository.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/06.
//

import Foundation
import RealmSwift

protocol DiaryTableRepositoryType: AnyObject {
    func fetch() -> Results<DiaryTable>
    func fetchFilter() -> Results<DiaryTable>
    func createItem(_ item: DiaryTable)
}

class DiaryTableRepository: DiaryTableRepositoryType {
    
    private let realm = try! Realm()
    
    private func a() { //==> 다른 파일에서 쓸 일 없고, 클래스 안에서만 쓸 수 있음 => 오버라이딩 불가능 => final 키워드를 잠재적으로 유추 가능
        let a = ""
    }
    
    func fetch() -> Results<DiaryTable> {
        let data = realm.objects(DiaryTable.self).sorted(byKeyPath: "diaryDate", ascending: false)
        return data
    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetchFilter() -> Results<DiaryTable> {
        
        let result = realm.objects(DiaryTable.self).where {
            //1. 대소문자 구별 없음 - caseInsensitive
//            $0.diaryTitle.contains("제목", options: .caseInsensitive) //title에 제목이 포함된 row만
            
            //2. Bool
//            $0.diaryLike == true
            
            //3. 사진이 있는 데이터만 불러오기 (diaryPhoto의 nil 여부 판단)
            $0.photo != nil
//            $0.diaryPhoto.isEmpty // 사용 불가
        }
        return result
    }
    
    func createItem(_ item: DiaryTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
        
    }
    
    func updateItem(id: ObjectId, title: String, contents: String) {
        do {
            try realm.write {
                // 트랜젝션 오류를 막기 위해 try안에 선언
//                realm.add(item, update: .modified) // add를 통해 수정하는 방법
                realm.create(DiaryTable.self, value: ["_id": id, "diaryTitle": title, "contents": contents], update: .modified)
            }
        } catch {
            print("") // NSLog로 남기거나 집계한다
        }
    }
    
    
}
