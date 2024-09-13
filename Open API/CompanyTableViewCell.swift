//
//  CompanyTableViewCell.swift
//  Open API
//
//  Created by Ruslan Yelguldinov on 11.08.2024.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var typeOfActivityLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    func setData(for type: CellType, with data: CompanyModel) {
            switch type {
            case .type1:
                // Настройте для типа 1
                nameLabel.text = data.name
                cityLabel.text = data.city
                streetLabel.text = data.street
                typeOfActivityLabel.text = data.typeOfActivity
            case .type2:
                // Настройте для типа 2
                nameLabel.text = data.name
                cityLabel.text = data.city
                streetLabel.text = data.street
                typeOfActivityLabel.text = data.typeOfActivity
            }
        }

}
