//
//  ThumbViewController.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class ThumbViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var thumbImageView: UIImageView?
    var thumbImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        thumbImageView?.image = thumbImage
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.thumbImageView?.addGestureRecognizer(tapGesture)
        self.thumbImageView?.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
}
