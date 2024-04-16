//
//  collectionCell.swift
//  Assignment_work
//
//  Created by vartika krishna on 16/04/24.
//

import Foundation
import UIKit


class MyCollectionViewCell:UICollectionViewCell
{
 
    @IBOutlet weak var imageName: myimageviewClass!
    
    let myImageView: myimageviewClass = {
        let image = myimageviewClass()
        return image
    }()
   
    override func prepareForReuse() {
        super.prepareForReuse()
        imageName.image = nil
    }
  
}
