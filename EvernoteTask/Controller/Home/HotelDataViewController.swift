//
//  HotelDataViewController.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

class HotelDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let TABLE_CELL_TAGS = (hotelImage:10, hotelTitle:20,hotelAddress:30)
    var dataArray: [HotelData] = []
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        navigationItem.hidesBackButton = true
        getHotelDetails()
       self.tableView.tableFooterView = UIView()
      //  UserDefaults.standard.set(nil, forKey: Constants.FACEBOOK_LOGOUT)
    }
    func getHotelDetails() {
        NetworkCalls.retrieveHotelDetails(successBlock: { (results: Any) in
           
            if let _result = results as? [String : Any] {
                if let status = _result["status"] as? Int, status == 200 {
                    if let data = _result["data"] as? [[String : Any]] {
                        for items in data {
                            let hotelDetails = HotelData.init(withDictionary: items)
                            self.dataArray.append(hotelDetails)
                        }
                    }
                }
            }
            DispatchQueue.main.sync(execute: {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
           
        })
        { (errorCode: Int, error: String) in
            print("HotelData | error : \(error)")
            DispatchQueue.main.sync(execute: {
                self.activityIndicator.stopAnimating()
            })
          //  completionBlock(false, errorCode)
        }
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
         UserDefaults.standard.setValue("logout_success", forKey:Constants.FACEBOOK_LOGOUT)
         UserDefaults.standard.setValue(nil, forKey: "user_facebookauth_token")
         UserDefaults.standard.setValue(nil, forKey: "user_facebook_email")
        self.navigationController?.popToRootViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cellConfiguration(cell: cell, data: dataArray[indexPath.row],indexpath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailVC", sender: indexPath);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailVC") {
            let controller = segue.destination as? DetailsViewController
            let row = (sender as! NSIndexPath).row
            let patientQuestionnaire = self.dataArray[row]
            controller?.hotelDetails = patientQuestionnaire
        }
    }
    func cellConfiguration(cell:UITableViewCell,data:HotelData,indexpath: IndexPath) {
        let image = cell.viewWithTag(TABLE_CELL_TAGS.hotelImage) as! UIImageView
        image.layer.cornerRadius = image.bounds.height / 2.0
        Utils.bottomCellHeight(cell: cell)
        image.clipsToBounds = true
       Utils.setTableCellImageViewImage(cell: cell, imageViewTag: TABLE_CELL_TAGS.hotelImage, imageUrlString: data.image?["small"] ?? "")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.hotelTitle, text: "\(data.title ?? "")")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.hotelAddress, text:data.address ?? "No address")
       
    }
    
}
