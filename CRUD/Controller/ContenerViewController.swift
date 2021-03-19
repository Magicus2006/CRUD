//
//  ContenerViewController.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 06.11.2020.
//

import UIKit

enum ButtonItemType {
    case change
    case delete
}

class ContenerViewController: UIViewController {
    
    var controller: PostTableViewController!
    var menuViewController: MenuViewController!
    var isMove: Bool = false
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var deleteButtomItemOutlet: UIBarButtonItem!
    
    var actionButtonItemType: ButtonItemType?
    
    
    
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
            menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController") as? MenuViewController
            
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
            menuViewController.delegate = self
        }
    }
    
    func setCheckboxPostTableView(isCheckbox: Bool) {
        controller.isCheckboxDeleted = isCheckbox
        self.navigationController?.isToolbarHidden = !(self.navigationController?.isToolbarHidden ?? true)
    }
    
    
    @IBAction func actionButtonItem(_ sender: Any) {
        guard let action = actionButtonItemType else {
            return
        }
        if action == .delete {
            controller.deletePostOrAndConmments()
        } else if action == .change {
            //let indexPath = controller.changeComments()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard storyboard.instantiateViewController(identifier: "ChangePostViewController") is ChangePostViewController else { return }
            
            self.performSegue(withIdentifier: "changeView", sender: self)
        }
    }
    
    @IBAction func leftButtonItem(_ sender: Any) {
        configureMenuViewController()
        showHiddenMenu()
    }
    
    func showHiddenMenu() {
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

