//
//  MovieInfoTableViewCell.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var writerLabel: UILabel?
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userRatingStackView: UIStackView?
    @IBOutlet weak var userRatingImage1: UIImageView?
    @IBOutlet weak var userRatingImage2: UIImageView?
    @IBOutlet weak var userRatingImage3: UIImageView?
    @IBOutlet weak var userRatingImage4: UIImageView?
    @IBOutlet weak var userRatingImage5: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var contentText: UITextView?
    var userStarImageArray: [UIImageView] = []
    var userRating: Float = 0 {
        didSet {
            if userRating != oldValue {
                refreshingUserView()
            }
        }
    }
    var emptyStar: UIImage = #imageLiteral(resourceName: "ic_star_large")
    var halfStar: UIImage = #imageLiteral(resourceName: "ic_star_large_half")
    var fullStar: UIImage = #imageLiteral(resourceName: "ic_star_large_full")
    
    func refreshingUserView() {
        for i in 0 ..< 5 {
            let imageView: UIImageView? = self.userStarImageArray[i]
            if self.userRating >= Float(i+1) {
                imageView?.image = self.fullStar
            } else if self.userRating > Float(i) && self.userRating < Float(i+1) {
                imageView?.image = self.halfStar
            } else {
                imageView?.image = self.emptyStar
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size = CGSize(width: 70, height: 70)
        self.userImage?.sizeThatFits(size)
        self.userImage?.image = #imageLiteral(resourceName: "ic_user_loading")
        for i in 0 ..< 5 {
            guard let imageView = userRatingStackView?.arrangedSubviews[i] as? UIImageView else { return }
            self.userStarImageArray.append(imageView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        contentText?.isEditable = false
        super.setSelected(selected, animated: animated)
    }
}
