//
//  RealmModel.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/04.
//

import Foundation
import RealmSwift

class DiaryTable: Object {
    
    override init() {
        print("DiaryTable Init")
    }
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var diaryTitle: String //일기 제목(필수)
    @Persisted var diaryDate: Date //일기 등록 날짜 (필수)
    @Persisted var contents: String? //일기 내용 (옵션)
    @Persisted var photo: String? //일기 사진 URL (옵션)
    @Persisted var diaryLike: Bool //즐겨찾기 기능(필수) / 초기화구문에 초기값을 false 설정해주면 되기 때문에 옵셔널로 대응안해도 됨
//    @Persisted var diaryPin: Bool
    @Persisted var diarySummary: String
    
    convenience init(diaryTitle: String, diaryDate: Date, diaryContents: String?, diaryPhoto: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryDate = diaryDate
        self.contents = diaryContents
        self.photo = diaryPhoto
        self.diaryLike = true
        self.diarySummary = "제목은 '\(diaryTitle)'이고, 내용은 '\(contents ?? "")'입니다"
   }
    
    deinit {
        print("DiaryTabe Deinit")
    }
}
