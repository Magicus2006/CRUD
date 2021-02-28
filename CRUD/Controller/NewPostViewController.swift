//
//  NewPostViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 30.10.2020.
//

import UIKit
import Alamofire

struct Posts: Decodable {
    var succse: Bool?
}

struct NewPost: Codable {
    var title: String?
    var content: String?
//    var images: [Images]?
}

struct Images: Codable {
        var id: Int
        var link: String
        var alt: String
}

class NewPostViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func fotoGallereyButton(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextField.layer.borderColor = UIColor.systemGray5.cgColor
        contentTextField.layer.borderWidth = 1.0
        contentTextField.layer.cornerRadius = 5.0
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sendButton(_ sender: Any) {
        let newPostStruct = NewPost(title: titleTextField.text, content: contentTextField.text)
        let jEncoder = JSONEncoder()
        let dataJson = try! jEncoder.encode(newPostStruct)
        //let newPostJSON =
        
        
        let token = UserDefaults.standard.value(forKey: "TOKEN") as! String
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: token)
        ]
        
        UserDefaults.standard.set(true, forKey: "LOGGED_IN")
        
        let imageData = (imageView.image?.jpegData(compressionQuality: 0.8))!
        
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "upload_image", fileName: "upload.jpg", mimeType: "image/jpg")
            multipartFormData.append(dataJson, withName: "json", mimeType: "application/json")
        }, to: "http://localhost/api/posts", headers: headers)
            .responseDecodable(of: Posts.self) { response in
                debugPrint(response)
            }
        self.dismiss(animated: true, completion: nil)
    }

    

}

extension NewPostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imageView.image = image_data
        
        self.dismiss(animated: true, completion: nil)
    }
}
