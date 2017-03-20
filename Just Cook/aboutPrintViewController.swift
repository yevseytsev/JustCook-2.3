//
//  aboutPrint.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-7.
//  Copyright © 2016 Andriy Yevseytsev. All rights reserved.
//


import UIKit
import Foundation
import CoreData

class aboutPrintViewController: UIViewController {
   
    @IBOutlet weak var Description: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        //
        //
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3843, green: 0.7647, blue: 0.1922, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 28)!,   NSForegroundColorAttributeName: UIColor(red: 0.3843, green: 0.7647, blue: 0.1922, alpha: 1)]
        //
        // fittin label sizes
        //
        Description.numberOfLines = 10
        Description.adjustsFontSizeToFitWidth = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
