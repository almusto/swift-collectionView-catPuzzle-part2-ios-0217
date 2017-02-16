//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  var headerReusableView: HeaderReusableView!
  var footerReusableView: FooterReusableView!

  var sectionInsets: UIEdgeInsets!
  var spacing: CGFloat!
  var itemSize: CGSize!
  var referenceSize: CGSize!
  var numberOfRows: CGFloat!
  var numberOfColumns: CGFloat!

  var imageSlices: [UIImage]!
  var randomImages: [UIImage]!
  var solved: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      configureLayout()
      imageSlices = populateImages()
      randomImages = randomizeImages()

      self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
      self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")



    }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)


  }

  func configureLayout() {

    let width = UIScreen.main.bounds.width
    let hieght = UIScreen.main.bounds.height


    numberOfRows = 4
    numberOfColumns = 3
    spacing = 2
    sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    referenceSize = CGSize(width: width, height: 60)

    let itemWidth = (width - 4*spacing)/numberOfColumns
    let itemHieght = (hieght - 6*spacing)/numberOfRows

    itemSize = CGSize(width: itemWidth, height: itemHieght)

  }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = randomImages[indexPath.item]
        
        return cell
        
    }


  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    if kind == UICollectionElementKindSectionHeader {

      headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView

      return headerReusableView

    } else {

      footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView

      return footerReusableView
    }
    
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return itemSize
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return referenceSize
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return referenceSize
  }

  override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    self.collectionView?.performBatchUpdates({

      let image = self.randomImages.remove(at: sourceIndexPath.item)
      self.randomImages.insert(image, at: destinationIndexPath.item)


    }, completion: { completed in

      if self.randomImages == self.imageSlices {

        self.performSegue(withIdentifier: "solvedSegue", sender: nil)

      }

    })
  }

  func populateImages() -> [UIImage] {
    var images: [UIImage] = []
    for int in 1...12 {
      images.append(UIImage(named: String(int))!)
    }
    return images
  }

  func randomizeImages() -> [UIImage] {
    var copy = imageSlices
    var random: [UIImage] = []
    while copy?.isEmpty == false {
      let index = Int(arc4random_uniform(UInt32(copy!.count)))
      let image = (copy?[index])!
      random.append(image)
      copy?.remove(at: index)
    }
    return random
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "solvedSegue" {

      let dest = segue.destination as! SolvedViewController
      dest.image = UIImage(named: "cats")
      dest.time = footerReusableView.timerLabel.text

    }

  }


}
