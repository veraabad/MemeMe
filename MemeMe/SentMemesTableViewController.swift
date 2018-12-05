//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Abad Vera on 12/3/18.
//  Copyright © 2018 Abad Vera. All rights reserved.
//

import UIKit

class SentMemesTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    let sentMemeTableViewCell = "sentMemeTableViewCell"

    // MARK: Outlets
    @IBOutlet weak var sentMemesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Reload in case a new meme has been saved
        sentMemesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes = memes {
            return memes.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sentMemeTableViewCell, for: indexPath)
        if let meme = memes?[indexPath.row] {
            cell.imageView?.image = meme.memedImage
            cell.textLabel?.text = meme.topText + " " + meme.bottomText
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes![indexPath.row]
        showMemeDetail(meme: meme)
    }
}
