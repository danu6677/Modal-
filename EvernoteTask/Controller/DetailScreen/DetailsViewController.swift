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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        configureBarButton()
        let url : NSMutableString =  NSMutableString(string: hotelDetails?.image!.small! ?? "")
        url.insert("s", at: 4)
        Utils.setImageViewImage(forImageView: imageView, withImageUrl: url as String)
       titleLabel.text = hotelDetails?.title
       descriptionLabel.text = hotelDetails?.descriptionData
    }
    private func configureBarButton() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "location_icon"), for: .normal)
        button.addTarget(self, action:#selector(addTapped), for:.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    @objc func addTapped(sender: AnyObject) {
        //once the location Icontapped
        performSegue(withIdentifier: "ShowMap", sender: nil)
        print("tapped Bar button")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMap") {
//            let vc = segue.destination as! MapViewController
//            vc.locationDetails  = hotelDetails
        }
    }
}
