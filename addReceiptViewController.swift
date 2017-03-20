//
//  mainDishInfoViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-Aug-11.
//  Copyright © 2016 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import CoreData

class addReceiptViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //transparanting navigation bar
        //
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.3843, green: 0.7647, blue: 0.1922, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 28)!,   NSForegroundColorAttributeName: UIColor(red: 0.3843, green: 0.7, blue: 0.1922, alpha: 1)]
        //
        //
        //
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

