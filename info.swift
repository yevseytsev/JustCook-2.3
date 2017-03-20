//
//  info.swift
//  Just Cook
//
//  Created by Andriy Yevseytsev on 2016-авг.-3.
//  Copyright © 2016 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class info: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.translucent = true
        
         self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
         self.navigationController?.navigationBar.shadowImage = nil
         self.navigationController?.navigationBar.translucent = false
         self.navigationController?.navigationBar.tintColor = nil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
