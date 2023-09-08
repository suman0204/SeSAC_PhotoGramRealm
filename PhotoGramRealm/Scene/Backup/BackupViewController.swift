//
//  BackupViewController.swift
//  PhotoGramRealm
//
//  Created by 홍수만 on 2023/09/07.
//

import UIKit
import Zip

class BackupViewController: BaseViewController {
    
    let backupButton = {
        let view = UIButton()
        view.backgroundColor = .systemOrange
        return view
    }()
    
    let restoreButton = {
       let view = UIButton()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    let backupTableView = {
       let view = UITableView()
        view.rowHeight = 50
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        backupTableView.delegate = self
        backupTableView.dataSource = self
    }
    
    override func configure() {
        super.configure()
        view.addSubview(backupTableView)
        view.addSubview(backupButton)
        view.addSubview(restoreButton)
        backupButton.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func backupButtonTapped() {
        //1. 백업하고자 하는 파일들의 경로 배열 생성
        var urlPaths = [URL]()
        
        //2.
        guard let path = documentDirectoryPath() else {
            print("도규먼트 위치에 오류가 있습니다.") // alert이나 토스트 메시지로 대채해주자
            return
        }
        
        //3. 백업하고자 하는 파일 경로
        let realmFile = path.appendingPathComponent("default.realm")
        
        //4. 3번 경로가 유효한지 확인
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            print("백업할 파일이 없습니다")
            return
        }
        
        //5. 압축하고자 하는 파일을 배열에 추가
        urlPaths.append(realmFile)
        
        //6. 압축
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "JackArchive")
            print("location: \(zipFilePath)")
        } catch {
            print("압축을 실패했어요") //알럿 띄워주기
        }
    }
    
    @objc func restoreButtonTapped() {
        
        //파일 앱을 통한 복구 진행
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true) //forOpeningContentTypes: 열고 싶은 파일 형식을 특정할 수 있다 asCopy: 복사해서 가져올지 말지 결정
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // 한 개의 파일만 가져온다
        
        present(documentPicker, animated: true)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backupTableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            
        }
        
        backupButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.left.equalTo(view.safeAreaLayoutGuide)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function, urls)
        
        guard let selectedFileURL = urls.first else { //파일앱 내의 URL 주소
            print("선택한 파일에 오류가 있어요")
            return
        }
        
        guard let path =  documentDirectoryPath() else {
            print("도규먼트 위치에 오류가 있어요")
            return
        }
        
        //도규먼트 폴더 내 저장할 경로 설정
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent) //Document 경로에 파일앱에서 가지고 있던 마지각 경로값(파일 이름)을 붙여서 압축 해제할 경로를 설정한다
        
        //경로에 복구할 파일(zip)이 이미 있는 지 확인
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            let fileURL = path.appendingPathComponent("JackArchive.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
                })
            } catch {
                print("압축 해제 실패")
            }
        
        } else {
            //경로에 복구할 파일이 없을 때의 대응
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("JackArchive.zip")

                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("압축해제 완료: \(unzippedFile)")
                    
                    exit(0) // 앱을 강제 종료
                })
            } catch {
                print("압축 해제 실패")
            }
            
        }
    }
}

extension BackupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func fetchZipList() -> [String] {
        var list: [String] = [] // document에 있는 파일의 리스트 담아줄 배열
        
        do {
            guard let path = documentDirectoryPath() else { return list } // document 경로
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil) //document에 있는 모든 파일 목록
            let zip = docs.filter {
                $0.pathExtension == "zip" // 확장자가 zip인 파일 / pathExtension: 확장자가 일치하는 파일 골라줌
            }
            
            for i in zip {
                list.append(i.lastPathComponent)
            }
            
        } catch {
            print("ERROR")
        }
        
        return list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchZipList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = fetchZipList()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityViewController(fileName: fetchZipList()[indexPath.row])
    }
    
    func showActivityViewController(fileName: String) {
        
        guard let path = documentDirectoryPath() else {
            print("도큐먼트 위치에 오류가 있어요")
            return
        }
        
        let backupFileURL = path.appendingPathComponent(fileName)
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: nil) /*or [] */
        
        present(vc, animated: true)
    }
    
}
