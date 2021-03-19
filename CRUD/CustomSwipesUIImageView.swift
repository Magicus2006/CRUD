//
//  CustomSwipesUIImageView.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 06.11.2020.
//

import UIKit

class CustomSwipesUIImageView: UIImageView {

    //var link: String?
    var links: [String] = []
    var countSelectImage: Int = 0
    
    func imagesLink(link: String?) {
        //self.link = link
        //loadPostImage(link: self.link)
    }
    
    func imagesLink(link: [String]?) {
        
    }
    
    func append(_ link: String) {
        links.append(link)
        //print(link)
        if links.count == 1 {
            loadPostImage(self.links[0])
        }
        if links.count > 1 {
            configureSwipes()
        }
            
    }
    
    func configureSwipes() {
        self.isUserInteractionEnabled = true
        let leftSwipe = UISwipeGestureRecognizer(target:self, action: #selector(self.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target:self, action: #selector(self.handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipes(_ recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
            if countSelectImage < links.count - 1 {
                countSelectImage += 1
                loadPostImage(links[countSelectImage])
            }
            
        } else if (recognizer.direction == .right) {
            if countSelectImage > 0 {
                countSelectImage -= 1
                loadPostImage(links[countSelectImage])
            }
           
        }
    }

    
    func loadPostImage(_ link: String?) {
        if let urlString = link {
            let url = URL(string: globalURL + urlString)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error as Any)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }

                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }.resume()
        }
    }

}
