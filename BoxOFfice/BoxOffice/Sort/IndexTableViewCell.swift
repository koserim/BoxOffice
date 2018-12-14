//
//  CustomTableViewCell.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class IndexTableViewCell: UITableViewCell {

    @IBOutlet var thumbImage: UIImageView?
    @IBOutlet var gradeImage: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var userRatingLabel: UILabel?
    @IBOutlet var reservationGradeLabel: UILabel?
    @IBOutlet var reservationRateLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
