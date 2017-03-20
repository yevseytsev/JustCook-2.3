//
//  orderInfoViewController.swift
//  Just Cook
//
//  Created by Excellence on 11/19/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class orderInfoViewController: UIViewController {
    
    @IBOutlet weak var startingFrom: UILabel!
    @IBOutlet weak var phrase: UILabel!
    
    @IBAction func back(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        present(mainView!, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparent.png")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        startingFrom.layer.shadowOffset = CGSize(width: 0, height: 0)
        startingFrom.layer.shadowColor = UIColor.white.cgColor
        startingFrom.layer.shadowRadius = 5.0
        startingFrom.layer.shadowOpacity = 1
        startingFrom.layer.masksToBounds = false
 
        phrase.layer.shadowOffset = CGSize(width: 0, height: 0)
        phrase.layer.shadowColor = UIColor.white.cgColor
        phrase.layer.shadowRadius = 5.0
        phrase.layer.shadowOpacity = 1
        phrase.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
