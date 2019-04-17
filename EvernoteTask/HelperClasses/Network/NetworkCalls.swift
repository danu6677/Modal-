//
//  NetworkCalls.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

class NetworkCalls: NSObject {

    typealias SuccessBlock = (Any) -> Void
    typealias FailureBlock = (_ errorCode: Int, _ error: String) -> Void
    
    private  let NETWORK_REQUEST_TYPES = (G: "GET", P: "POST", U: "PUT", D: "DELETE")
    private  let RESPONSE_STRUCTURE = (A: "Array", D: "Dictonary", O: "Other_for_testing")
    
    ///Singleton
    private static var networkCalls:NetworkCalls?;
    
    private override init() {
    }
    
    public static var shared:NetworkCalls {
        if networkCalls == nil{
            networkCalls = NetworkCalls ()
        }
        return networkCalls!
    }
    private func performWebServiceRequest <T : Codable>(type: T.Type,with url: URL, methodType: String, paramData: Data!, requestOptions: [[String]]!, responseStructure: String, successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) {
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = methodType // As in "POST", "GET", "PUT" or "DELETE"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        if paramData != nil {
            request.httpBody = paramData
        }
        
        if requestOptions != nil {
            for ro in requestOptions {
                request.addValue(ro[1], forHTTPHeaderField: ro[0])
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data: Data = data, let response: URLResponse = response, error == nil else {
                print("WebServiceCall performWebServiceRequest | error : \(String(describing: error!))")
                print("WebServiceCall performWebServiceRequest | error code : \((error! as NSError).code)")
                
                // Handling Network unavailability
                if (error! as NSError).code == Constants.ERROR_CODE_INTERNET_OFFLINE || (error! as NSError).code == Constants.ERROR_CODE_NETWORK_CONNECTION_LOST {
                    failureBlock(Constants.ERROR_CODE_INTERNET_OFFLINE, Constants.INTERNET_OFFLINE_MESSAGE)
                }
                else if (error! as NSError).code == Constants.ERROR_CODE_REQUEST_TIMEOUT {
                    // TEMP: TODO:
                    failureBlock(Constants.STATUS_CODE_SERVER_GATEWAY_TIMEOUT, Constants.SERVER_ERROR_MESSAGE)
                }
                else {
                    failureBlock(0, Constants.UNKNOWN_ERROR_MESSAGE)
                }
                return
            }
            
            let responseStatusCode = (response as! HTTPURLResponse).statusCode
            print("WebServiceCall webServiceRequestOther | response status code : \(responseStatusCode)")
            
            if Constants.STATUS_CODE_REQUEST_SUCCESS_RANGE.contains(responseStatusCode) {
                if responseStructure == self.RESPONSE_STRUCTURE.A {
                    // JSON De-Serialization if anticipated response data structure is Array
                    do {
                        let result = try JSONDecoder().decode(type, from: data)
                        successBlock(result)
                        
                    }
                    catch {
                        print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Array")
                        failureBlock(0, Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE)
                    }
                }
                else if responseStructure == self.RESPONSE_STRUCTURE.D {
                    // JSON De-Serialization if anticipated response data structure is Dictionary
                    do {
                        let result = try JSONDecoder().decode(type, from: data)
                        successBlock(result)
                        
                    }
                    catch {
                        print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Dictionary")
                        failureBlock(0, Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE)
                    }
                }
                else {
                    if let resultString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        successBlock(resultString)
                    }
                    else {
                        print("WebServiceCall webServiceRequestOther | Error In Json response De-serialization - Other")
                        failureBlock(0, Constants.RESPONSE_DE_SERIALIZATION_ERROR_MESSAGE)
                    }
                }
            }
            else {
                failureBlock(responseStatusCode, "Some Error")
            }
        }
        task.resume()
    }
    
    //Class methods to access the server calls 
    func retrieveDoctors(successBlock: @escaping SuccessBlock, failureBlock: @escaping FailureBlock) {
        let url = URL(string: Config.GET_HOTELS_DATA)
        performWebServiceRequest(type: Result.self,with: url!, methodType: NETWORK_REQUEST_TYPES.G, paramData: nil, requestOptions: nil, responseStructure: RESPONSE_STRUCTURE.D, successBlock: successBlock, failureBlock: failureBlock)
    }
    

}
