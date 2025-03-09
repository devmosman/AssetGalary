//
//  ImageManager.swift
//  Asset Manager
//
//  Created by Marwan on 16/06/2022.
//

import UIKit
import Photos

class ImageManager: NSObject {
    
    static let shared = ImageManager()
    fileprivate var currentVC: UIViewController!
    var imagePickedBlock: (([UIImagePickerController.InfoKey : Any]) -> Void)?
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            myPickerController.popoverPresentationController?.sourceView = currentVC.view
            myPickerController.popoverPresentationController?.sourceRect = .init(x: 0, y: 0, width: 1, height: 1)
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            myPickerController.popoverPresentationController?.sourceView = currentVC.view
            myPickerController.popoverPresentationController?.sourceRect = .init(x: 0, y: 0, width: 1, height: 1)
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.camera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.photoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.sourceView = currentVC.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: currentVC.view.bounds.midX, y: currentVC.view.bounds.midY, width: 0, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = []
        vc.present(alert, animated: true)
    }
    
    func getImage(info: [UIImagePickerController.InfoKey : Any])-> UIImage {
        if let editedImage = info[.editedImage] as? UIImage {
            return editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            return originalImage
        } else {
            print("Something went wrong")
        }
        return UIImage()
    }
    
}

extension ImageManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePickedBlock?(info)
        currentVC.dismiss(animated: true, completion: nil)
    }
}
