//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 07.05.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private let imagesListService = ImagesListService.shared
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, что бы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonTap(_ sender: Any) {
        guard let photoId = cellImage.accessibilityLabel else { return }
        let isLike = likeButton.currentImage == UIImage(named: "like_button_on") ? true : false
        
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.likeButton.setImage(UIImage(named: isLike ? "like_button_off" : "like_button_on"), for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
}
