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
    var dataArray:[HotelData]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "List View"
        SignInViewController.signinClicked = false
        activityIndicator.startAnimating()
        //Size of the activity indicator
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        navigationItem.hidesBackButton = true
        getHotelDetails()
       self.tableView.tableFooterView = UIView()
    
    }
    private func getHotelDetails() {
        //Get data from server
         NetworkCalls.shared.retrieveDoctors(successBlock: { (results: Any) in
            if let data = results as? Result, data.status == 200 {
                self.dataArray = data.data
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
        }
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
         UserDefaults.standard.setValue(nil, forKey:Constants.FACEBOOK_AUTH_TOKEN )
         UserDefaults.standard.setValue(nil, forKey: Constants.FACEBOOK_EMAIL)
         UserDefaults.standard.setValue(nil, forKey: Constants.FACEBOOK_USERNAME)
        self.navigationController?.popToRootViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cellConfiguration(cell: cell, data: (dataArray?[indexPath.row])!,indexpath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailVC", sender: indexPath);
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailVC") {
            let controller = segue.destination as? DetailsViewController
            let row = (sender as! NSIndexPath).row
            let data = self.dataArray![row]
            controller?.hotelDetails = data
        }
    }
   private func cellConfiguration(cell:UITableViewCell,data:HotelData,indexpath: IndexPath) {
        let image = cell.viewWithTag(TABLE_CELL_TAGS.hotelImage) as! UIImageView
        image.layer.cornerRadius = image.bounds.height / 2.0
        Utils.bottomCellHeight(cell: cell)
        image.clipsToBounds = true
    let urls : NSMutableString =  NSMutableString(string: (data.image?.small!)!)
        urls.insert("s", at: 4)
       Utils.setTableCellImageViewImage(cell: cell, imageViewTag: TABLE_CELL_TAGS.hotelImage, imageUrlString:  urls as String)
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.hotelTitle, text: "\(data.title ?? "")")
        Utils.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.hotelAddress, text:data.address ?? "No address")
    }
    
}
