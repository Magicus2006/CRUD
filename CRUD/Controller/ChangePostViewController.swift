//
//  ChangePostViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 19.11.2020.
//

import UIKit

class ChangePostViewController: UIViewController {

    @IBOutlet weak var contentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configuradeView()
    }
    
    func configuradeView() {
        contentTextField.layer.borderColor = UIColor.systemGray5.cgColor
        contentTextField.layer.borderWidth = 1.0
        contentTextField.layer.cornerRadius = 5.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
