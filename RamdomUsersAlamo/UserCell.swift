//
//  UserCell.swift
//  RamdomUsersAlmo
//
//  Created by Daniel Lahoz on 14/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol UserCellDelegate: class {
    func didTouchFavorite(_ sender: UserCell)
    func didTouchPhoto(_ sender: UserCell)
    func didRemove(_ sender: UserCell)
}

class UserCell: UICollectionViewCell {

    weak var delegate: UserCellDelegate?

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!

    @IBOutlet weak var progressbar: UIProgressView!

    var imageTask: DataRequest?
    var fileTask: URLSessionDownloadTask?

    var photo: User? {
        didSet {
            imageTask?.cancel()

            photo?.delegate = self
            progressbar.isHidden = true

            //print("User: \(photo?.description)")
            if let name = photo?.name, let surname = photo?.surname, let email = photo?.email, let phone = photo?.phone {
                nameLabel.text = "\(name) \(surname)"
                emailLabel.text = email
                phoneLabel.text = phone
            }

            if photo?.favorite == true {
                favoriteButton.setTitleColor(UIColor.green, for: UIControlState())
            } else {
                favoriteButton.setTitleColor(UIColor.purple, for: UIControlState())
            }

            if let storedImage = photo?.image {
                self.photoImageView.image = storedImage
                return
            }

            guard let photoUrl = photo?.photoUrl else {
                self.photoImageView.image = UIImage(named: "Downloading")
                return
            }

            imageTask = Alamofire.request(photoUrl).downloadProgress { progress in
                    DispatchQueue.main.async {
                        self.progressbar.isHidden = false
                        self.progressbar.progress = Float(progress.fractionCompleted)
                    }
                }.responseImage { response in
                debugPrint(response)

                switch response.result {
                case .success:
                    if let image = response.result.value {
                        //print("image downloaded: \(image)")
                        DispatchQueue.main.async {
                            self.progressbar.isHidden = true
                            self.photoImageView.image = image
                            self.photo?.image = image.copy() as? UIImage
                        }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.photoImageView.image = UIImage(named: "Broken")
                    }
                }

            }

        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photo?.delegate = nil
        photo = nil
    }

    @IBAction func touchPhoto(_ sender: AnyObject) {
        delegate?.didTouchPhoto(self)
    }

    @IBAction func touchRemove(_ sender: AnyObject) {
        delegate?.didRemove(self)
    }

    @IBAction func touchFavorite(_ sender: AnyObject) {
        delegate?.didTouchFavorite(self)
    }

    @IBAction func touchFile(_ sender: AnyObject) {
        self.photo?.downloadFile()
    }

}

extension UserCell: UserDelegate {

    func isDownloading(_ progress: Float, email: String) {

        if progress < 0.99 {
            self.progressbar.isHidden = false
            self.progressbar.progress = progress
            print("lblemail: \(String(describing: self.emailLabel.text))")
        } else {
            self.progressbar.isHidden = true
        }

    }

}
