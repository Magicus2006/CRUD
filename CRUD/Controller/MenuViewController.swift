//
//  MenuViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 06.11.2020.
//

import UIKit

class MenuViewController: UIViewController {
    
    var menu:[(menuName: String, action: ()->Void)] = []
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ContenerViewController?
    var isCheckbox: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        menu.append((menuName: "Профиль",action: profile))
        menu.append((menuName: "Мои посты",action: profile))
        menu.append((menuName: "Изменить",action: changePost))
        menu.append((menuName: "Удалить",action: deletePost))
        menu.append((menuName: "Выход",action: logout))
        //
        //menu.append((menuName: "Меню4",action: menu4))
        
        configureTableView()
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame.size.width = self.view.frame.width - 140
        tableView.frame.size.height = 43.5 * CGFloat(menu.count)
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "LOGGED_IN")
        UserDefaults.standard.set("", forKey: "TOKEN")
        UserDefaults.standard.set(0, forKey: "USER_ID")
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    func profile() {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    func deletePost() {
        isCheckbox = !isCheckbox
        delegate?.setCheckboxPostTableView(isCheckbox: isCheckbox)
        delegate?.showHiddenMenu()
        delegate?.deleteButtomItemOutlet.title = "Удалить"
        delegate?.actionButtonItemType = .delete
    }
    func changePost() {
        isCheckbox = !isCheckbox
        delegate?.setCheckboxPostTableView(isCheckbox: isCheckbox)
        delegate?.showHiddenMenu()
        delegate?.deleteButtomItemOutlet.title = "Изменить"
        delegate?.actionButtonItemType = .change
    }
    func menu4() {
        print("Меню4")
    }

   

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = arrayOfData[indexPath.section].array[indexPath.row]
        cell.textLabel?.text = menu[indexPath.row].menuName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menu[indexPath.row].action()
    }
}
