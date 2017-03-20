//
//  printViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-7.
//  Copyright © 2016 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import CoreData

class printViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var comingThisFallLabel: UILabel!
    
    //
    //sent Pre-order email
    //
    @IBAction func sendEmailButtonTapped(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["jcbookorder@gmail.com"])
        mailComposerVC.setSubject("Pre-order for JustCook Book!")
        mailComposerVC.setMessageBody("I want to Pre-Order JustCook Book with my own receipts!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    //
    //
    //
    
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //
        // fittin label sizes
        //
        comingThisFallLabel.numberOfLines = 2
        comingThisFallLabel.adjustsFontSizeToFitWidth = true
        
        //
        //
        //
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3843, green: 0.7647, blue: 0.1922, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 28)!,   NSForegroundColorAttributeName: UIColor(red: 0.3843, green: 0.7647, blue: 0.1922, alpha: 1)]

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
