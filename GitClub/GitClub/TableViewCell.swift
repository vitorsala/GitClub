//
//  TableViewCell.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 30/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblNome: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
