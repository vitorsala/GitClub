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
    @IBOutlet weak var loadingView: UIVisualEffectView!
    @IBOutlet weak var acitivyIndicator: UIActivityIndicatorView!

    @IBOutlet weak var test: UIView!

    var user: UITextField?
    var username: String?
    var data : Array<Project>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadGitRepositories:", name: "updateDidFinished", object: nil)

        let userDefault = NSUserDefaults()
        username = userDefault.objectForKey("username") as? String
        if username == nil {
            userInputAlert()
        }
        else{
            println(username)
            data = ProjectManager.sharedInstance.Project()!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func showLoading(){
        self.loadingView.hidden = false
        self.test.hidden = false
        self.acitivyIndicator.startAnimating()
    }

    func hideLoading(){
        self.acitivyIndicator.stopAnimating()
        self.test.hidden = true
        self.loadingView.hidden = true
    }

    @IBAction func changeUser(sender: AnyObject) {
        userInputAlert()
    }

    @IBAction func forceUpdate(){
        println("update")
        self.showLoading()
        GitManager.sharedInstance.checkGitRepositories(self.username!)
    }

    /**
    Método que será chamado via notificação "updateDidFinished"

    :param: notification
    */
    func reloadGitRepositories(notification : NSNotification){

        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            self.data = ProjectManager.sharedInstance.Project()
            self.tableView.reloadData()
            self.hideLoading()
        })

        println("updated")
    }

    func userInputAlert(){
        var alertController = UIAlertController(title: "Usuário", message: nil, preferredStyle: .Alert)

        let buttonOk: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
            self.username = self.user?.text
            ProjectManager.sharedInstance.deleteAll()
            NSUserDefaults().setObject(self.username, forKey: "username")
            ProjectManager.sharedInstance.deleteAll()
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

    