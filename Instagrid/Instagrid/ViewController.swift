//
//  ViewController.swift
//  Instagrid
//
//  Created by Claire on 07/05/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    var layoutType: LayoutType = .oneTopTwoBottom {
       didSet {
            photoCollectionView.reloadData()
        }
    }
    
    var indexPath: IndexPath?

    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var footerView: FooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        footerView.delegate = self
    }
    
    func photoAccess(indexPath: IndexPath) {
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    print ("It's authorized")
                    // recursion
                    self.photoAccess(indexPath: indexPath)
                }
            }
            
        case .authorized:
            self.indexPath = indexPath
            //            DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.sourceType = sourceType
            controller.delegate = self
            //                controller.allowsEditing = self
            present(controller, animated: true, completion: nil)
            
            //            }
            
        case .denied:
            print("Acces Photo denied")
            
        default:
            break
        }

    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutType.numberOfItems(for: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layoutType.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = UIImage(named: "Cross")
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoAccess(indexPath: indexPath)
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightMargin = (layoutType.sections + 1) * 10
        let divisableHeight = Double(collectionView.frame.height) - Double(heightMargin)
        let cellHeight = divisableHeight / Double(layoutType.sections)
        
        let numberOfItems = layoutType.numberOfItems(for: indexPath.section)
        let widthMargin = (numberOfItems + 1) * 10
        let divisableWidth = Double(collectionView.frame.width) - Double(widthMargin)
        let cellWidth = divisableWidth / Double(numberOfItems)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top: CGFloat = section == 0 ? 10 : 5
        let bottom: CGFloat = section == layoutType.sections - 1 ? 10 : 5
//        let left: CGFloat =
        
        return UIEdgeInsets(top: top, left: 10, bottom: bottom, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
}


extension ViewController: FooterViewDelegate {
    
    func didSelect(layoutType: LayoutType) {
        self.layoutType = layoutType
    }
}


extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        
        let cell = photoCollectionView.cellForItem(at: indexPath!) as! PhotoCollectionViewCell
        cell.photoImageView.image = image
    }
}

extension ViewController: UINavigationControllerDelegate {}
