//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Eric Winn on 5/24/15.
//  Copyright (c) 2015 Eric N. Winn. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: - Shared Model
    var meme: Meme!
    
    // MARK: - Outlets
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memedImage.image = meme.memedImage
    }
}
