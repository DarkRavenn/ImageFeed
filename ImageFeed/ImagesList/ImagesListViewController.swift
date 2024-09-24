//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 02.05.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(_ indexPaths: [IndexPath])
    func setLikeLoadingState(_ isLoading: Bool)
    func setCellIsLiked(_ cell: IndexPath, _ isLiked: Bool)
    func showAlert(title: String, message: String)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom:12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.didPhotosUpdate()
        }
        presenter?.fetchPhotosNextPage()
        
    }
    
    // MARK: - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.photo = presenter?.photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public Methods
    func updateTableViewAnimated(_ indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: - Extansion
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPatch: IndexPath) {
        guard
            let photo = presenter?.photos[indexPatch.row],
            let imageUrl = URL(string: photo.thumbImageURL)
        else { return }
        
        cell.changeCellImage(imageUrl)
        cell.changeDateLabel(photo.createdAt != nil ? dateFormatter.string(from: photo.createdAt!) : "")
        cell.changeLikeButton(photo.isLiked)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getCellHeight(tableView.bounds.width, indexPath.row) ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        if testMode { return }
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(indexPath)
    }
    
    func setCellIsLiked(_ indexPath: IndexPath, _ isLiked: Bool) {
            guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
            cell.setIsLiked(isLiked)
        }

    func setLikeLoadingState(_ isLoading: Bool) {
        if isLoading {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
