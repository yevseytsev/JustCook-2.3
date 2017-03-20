//
//  ViewController.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-июля-28.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, FBLoginDelegate {
    
    @IBOutlet weak var addReceiptButton: UIButton!
    @IBOutlet weak var myCookBookButton: UIButton!
    @IBOutlet weak var order: UIButton!
    @IBOutlet weak var info: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var bugButton: UIBarButtonItem!
    @IBOutlet weak var facebookLoginBtn: EZHFacebookLoginButton!
    
    let coreDataManeger = CoreDataManeger.sharedManager
    
    func loginWith(_ username:String) {}
    func logout() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginBtn.LGdelegate = self

        addReceiptButton.titleLabel?.numberOfLines = 1
        addReceiptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        myCookBookButton.titleLabel?.numberOfLines = 1
        myCookBookButton.titleLabel?.adjustsFontSizeToFitWidth = true
        order.titleLabel?.numberOfLines = 1
        order.titleLabel?.adjustsFontSizeToFitWidth = true
        search.titleLabel?.numberOfLines = 1
        search.titleLabel?.adjustsFontSizeToFitWidth = true
        
        addReceiptButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        addReceiptButton.layer.shadowColor = UIColor.white.cgColor
        addReceiptButton.layer.shadowRadius = 2.0
        addReceiptButton.layer.shadowOpacity = 1.0
        addReceiptButton.layer.masksToBounds = false
        
        search.layer.shadowOffset = CGSize(width: 3, height: 3)
        search.layer.shadowColor = UIColor.white.cgColor
        search.layer.shadowRadius = 2.0
        search.layer.shadowOpacity = 1.0
        search.layer.masksToBounds = false
        
        myCookBookButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        myCookBookButton.layer.shadowColor = UIColor.white.cgColor
        myCookBookButton.layer.shadowRadius = 2.0
        myCookBookButton.layer.shadowOpacity = 1.0
        myCookBookButton.layer.masksToBounds = false
 
        order.layer.shadowOffset = CGSize(width: 3, height: 3)
        order.layer.shadowColor = UIColor.white.cgColor
        order.layer.shadowRadius = 2.0
        order.layer.shadowOpacity = 1.0
        order.layer.masksToBounds = false

        info.layer.shadowOffset = CGSize(width: 3, height: 3)
        info.layer.shadowColor = UIColor.white.cgColor
        info.layer.shadowRadius = 2.0
        info.layer.shadowOpacity = 1.0
        info.layer.masksToBounds = false

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-UltraLight", size: 28)!,   NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]
        
        UIApplication.shared.isStatusBarHidden = true
        bugButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparent.png")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }

    @IBAction func addRecipe(_ sender: Any) {
        let recipe = coreDataManeger.CreateRecipe()
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "dishMainInfoViewController") as! dishMainInfoViewController
        
        nextVC.recipe = recipe
    
        navigationController?.pushViewController(nextVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

