//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Abad Vera on 12/3/18.
//  Copyright © 2018 Abad Vera. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties
    let sentMemesCollectionViewCell = "sentMemesCollectionViewCell"

    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup flowLayout
        let space = CGFloat(3.0)
        let dimension = (self.view.frame.size.width - (2 * space)) / space

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let memes = memes {
            return memes.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sentMemesCollectionViewCell, for: indexPath) as! SentMemesCollectionViewCell
        if let meme = memes?[indexPath.row] {
            cell.memedImageView.image = meme.memedImage
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes![indexPath.row]
        showMemeDetail(meme: meme)
    }
}
