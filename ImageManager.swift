//
//  ImageManager.swift
//  Just Cook
//
//  Created by lei zhang on 2017-01-16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import Foundation
import UIKit

class ImageManager: NSObject, URLSessionDelegate {
    
    typealias CompletionHandler = () -> ()
    
    var completionHandlers = [String: CompletionHandler]()
    
    var sessions = [String: URLSession]()
    
    static let sharedManager = ImageManager()
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let identifier = session.configuration.identifier {
            if let completionHandler = completionHandlers[identifier] {
                completionHandler()
                completionHandlers.removeValue(forKey: identifier)
            }
            sessions.removeValue(forKey: identifier)
            print("backgound session has finished")
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("background session has an error" + (error?.localizedDescription)!)
    }
    
    func uploadImages(_ images: [UIImage], name: String, recipeID: String, orderID: String?) {
        
        print("Start Upload")
        
        guard let url = URL(string: Constants.SERVER + Constants.IMAGE_SERVICE) else {
            return
        }
        var request = URLRequest(url: url)
        
        let identifier = name + "_" + recipeID
        
        let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = directoryURL.appendingPathComponent(identifier)
        
        let filePath = fileURL.path
        
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        
        let file = FileHandle(forWritingAtPath: filePath)!
        
        var bodys = Array<Dictionary<String, String>>()
        
        for i in 0..<images.count {
            let data = UIImagePNGRepresentation(images[i])
            let base64: String! = data?.base64EncodedString()
            bodys.append(["data": base64, "desc": name + "_\(i)" ])
        }
        
        do {
            let json = try JSONSerialization.data(withJSONObject: ["images": bodys, "dbID": recipeID, "orderID": orderID ?? ""], options: .prettyPrinted)
            file.write(json)
        } catch {
            print(error.localizedDescription)
        }
       
        file.closeFile()
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        sessions[identifier] = session
        
        request.httpMethod = "POST"

        session.uploadTask(with: request, fromFile: fileURL).resume()
    }
}







