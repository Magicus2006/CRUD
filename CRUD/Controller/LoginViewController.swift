//
//  LoginViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 22.10.2020.
//

import UIKit
import Alamofire

/*
 {
         "success": true,
         "data": {
             "token_type": "Bearer ",
             "token": "token"
         },
         "message": "User authorizate successfully."
 }
 */






struct LoginResponseJson: Decodable {
    var success: Bool
    var data: LoginDataResponseJson
    var message: String
}

struct LoginDataResponseJson: Decodable {
    var token_type: String
    var token: String
}

struct LoginSendJson: Codable {
    var email: String?
    var password: String?
}




class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailUITextField: UITextField!
    @IBOutlet weak var passwordUITextField: UITextField!
    @IBOutlet weak var errorUILabel: UILabel!
    //var data_return: Data
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Вход"
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: "LOGGED_IN") {
            self.performSegue(withIdentifier: "messageSegue", sender: self)
        }
        
        self.navigationController?.isToolbarHidden = true
        
        //var user = UserParams()
        //user.name = "eugene"

        //print(Router.createUser(parameters: user))
        
        
    }
    
    @IBAction func loginUIButton(_ sender: Any) {
        
        let username = emailUITextField.text ?? ""
        let password = passwordUITextField.text ?? ""
        
        AF.request(ApiRouter.login(["email": username, "password": password])).responseDecodable(of: LoginResponseJson.self, completionHandler: { response in
            switch response.result {
            case .success:
                if response.value?.success ?? false {
                    UserDefaults.standard.set(true, forKey: "LOGGED_IN")
                    UserDefaults.standard.set(response.value?.data.token, forKey: "TOKEN")
                    UserDefaults.standard.set(1, forKey: "USER_ID")
                    self.performSegue(withIdentifier: "messageSegue", sender: self)
                } else {
                    self.errorUILabel.text = "Неправильная e-mail или пароль"
                }
            case let .failure(error):
                print("Error LoginView: \(error)")
                self.errorUILabel.text = "Нет соединения с сервером"
            }
        })
    }
    

}
