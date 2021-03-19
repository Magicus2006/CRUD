//
//  CustomHeaderView.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 25.10.2020.
//

import UIKit

protocol CustomHeaderViewDelegate: class {
    func expandedSectionShowComments(button: UIButton)
    func selectedSectionCheckbox(button: UIButton)
}

class CustomHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: CustomHeaderViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var postImageView: CustomSwipesUIImageView!
    @IBOutlet weak var checkBoxButtonOutlet: UIButton!
    
    var isCheckBoxSelected: Bool = false {
        didSet {
            setCheckBox()
        }
    }
    
    var isCheckBox: Bool = false {
        didSet {
            setCheckBox()
        }
    }
    
    func configure(title: String, content: String, section: Int, images: [ImagesResponseJson]?, isHidden: Bool = false) {
        titleLabel.text = title
        contentTextView.text = content
        
        headerButton.tag = section
        checkBoxButtonOutlet.tag = section
        
        headerButton.isHidden = isHidden
        
        if let img = images {
            if img.count > 0 {
                for i in img {
                    postImageView.append(i.link ?? "/storage/images/1.jpg")
                }
            }
        }
    
        self.checkBoxButtonOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        self.checkBoxButtonOutlet.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
    }
    
    @IBAction func checkBoxButtonTap(_ sender: UIButton) {
        //isCheckBoxSelected = !isCheckBoxSelected
        delegate?.selectedSectionCheckbox(button: sender)
    }
    
    private func setCheckBox() {
        if self.isCheckBox {
            if self.isCheckBoxSelected {
                self.checkBoxButtonOutlet.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                self.checkBoxButtonOutlet.tintColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
            } else {
                self.checkBoxButtonOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
                self.checkBoxButtonOutlet.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            self.checkBoxButtonOutlet.isHidden = false
        } else {
            self.checkBoxButtonOutlet.isHidden = true
        }
        
    }
    
    
    func rotateImage(_ expanded: Bool) {
        if expanded {
            headerButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            headerButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        }
    }
    
    func imageSet(image: UIImage?) {
        postImageView.image = image
    }
    
    @IBAction func tapHeader(_ sender: UIButton) {
        delegate?.expandedSectionShowComments(button: sender)
    }
    


}
