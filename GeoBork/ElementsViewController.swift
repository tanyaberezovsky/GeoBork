//
//  ElementsViewController.swift
//  GeoBork
//
//  Created by Tania on 28/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
//localization router
class ElementsViewController: UIViewController {
    
    @IBOutlet weak var elementsCollectionView: UICollectionView!
    
    let reuseIdentifier = "elementCell" // also enter this string as the cell identifier in the storyboard
    var items = ["iconDogBeach", "iconDogGarden", "iconInspector", "iconInspectorByBike", "iconVeterinar"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elementsCollectionView.dataSource = self
    }
}

    // MARK: - UICollectionViewDataSource protocol
extension ElementsViewController:UICollectionViewDataSource{
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ElementCollectionViewCell
        
        let name = self.items[indexPath.item]
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = name
        cell.myImage.image = UIImage(named: name)
        
        return cell
    }
}// collection view sell size

extension ElementsViewController: UICollectionViewDelegate{
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
