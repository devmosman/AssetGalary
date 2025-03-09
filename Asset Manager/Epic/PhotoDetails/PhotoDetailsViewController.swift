//
//  PhotoDetailsViewController.swift
//  Asset Manager
//
//  Created by Marwan on 25/06/2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var bigItemsCV: UICollectionView!
    @IBOutlet weak var smallItemsCV: UICollectionView!
    
    var images: [UIImage] = []
    var selectedIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let height = view.frame.height - topPadding - bottomPadding
        print("@@@ height \(height)")
        
        bigItemsCV.delegate = self
        bigItemsCV.dataSource = self
        bigItemsCV.register(PhotoDetailsBigCVCell.nib, forCellWithReuseIdentifier: PhotoDetailsBigCVCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: height - 150)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        bigItemsCV.setCollectionViewLayout(layout, animated: true)
        
        smallItemsCV.delegate = self
        smallItemsCV.dataSource = self
        smallItemsCV.register(ImageCVCell.nib, forCellWithReuseIdentifier: ImageCVCell.identifier)
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = .init(width: 90, height: 90)
        layout2.minimumLineSpacing = 0
        layout2.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        layout2.scrollDirection = .horizontal
        smallItemsCV.setCollectionViewLayout(layout2, animated: true)
        
        
        smallItemsCV.reloadData()
        bigItemsCV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.bigItemsCV.setContentOffset(CGPoint(x: CGFloat(self.selectedIndex) * UIScreen.main.bounds.width, y: 0), animated: true)
            self.smallItemsCV.scrollToItem(at: IndexPath(row: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }


}

extension PhotoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == smallItemsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier, for: indexPath) as! ImageCVCell
            cell.deleteView.alpha = 0
            cell.assetImageView.image = images[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoDetailsBigCVCell.identifier, for: indexPath) as! PhotoDetailsBigCVCell
            cell.assetImageView.image = images[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == smallItemsCV {
            bigItemsCV.setContentOffset(CGPoint(x: CGFloat(indexPath.row) * UIScreen.main.bounds.width, y: 0), animated: true)
            smallItemsCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            
        }
    }
    
    
}

extension PhotoDetailsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
