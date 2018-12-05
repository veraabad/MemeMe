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

        if self.navigationController != nil {
            let addMemeBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMemeEditor))
            self.navigationItem.setRightBarButton(addMemeBarItem, animated: true)
        }
    }

    @objc func showMemeEditor() {
        let memeEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "memeEditorViewController") as! MemeMeEditorViewController
        self.present(memeEditorVC, animated: true, completion: nil)
    }

    func showMemeDetail(meme: Meme) {
        let memeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: memeDetailViewController) as! MemeDetailViewController
        memeDetailVC.meme = meme
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
