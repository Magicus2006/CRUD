//
//  ContenerViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 06.11.2020.
//

import UIKit

class ContenerViewController: UIViewController {
    
    var controller: UIViewController!
    var menuViewController: UIViewController!
    var isMove: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configurePostTableViewController()
    }
    
    func configurePostTableViewController() {
        let postTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PostTableViewController") as! PostTableViewController
        controller = postTableViewController
        view.addSubview(controller.view)
        addChild(controller)
    }
    
    func configureMenuViewController() {
        if menuViewController == nil {
            menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController") as! MenuViewController
            
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
            print("Добавили контроллер Menu")
        }
    }
    @IBAction func leftButtonItem(_ sender: Any) {
        configureMenuViewController()
        isMove = !isMove
        showMenuViewController(shouldMenu: isMove)
    }
    
    func showMenuViewController(shouldMenu: Bool) {
        if shouldMenu {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.controller.view.frame.origin.x = self.controller.view.frame.width - 140
            } completion: { (finished) in
                
            }

        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.controller.view.frame.origin.x = 0
            } completion: { (finished) in
                
            }
            

            
        }
    }
  
    
}


