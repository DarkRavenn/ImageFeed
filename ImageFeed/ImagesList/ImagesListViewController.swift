//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 02.05.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imageListService = ImagesListService.shared
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    var photos: [Photo] = [Photo(id: "jbmjneY3a6g",
                                 size: CGSize(width: 8736.0, height: 11648.0),
                                 createdAt: Date(),
                                 welcomeDescription: "Сервер сказал что его нет",
                                 thumbImageURL: "https://images.unsplash.com/photo-1721332155484-5aa73a54c6d2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjE4NDN8MXwxfGFsbHwxfHx8fHx8Mnx8MTcyNTU3MzAxMHw&ixlib=rb-4.0.3&q=80&w=200",
                                 largeImageURL: "https://images.unsplash.com/photo-1721332155484-5aa73a54c6d2?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjE4NDN8MXwxfGFsbHwxfHx8fHx8Mnx8MTcyNTU3MzAxMHw&ixlib=rb-4.0.3&q=85",
                                 isLiked: false),
                           Photo(id: "7bQIFzFlt18",
                                 size: CGSize(width: 2000.0, height: 3000.0),
                                 createdAt: Date(),
                                 welcomeDescription: "Сервер сказал что его нет",
                                 thumbImageURL: "https://images.unsplash.com/photo-1725492123815-576fcd133766?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjE4NDN8MHwxfGFsbHwyfHx8fHx8Mnx8MTcyNTU3MzAxMHw&ixlib=rb-4.0.3&q=80&w=200",
                                 largeImageURL: "https://images.unsplash.com/photo-1725492123815-576fcd133766?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjE4NDN8MHwxfGFsbHwyfHx8fHx8Mnx8MTcyNTU3MzAxMHw&ixlib=rb-4.0.3&q=85",
                                 isLiked: false)]
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageListServiceObserver = NotificationCenter.default    // 2
                    .addObserver(
                        forName: ImagesListService.didChangeNotification, // 3
                        object: nil,                                        // 4
                        queue: .main                                        // 5
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        
//                        print("Нотификация")
                        self.printPhotosArray()                                // 6
                    }
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom:12, right: 0)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier { //1
            guard
                let viewController = segue.destination as? SingleImageViewController, // 2
                let indexPath = sender as? IndexPath // 3
            else {
                assertionFailure("Invalid segue destination") // 4
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row]) // 5
            viewController.image = image // 6
        } else {
            super.prepare(for: segue, sender: sender) // 7
        }
    }
    
    private func printPhotosArray() {
        for photo in imageListService.photos {
            
            print("""
                  id: \(photo.id)
                  size: \(photo.size)
                  createdAt: \(photo.createdAt ?? Date())
                  welcomeDescription: \(photo.welcomeDescription ?? "Сервер сказал что его нет")
                  thumbImageURL: \(photo.thumbImageURL)
                  largeImageURL: \(photo.largeImageURL)
                  isLiked: \(photo.isLiked)
                  """)
            
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPatch: IndexPath) { 
        guard let image = UIImage(named: photosName[indexPatch.row]) else {
            return
        }
        
        cell.cellImage.image = image
        
        let gradientLayer = CAGradientLayer()
        let gradientHeight = 30.0
        let marginTopAndBottom = 8.0
        gradientLayer.frame = CGRect(x: 0, y: cell.frame.height - gradientHeight - marginTopAndBottom, width: cell.cellImage.bounds.width, height: gradientHeight)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        cell.cellImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        cell.cellImage.layer.addSublayer(gradientLayer)
        
        cell.dateLabel.text = dataFormatter.string(from: Date())
        
        let isLiked = indexPatch.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TODO: 
        if indexPath.row + 1 == photosName.count {
            print("Последний: \(indexPath)")
//            imageListService.fetchPhotosNextPage()
        } else {
            print("Не последний: \(indexPath)")
        }
        
    }
}
