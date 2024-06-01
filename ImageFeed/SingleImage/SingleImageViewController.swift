//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 01.06.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2 
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
