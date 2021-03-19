//
//  CustomChekBoxTableViewCell.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 08.11.2020.
//

import UIKit


protocol CustomChekboxTableViewCellDelegete: class {
    func selectedCellCheckbox(button: UIButton, indexPath: IndexPath)
}

class CustomChekboxTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButtonOutlet: UIButton!    
    @IBOutlet weak var textMyLable: UILabel!
    
    weak var delegate: CustomChekboxTableViewCellDelegete?
    
    var indexPath: IndexPath = []
    
    
    
    var defaultXTextMyLable: CGFloat = 0.0
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
    
    /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.defaultXTextMyLable = self.textMyLable.frame.origin.x
        self.checkBoxButtonOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
        self.checkBoxButtonOutlet.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
            self.textMyLable.frame.origin.x = self.checkBoxButtonOutlet.frame.size.width + self.checkBoxButtonOutlet.frame.origin.x + 5
            self.checkBoxButtonOutlet.isHidden = false
        } else {
            self.textMyLable.frame.origin.x = self.defaultXTextMyLable
            self.checkBoxButtonOutlet.isHidden = true
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkBoxButtonTap(_ sender: UIButton) {
        delegate?.selectedCellCheckbox(button: sender, indexPath: indexPath)
    }
}
