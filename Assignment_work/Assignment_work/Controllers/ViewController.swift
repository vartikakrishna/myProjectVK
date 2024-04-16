//
//  ViewController.swift
//  Assignment_work
//
//  Created by vartika krishna on 15/04/24.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionName: UICollectionView!
    let imageCache = NSCache<AnyObject, AnyObject>()
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    
    var pictureInfo = [mainModelName]() {
        didSet{
            DispatchQueue.main.async {
                self.setcollectiomView()
                self.collectionName.reloadData()
                print(self.pictureInfo[0].coverageURL)
            }
        }
    }
    
    var repository = [mainModelName]()
    
    var screenWidth = UIScreen.main.bounds.width/3
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        fetchImages()
        // Do any additional setup after loading the view.
    }
    func setcollectiomView()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionName!.collectionViewLayout = layout
        collectionName.delegate = self
        collectionName.dataSource = self
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyCollectionViewCell else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.imageName.loadImages(from: self.pictureInfo[indexPath.row].coverageURL)
            let imagev = cell.imageName.image?.centerCropped(to: CGSize(width: self.screenWidth, height: self.screenWidth))
            cell.imageName.image = imagev ?? UIImage(named: "noimage")
            cell.backgroundColor = .lightGray
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenWidth, height: screenWidth)
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

    func fetchImages() {
        let address = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
        if let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let response = response as? HTTPURLResponse, let data = data {
                    print("Status Code: \(response.statusCode)")
                    do{
                        let decoder = JSONDecoder()
                        let picInfo = try decoder.decode([mainModelName].self, from: data)
                        self.pictureInfo.append(contentsOf: picInfo)
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
        
    }
}
