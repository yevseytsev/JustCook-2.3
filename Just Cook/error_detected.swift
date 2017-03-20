//
//  error_detected.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Oct-24.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

extension UIViewController {
    func prompt(error: String!){
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "-"), message: error, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: false, completion: nil)
    }
    
    func promptComfirmation(msg: String!){
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: false, completion: nil)
    }
}
