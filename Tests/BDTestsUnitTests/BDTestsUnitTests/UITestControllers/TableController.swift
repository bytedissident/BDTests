//
//  TableController.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 8/2/18.
//  Copyright © 2018 Derek Bronston. All rights reserved.
//

import UIKit

class TableController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tView: UITableView!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.dataSource = self
        tView.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = "cell \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        testLabel.text = "Test Value"
    }

}
