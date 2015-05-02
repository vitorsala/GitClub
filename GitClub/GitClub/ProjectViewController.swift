//
//  ProjectViewController.swift
//  GitClub
//
//  Created by João Marcos on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var data : Array<Challenge>?
    var repoName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var projectResult = ProjectManager.sharedInstance.Project(NSPredicate(format: "name = '\(repoName!)'"))
        
        self.navigationItem.title = repoName
        
        data = projectResult?.first?.hasChallenge.allObjects as? Array<Challenge>
        data?.sort({ (first: Challenge, second: Challenge) -> Bool in
            return first.challengeDescription.localizedCaseInsensitiveCompare(second.challengeDescription) == NSComparisonResult.OrderedAscending
        })

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CellLabels = self.tableView.dequeueReusableCellWithIdentifier("cellLabels", forIndexPath: indexPath) as! CellLabels
        
        cell.lblLabels.text = self.data?[indexPath.row].challengeDescription
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data == nil{
            return 0
        }
        return  self.data!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
