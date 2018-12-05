//
//  BaseViewController.swift
//  MemeMe
//
//  Created by Abad Vera on 12/3/18.
//  Copyright © 2018 Abad Vera. All rights reserved.
//

import UIKit

let memeDetailViewController = "memeDetailViewController"
let memeEditorViewController = "memeEditorViewController"

class BaseViewController: UIViewController {

    var memes: [Meme]? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.memes
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = self.navigationController {
            let addMemeBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeEditor))
            navController.navigationItem.rightBarButtonItem = addMemeBarItem
        }
    }

    @objc func showMemeEditor() {
        let memeEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "memeEditorViewController") as! MemeMeEditorViewController
        self.present(memeEditorVC, animated: true, completion: nil)
    }
}
