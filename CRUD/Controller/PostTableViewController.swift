//
//  PostTableViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 25.10.2020.
//

import UIKit
import Alamofire




protocol PostTableViewControllerDelegate {
    func toggleMenu()
}

class PostTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    let headerID = String(describing: CustomHeaderView.self)
    var dataResponseJson: [DataResponseJson] = []
    var isExpanded: [Bool] = []
    var isCheckboxPost: [Bool] = []
    var isCheckboxComment: [[Bool]] = [[]]
    var delegete: PostTableViewControllerDelegate?
    var isCheckboxDeleted: Bool = false {
        didSet {
            setCheckboxDeleted()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableViewConfig()
        
        
        
    }
    
    func setCheckboxDeleted() {
        print("setCheckboxDeleted")
        tableView.reloadData()
    }
    
    func errorConnectAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Ошибка соединение с сервером", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    
    func loadData() {
        
        AF.request(ApiRouter.all_post).responseDecodable(of: PostsResponseJson.self,
                                                                                   completionHandler: {
            response in
            switch response.result {
            case .success:
                if (response.value?.success ?? false) {
                    if response.value?.data != nil {
                        self.dataResponseJson = response.value!.data!
                        self.isExpanded = Array(repeating: true, count: self.dataResponseJson.count)
                        self.isCheckboxPost = Array(repeating: false, count: self.dataResponseJson.count)
                        self.isCheckboxComment = Array(repeating: [], count: self.dataResponseJson.count)
                        for index in 0..<self.isCheckboxComment.count {
                            self.isCheckboxComment[index] = Array(repeating: false, count: self.dataResponseJson[index].comments?.count ?? 0)
                        }
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print("Error LoginView: \(error)")
                self.errorConnectAlert()
            }
        })
        
    }
    
    
    
    
    
    private func tableViewConfig() {
        let nib = UINib(nibName: headerID, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CustomHeaderView
        
        let isHidden = dataResponseJson[section].comments?.count != nil ? false : true
        let content = dataResponseJson[section].post?.content ?? "Not content"
        let title = dataResponseJson[section].post?.title ?? "Not title"
        
        header.configure(title: title, content: content, section: section, images: dataResponseJson[section].images, isHidden: isHidden)
        
        header.isCheckBox = isCheckboxDeleted
        header.isCheckBoxSelected = self.isCheckboxPost[section]
        header.rotateImage(isExpanded[section])
        header.delegate = self
        
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CustomHeaderView
        
        return header.frame.size.height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataResponseJson.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isExpanded[section] {
            return 0
        }
        
        if let count = dataResponseJson[section].comments?.count {
            return count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! CustomChekboxTableViewCell
        
        cell.textMyLable.text = dataResponseJson[indexPath.section].comments![indexPath.row].comment?.text
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isCheckBox = isCheckboxDeleted
        cell.isCheckBoxSelected = self.isCheckboxComment[indexPath.section][indexPath.row]
        
        return cell
    }
}

// MARK: Deleget

extension PostTableViewController: CustomHeaderViewDelegate, CustomChekboxTableViewCellDelegete {
    
    func selectedCellCheckbox(button: UIButton, indexPath: IndexPath) {
        for section in 0..<isCheckboxComment.count {
            for row in 0..<isCheckboxComment[section].count {
                if indexPath.section == section && indexPath.row == row {
                    isCheckboxComment[indexPath.section][indexPath.row] = !isCheckboxComment[indexPath.section][indexPath.row]
                } else {
                    isCheckboxComment[section][row] = false
                }
            }
            isCheckboxPost[section] = false
        }
        tableView.reloadData()
    }
    
 
    func selectedSectionCheckbox(button: UIButton) {
        let section = button.tag
        //isCheckboxPost[section] = !isCheckboxPost[section]
        for sect in 0..<isCheckboxPost.count {
            if section == sect {
                isCheckboxPost[sect] = true
            } else {
                isCheckboxPost[sect] = false
            }
        }
        self.isCheckboxComment = Array(repeating: [], count: self.dataResponseJson.count)
        for index in 0..<self.isCheckboxComment.count {
            self.isCheckboxComment[index] = Array(repeating: false, count: self.dataResponseJson[index].comments?.count ?? 0)
        }
        tableView.reloadData()
    }
    
    func expandedSectionShowComments(button: UIButton) {
        let section = button.tag
        isExpanded[section] = !isExpanded[section]
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    
    
}

// MARK: Удаление поста

extension PostTableViewController {
    func deletePostOrAndConmments() {
        // Удаляем все отмеченые посты и комментарии
        var indexPath: [IndexPath] = []
        let user_id = UserDefaults.standard.integer(forKey: "USER_ID")
        
        for section in 0..<isCheckboxComment.count {
            for row in 0..<isCheckboxComment[section].count {
                if isCheckboxComment[section][row] {
                    if dataResponseJson[section].comments![row].comment?.user_id == user_id {
                        indexPath.append(IndexPath(row: row, section: section))
                    }
                }
            }
        }
        
        for i in indexPath {
            deleteComments(indexPath: i) { (response) in
                switch response.result {
                case .success:
                    self.dataResponseJson[i.section].comments!.remove(at: i.row)
                    self.isCheckboxComment[i.section][i.row] = false
                    self.tableView.deleteRows(at: [i], with: .automatic)
                    self.tableView.reloadData()
                case let .failure(error):
                    print("Error LoginView: \(error)")
                    self.errorConnectAlert()
                }
            }
            print("IndexPath Array: Section: \(i.section), Row: \(i.row)")
        }
    }
    
    func deleteComments(indexPath: IndexPath, completion: @escaping (DataResponse<CommentsDeletedJson, AFError>) -> Void) {
        // Удаления коментария
        
        let section = indexPath.section
        let row = indexPath.row
        
        let post_id = dataResponseJson[section].comments![row].comment?.post_id
        let comment_id = dataResponseJson[section].comments![row].comment?.id
        
        let token = UserDefaults.standard.value(forKey: "TOKEN") as! String
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: token)
        ]
        

        let post_id_string = String(post_id ?? 0)
        let commnet_id_string = String(comment_id ?? 0)
        
        let uri = globalURL+"/api/posts/\(post_id_string)/comment/\(commnet_id_string)"
        
        AF.request(uri, headers: headers).responseDecodable(of: CommentsDeletedJson.self, completionHandler: {
                response in
                completion(response)
        })
    }
    
    
}

// MARK: Изменения поста

extension PostTableViewController {
    func changeComments() -> IndexPath? {
        var indexPath: IndexPath?
        for section in 0..<isCheckboxComment.count {
            for row in 0..<isCheckboxComment[section].count {
                if isCheckboxComment[section][row] {
                    indexPath = IndexPath(row: row, section: section)
                }
            }
        }
        return indexPath
    }
}
