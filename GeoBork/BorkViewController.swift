//
//  BorkViewController.swift
//  GeoBork
//
//  Created by Tania on 28/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
class BorkViewController: UIViewController {
    
    @IBOutlet weak var borkCollectionView: UICollectionView!
    
    let reuseIdentifier = "borkCell"
    var items = ["parkbig", "inspectorbig"]
  
    var currentBorkType:String?
    
    fileprivate let screenWight:CGFloat = UIScreen.main.bounds.width
    fileprivate var selections:Int { return (items.count % 2) + 1}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borkCollectionView.dataSource = self
        borkCollectionView.delegate = self
    }
    
    @IBAction func btnClousePress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension BorkViewController:UICollectionViewDataSource{
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ( selections == 1){
            return self.items.count
        } else {
            return section == 1 ? 1 : self.items.count - 1
        }
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BorkCollectionViewCell
        
        var remainder = 0
        if (indexPath.section == 1){
            remainder = items.count - 1
        }
        let name = self.items[indexPath.item + remainder]
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = name
        cell.myImage.image = UIImage(named: name)
        
        return cell
    }
    
}

extension BorkViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
       // self.dismiss(animated: true, completion: nil)
        
        var remainder = 0
        if (indexPath.section == 1){
            remainder = items.count - 1
        }
        currentBorkType = self.items[indexPath.item + remainder]
        
        self.performSegue(withIdentifier: "showlocation", sender: self)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selections
    }
}

extension BorkViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var sectionInsets: UIEdgeInsets
        if (section == 1){
            let offset = (screenWight / 2) - 70
            sectionInsets = UIEdgeInsets(top: 50, left: offset, bottom: 20, right: offset)
        } else {
            sectionInsets = UIEdgeInsets(top: 50, left: 20.0, bottom: 0, right: 20.0)
        }
        
        return sectionInsets
    }
}
