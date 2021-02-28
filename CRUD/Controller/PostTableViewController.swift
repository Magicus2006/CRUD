//
//  PostTableViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 25.10.2020.
//

import UIKit
import Alamofire


struct PostsResponseJson: Decodable {
    var success: Bool?
    var data: [DataResponseJson]?
    var message: String?

}
struct DataResponseJson: Decodable {
    var post: PostResponseJson?
    var images: [ImagesResponseJson]?
    var comments: [CommentElementResponseJson]?
}

struct PostElementsResponseJson: Decodable {
    var post: PostResponseJson?
    var image: [ImagesResponseJson]?
}




struct PostResponseJson: Decodable {
    var id: Int?
    var title: String?
    var content: String?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
}

struct CommentsJson: Decodable {
    var comments: [CommentElementResponseJson]?
}

struct CommentElementResponseJson: Decodable {
    var comment: CommentResponseJson?
    var images: [ImagesResponseJson]?
}

struct ImagesResponseJson: Decodable {
    var id: Int?
    var link: String?
    var alt: String?
}

struct CommentResponseJson: Decodable {
    var id: Int?
    var text: String?
    var post_id: Int?
    var user_id: Int?
    var created_at: String?
    var updated_at: String?
}

protocol PostTableViewControllerDelegate {
    func toggleMenu()
}

class PostTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    let headerID = String(describing: CustomHeaderView.self)
    var dataResponseJson: [DataResponseJson] = []
    var isExpanded: [Bool] = []
    var delegete: PostTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableViewConfig()
    }
    
    func loadData() {
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request("http://localhost/api/all_posts", headers: headers).responseDecodable(of: PostsResponseJson.self, completionHandler: {
            response in
            //print("Response JSON String: \(String(describing: response.value))")
            if (response.value?.success ?? false) {
                if response.value?.data != nil {
                    self.dataResponseJson = response.value!.data!
                    self.isExpanded = Array(repeating: true, count: self.dataResponseJson.count)
                    self.tableView.reloadData()
                }
            }
        })
        
    }
    
    
    
    
    
    private func parsingData(data: Data) {
        do {
            let postsResponJson = try JSONDecoder().decode(PostsResponseJson.self, from: data)
            if (postsResponJson.success ?? false) {
               
                self.dataResponseJson = postsResponJson.data!
                //print(postsResponJson.data!)
                //print(postsResponJson.data!.count)
                //print(dataResponseJson.count)
                self.isExpanded = Array(repeating: true, count: self.dataResponseJson.count)
                self.tableView.reloadData()
            } else {
                print("Упс!")
                return
            }
        } catch {
            print("-=Start Error: ",error, ": End error=-")
            return
        }
        //tableView.reloadData()
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
        header.rotateImage(isExpanded[section])
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CustomHeaderView
        
        return header.frame.size.height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return arrayOfData.count
        return self.dataResponseJson.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !isExpanded[section] {
            return 0
        }
        
        //return arrayOfData[section].array.count
        //print("Section: \(section) count: \(dataResponseJson[section].comments?.count)")
        if let count = dataResponseJson[section].comments?.count {
            return count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        cell.textLabel?.text = dataResponseJson[indexPath.section].comments![indexPath.row].comment?.text
        return cell
    }
    

    
    
}


extension PostTableViewController: HeaderViewDelegate {

    func expandedSection(button: UIButton) {
        let section = button.tag

        let isEx = isExpanded[section]
        isExpanded[section] = !isEx
        //print("isExpanded[\(section)]", isExpanded[section])
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

