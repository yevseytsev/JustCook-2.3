//
//  OrderViewController.swift
//  Just Cook
//
//  Created by Excellence on 11/24/16.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    @IBOutlet weak var typeOne: UIButton!
    @IBOutlet weak var typeTwo: UIButton!
    @IBOutlet weak var typeThree: UIButton!
    var order = Order()

    @IBAction func One(_ sender: Any) {
        order.book_type = 1
    }
    
    @IBAction func Two(_ sender: Any) {
        order.book_type = 2
    }
    
    @IBAction func Three(_ sender: Any) {
        order.book_type = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! orderDetailsViewController
        nextVC.order = order
    }
}
