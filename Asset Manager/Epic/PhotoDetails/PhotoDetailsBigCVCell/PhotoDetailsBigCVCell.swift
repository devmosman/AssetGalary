//
//  PhotoDetailsBigCVCell.swift
//  Asset Manager
//
//  Created by Marwan on 31/07/2022.
//

import UIKit

class PhotoDetailsBigCVCell: UICollectionViewCell {

    
    @IBOutlet weak var assetImageView: UIImageView!
    
    var isZooming = false
    var originalCenter: CGPoint?
    var zoomingScale: CGFloat = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPhotoImage()
    }
    
    func setupPhotoImage() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        pinchGesture.delegate = self
        panGesture.delegate = self
        assetImageView.addGestureRecognizer(pinchGesture)
        assetImageView.addGestureRecognizer(panGesture)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.originalCenter = self.assetImageView.center
        }
    }
    
    @objc func panAction(sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        if sender.state == .changed && isZooming {
            let translation = sender.translation(in: view)
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(.zero, in: view)
        }
    }

    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        switch sender.state {
        case .began:
            isZooming = true
        case .changed:
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform
                .translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            view.transform = transform
            sender.scale = 1
        case .ended:
            guard let center = originalCenter else { return }
            if view.transform.a < 0.5 {
                UIView.animate(withDuration: 0.3) {
                    self.assetImageView.transform = .identity
                    self.assetImageView.center = center
                }
            }
            isZooming = false
        default:
            break
        }

    }

}

extension PhotoDetailsBigCVCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
