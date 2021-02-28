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
    }
    
    @IBAction func loginUIButton(_ sender: Any) {
        let loginSend = LoginSendJson(email: emailUITextField.text, password: passwordUITextField.text)
        /*
        let encoder = JSONEncoder()
        let data = try! encoder.encode(loginSend)
        let loginSendJson = String(data: data, encoding: .utf8)!
        
        let urlString = "http://localhost/api/login"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = loginSendJson.data(using: String.Encoding.utf8)
        
        var data_return: Data?
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            //print("Data \(data)")
            data_return = data
            //print("URLSession Data_return \(data_return)")
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        //print("Data_return \(data_return)")
        do {
            let loginResponsJson = try JSONDecoder().decode(LoginResponseJson.self, from: data_return!)
            if !loginResponsJson.success {
                self.errorUILabel.text = "Неправильная e-mail или пароль"
            } else {
                UserDefaults.standard.set(true, forKey: "LOGGED_IN")
                UserDefaults.standard.set(loginResponsJson.data.token, forKey: "TOKEN")
                self.performSegue(withIdentifier: "messageSegue", sender: self)
            }
            //print(loginResponsJson)
            //print(loginResponsJson.success
        } catch let error {
            print(error)
            return
        }*/
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        AF.request("http://localhost/api/login", method: .post, parameters: loginSend, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: LoginResponseJson.self, completionHandler: { response in
            switch response.result {
            case .success:
                if response.value?.success ?? false {
                    UserDefaults.standard.set(true, forKey: "LOGGED_IN")
                    UserDefaults.standard.set(response.value?.data.token, forKey: "TOKEN")
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
