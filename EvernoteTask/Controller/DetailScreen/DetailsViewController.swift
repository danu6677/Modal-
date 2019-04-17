//
//  DetailsViewController.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/28/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
 var hotelDetails : HotelData?
    var addButton: UIBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(addTapped))

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = self.addButton
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
       
        navigationItem.rightBarButtonItems = [add]
         let url  = URL(string: (hotelDetails?.image!["small"])!)
        print(url!)
        if let url  = URL(string: (hotelDetails?.image!["small"])!) {
            print(url)
            imageView.contentMode = .scaleAspectFit
            downloadImage(from: url)
        }
       titleLabel.text = hotelDetails?.title
       descriptionLabel.text = hotelDetails?.descriptionData
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    @objc func addTapped(sender: AnyObject) {
        performSegue(withIdentifier: "ShowMap", sender: nil)
        print("tapped")
        
    }

}
