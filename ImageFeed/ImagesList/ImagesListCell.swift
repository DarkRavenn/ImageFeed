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
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, что бы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
}
