//
//  TabBarController.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 9. 15..
//  Copyright © 2018년 serim. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    weak var sortDelegate: sortDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



protocol sortDelegate: class {
    func sortTypeChanged(sortCode: Int)
}
