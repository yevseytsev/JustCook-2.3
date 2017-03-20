//
//  SearchResultTableViewController.swift
//  Just Cook
//
//  Created by lei zhang on 2017-01-02.
//  Copyright © 2017 Andriy Yevseytsev. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController, Transportable, Serachable, UISearchBarDelegate {

    let coreDataManeger = CoreDataManeger.sharedManager
    
    var result = [RecipeIndex]()
    
    var meal: Meal!
    
    var name: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200
        
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.placeholder = NSLocalizedString("Search by Name", comment: "-")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparent.png"), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparent.png")
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false

        let backgroundImage = UIImage(named: "fon_eda.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundColor = UIColor.clear

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(download))

    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        startSearch()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        startSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        result.removeAll()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            result.removeAll()
            tableView.reloadData()
        }
    }
    
    func startSearch() {
        guard searchBar.text != nil else {
            return
        }
        
        guard (searchBar.text?.characters.count)! > 0 else {
            return
        }
        
        name = searchBar.text
        
        searchByName {
            (result, errorMsg) in
            guard errorMsg == nil else {
                self.prompt(error: errorMsg!)
                return
            }
            self.result = result
            self.tableView.reloadData()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell

        cell.dishName.text = result[indexPath.row].name
        cell.id = result[indexPath.row].id
        cell.auth.text = result[indexPath.row].auth
        cell.type.text = result[indexPath.row].type

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = result[indexPath.row].id
        
        if let recipe = coreDataManeger.fetchRecipeBy(id) {
            let detailedTV = self.storyboard?.instantiateViewController(withIdentifier: "DetailedView") as! DetailedTableViewController
            
            detailedTV.recipe = recipe
            detailedTV.downloadable = true
            
            navigationController?.pushViewController(detailedTV, animated: true)
            
            return
        }
        
        let loadingView = UIView(frame: self.view.frame)
        loadingView.backgroundColor = UIColor.clear
        loadingView.backgroundColor?.withAlphaComponent(0.1)
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = UIColor.black
        activityView.center = loadingView.center
        activityView.startAnimating()
        
        loadingView.addSubview(activityView)
        view.addSubview(loadingView)
        
        downloadRecipe(by: id) { (errMsg, recipe) in
            self.coreDataManeger.saveContext()
            activityView.removeFromSuperview()
            loadingView.removeFromSuperview()
            
            guard errMsg.characters.count <= 0  else {
                self.prompt(error: errMsg)
                return
            }
            
            let detailedTV = self.storyboard?.instantiateViewController(withIdentifier: "DetailedView") as! DetailedTableViewController
            
            detailedTV.recipe = recipe!
            detailedTV.meal = self.meal
            detailedTV.downloadable = true
            
            self.navigationController?.pushViewController(detailedTV, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
