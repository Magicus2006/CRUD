//
//  ProfileViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 08.11.2020.
//

import UIKit
import Alamofire

/*
struct ProfileJson: Decodable {
    var success: Bool?
    var data: DataJson?
    var message: String?
}

struct DataJson: Decodable {
    var id: Int?
    var name: String?
    var email: String?
    var email_verified_at: String?
    var created_at: String?
    var updated_at: String?
    var address: String?
}


struct ProfileJsonSend: Codable {
    var name: String?
    var email: String?
    var password: String?
    var c_password: String?
    var address: String?
}
*/

class ProfileViewController: UIViewController {
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createDataTextField: UITextField!
    @IBOutlet weak var updateDataTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailVerifiedImageView: UIImageView!
    @IBOutlet weak var errorUILabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        let token = UserDefaults.standard.value(forKey: "TOKEN") as! String
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: token)
        ]
        
        AF.request(ApiRouter.profile).responseDecodable(of: ProfileJson.self) { (response) in
            switch response.result {
            case .success:
                if let result = response.value {
                    if result.success ?? false {
                        self.nameTextField.text = result.data?.name
                        self.emailTextField.text = result.data?.email
                        self.createDataTextField.text = result.data?.created_at
                        self.updateDataTextField.text = result.data?.updated_at
                        self.addressTextField.text = result.data?.address
                        if result.data?.email_verified_at == nil {
                            // checkmark
                            // multiply
                            self.emailVerifiedImageView.image = UIImage(systemName: "multiply")
                            self.emailVerifiedImageView.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                            
                        } else {
                            self.emailVerifiedImageView.image = UIImage(systemName: "checkmark")
                            self.emailVerifiedImageView.tintColor = #colorLiteral(red: 0.1913341329, green: 1, blue: 0.2271309753, alpha: 1)
                            
                        }
                    }
                }
            case let .failure(error):
                print("Error ProfileView: \(error)")
            }
        }
        
        
    }
    
    @IBAction func changeButton(_ sender: UIButton) {
        let profileJsonSend = ProfileJsonSend(name: self.nameTextField.text, email: self.emailTextField.text, password: self.passwordTextField.text, c_password: self.cPasswordTextField.text, address: self.addressTextField.text)
        
        let token = UserDefaults.standard.value(forKey: "TOKEN") as! String
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: token)
        ]
        AF.request(globalURL+"/api/profile/update", method: .put, parameters: profileJsonSend, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of:ProfileJson.self, completionHandler: { response in
            switch response.result {
            case .success:
                if response.value?.success ?? false {
                    print("Все OK!")
                    //self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "contenerView", sender: self)
                } else {
                    self.errorUILabel.text = "Неправильная данные"
                }
            case let .failure(error):
                print("Error LoginView: \(error)")
                self.errorUILabel.text = "Нет соединения с сервером"
            }
        })
        
        
    }
    
   

}
