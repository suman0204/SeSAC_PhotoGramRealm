//
//  FileManager+Extension.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        //1. 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    //도큐먼트에 저장된 사진 삭제
    func removeImageFromDocument(fileName: String) {
        //중복되는 코드 줄여보기
        //1. 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 경로 설정(세부 경로, 이미지를 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
    
    //도큐먼트 폴더에서 이미지를 가져오는 메서드
    func loadImageForDocument(fileName: String) -> UIImage {
        //1. 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return UIImage(systemName: "star.fill")! }
        
        //2. 경로 설정(세부 경로, 이미지를 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        //3. 파일 유효성 검사 (존재 유무를 검사해줌, FileManager에서 메서드 제공)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)! //옵셔널 바인딩 대응 필요
        } else {
            return UIImage(systemName: "star.fill")!
        }
        
    }
    
    //Document 폴더에 이미지를 저장하는 메서드
    func saveImageToDocument(fileName: String, image: UIImage) {
        //1. 도큐먼트 폴더 경로 찾기
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName) // appendingPathComponent: '/'를 붙여서 뒤에 경로 추가해줌
        
        //3. 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // compressionQuality: 용량 압축
        
        //4. 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
}
