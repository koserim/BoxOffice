//
//  SynopsisTableViewCell.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var synopsisView: UITextView?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
