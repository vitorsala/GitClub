//
//  ViewController.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var user: UITextField?
    var username: String?
    var data : Array<Project>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadGitRepositories:", name: "updateDidFinished", object: nil)

        var userDefault = NSUserDefaults()
        username = userDefault.objectForKey("username") as? String
        if username == nil {
            alert()
        }
        else{
            data = ProjectManager.sharedInstance.Project()!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeUser(sender: AnyObject) {
        alert()
    }
    @IBAction func forceUpdate(){
        GitManager.sharedInstance.getUserInfo(self.username!)
    }
    
    func reloadGitRepositories(notification : NSNotification){
        var data: Dictionary<String, Array<String>>? = notification.userInfo as? [String : Array<String>]

        let projMan : ProjectManager = ProjectManager.sharedInstance
        let chalMan : ChallengeManager = ChallengeManager.sharedInstance

        if(data != nil){
            for (repoName, labelList) in data!{
                var project : Project?
                var projectResult = projMan.Project(NSPredicate(format: "name = '\(repoName)'"))

                var challenge : Challenge?
                var challengeResult : NSSet?

                if projectResult == nil || projectResult?.count == 0{
                    project = projMan.newProject()
                    project!.name = repoName
                }
                else{
                    project = projectResult?.first
                    challengeResult = project?.hasChallenge
                }
                println(repoName)
                for item : String in labelList{
                    if(challengeResult != nil && challengeResult?.count > 0){
                        var isPresent = false
                        for c:Challenge in challengeResult!.allObjects as! Array<Challenge>{
                            if c.challengeDescription == item{
                                isPresent = true
                            }
                        }
                        if(!isPresent){
                            let temp = chalMan.newChallenge()
                            temp.challengeDescription = item
                            project?.addChallenge(temp)
                        }
                    }
                    else{
                        let temp = chalMan.newChallenge()
                        temp.challengeDescription = item
                        project?.addChallenge(temp)
                    }
                    println(item)
                }
                projMan.save()
            }
        }
        self.data = projMan.Project()
        self.tableView.reloadData()
    }

    func alert(){
        var alertController = UIAlertController(title: "Usuário", message: nil, preferredStyle: .Alert)
        
        let buttonOk: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
//            println("User: \(self.user?.text)")
            NSUserDefaults().setObject(self.user?.text, forKey: "username")
            self.username = self.user?.text
            ProjectManager.sharedInstance.deleteAll()
            println(self.username)
            self.forceUpdate()
        }
        
        let buttonCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in}
        
        alertController.addAction(buttonOk)
        alertController.addAction(buttonCancel)
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Usuário GitHub"
            self.user = textField
        }
        
        self.presentViewController (alertController, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        cell.lblNome.text = self.data?[indexPath.row].name
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showProjectInfo"){
            let toVC : ProjectViewController = segue.destinationViewController as! ProjectViewController
            toVC.repoName = (sender as! TableViewCell).lblNome.text
        }
    }
}

    