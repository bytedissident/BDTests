//
//  TableTableViewController.swift
//  BDTestsUITests
//
//  Created by Derek Bronston on 6/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = "cell \(indexPath.row)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Alert Title", message: "Alert message.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "one", style: .default) { action in
            // perhaps use action.title here
        })
        
        alert.addAction(UIAlertAction(title: "two", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
