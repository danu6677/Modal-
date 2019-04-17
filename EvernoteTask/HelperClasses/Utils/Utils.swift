//
//  Utils.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

class Utils: NSObject {
    static func setTableCellLabelText(cell: UITableViewCell, labelTag:Int?, text: Any){
        if labelTag != nil{
            let label = cell.viewWithTag(labelTag!)
            (label as! UILabel).text = text as? String;
        }else {
            cell.textLabel?.text = text as? String;
        }
    }
    
    static func handleWebserviceErrors (errorCode:Int,activityIndicator: UIActivityIndicatorView, presentVC:UIViewController,alertActionMesasage:String) {
        DispatchQueue.main.sync(execute: {
            activityIndicator.stopAnimating()
            
            if errorCode == Constants.STATUS_CODE_UNAUTHORIZED {
                print("UNAUTHORIZED")
                
            }
            else if Constants.STATUS_CODE_SERVER_ERROR_RANGE.contains(errorCode) {
                addReloadAlert(message: Constants.SERVER_ERROR_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
            }
            else if errorCode == Constants.ERROR_CODE_INTERNET_OFFLINE || errorCode == Constants.ERROR_CODE_NETWORK_CONNECTION_LOST {
                addReloadAlert(message: Constants.INTERNET_OFFLINE_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
            }
            else {
                addReloadAlert(message: Constants.UNKNOWN_ERROR_MESSAGE,presentVC:presentVC,alertActionMesasage:alertActionMesasage)
            }
        })
    }
    static func addReloadAlert(message: String,presentVC:UIViewController,alertActionMesasage:String) {
        let alertController = UIAlertController(title: Constants.ERROR_TITLE, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:alertActionMesasage, style: UIAlertAction.Style.default, handler: { alertAction in
            alertController.dismiss(animated: true, completion: nil)
        }))
        presentVC.present(alertController, animated: true, completion: nil)
    }
    
    static func setTableCellImageViewImage(cell: UITableViewCell, imageViewTag:Int, imageUrlString: Any,tableViewName:UITableView? = nil, indexpath:IndexPath? = nil){
     
        if let imagePathString = imageUrlString as? String {
            (cell.viewWithTag(imageViewTag) as! UIImageView).imageFromServerURL(urlString: imagePathString)
        }
    }
    static func setImageViewImage(forImageView: UIImageView, withImageUrl: String){
        (forImageView).imageFromServerURL(urlString: withImageUrl)
    }
    
    static func bottomCellHeight(cell:UITableViewCell) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        let borderLayer = CALayer()
        let lineHeight:CGFloat = 1.0
        borderLayer.frame = CGRect(x: 10, y: cell.frame.height - lineHeight , width: UIScreen.main.bounds.width-20, height: lineHeight)
        borderLayer.backgroundColor = UIColor(red: 130/255, green: 130/255, blue:130/255, alpha: 0.2).cgColor//#828282
        cell.layer.addSublayer(borderLayer)
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    
    public func imageFromServerURL(urlString: String) {
        var imageURLString : String?
        imageURLString = urlString
        
        if let url = URL(string: urlString) {
            
            image = nil
            
            
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
                
                self.image = imageFromCache
                
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil{
                    print(error as Any)
                    
                    
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let imgaeToCache = UIImage(data: data!){
                        
                        if imageURLString == urlString {
                            self.image = imgaeToCache
                            
                        }
                        
                        imageCache.setObject(imgaeToCache, forKey: urlString as AnyObject)// calls when scrolling
                    }
                })
            }) .resume()
        }
    }
    
}
