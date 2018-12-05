//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Abad Vera on 12/3/18.
//  Copyright © 2018 Abad Vera. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!

    var meme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load memed image
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
}
