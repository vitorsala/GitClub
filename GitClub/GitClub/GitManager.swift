//
//  GitManager.swift
//  GitClub
//
//  Created by João Marcos on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
    
class GitManager{
    static let sharedInstance : GitManager = GitManager()
    private init(){}


    func getUserInfo(username : String){
        
        let key = "?client_id=7d779a951ee19719efe8&client_secret=f9f8dd209bf721833eeff1953840c5b4b0c561ac"

        let link = "https://api.github.com/users/\(username)/repos"+key
        let url = NSURL(string: link)
        var data = NSData(contentsOfURL: url!)
        if data == nil {
            return
        }
        var parseErro: NSError?
        let parseUser = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray
        var name : String?
        
        for i in parseUser{
            if let repoName = i.objectForKey("name") as? String{
                name = repoName
            }
            if let repos = i.objectForKey("url") as? String{
                if let fork = i.objectForKey("fork") as? Bool{
                    if fork == true{
                        let urlMack = NSURL(string: repos+key)
                        var dataMack = NSData(contentsOfURL: urlMack!)
                        if dataMack != nil{
                            let parseMack = NSJSONSerialization.JSONObjectWithData(dataMack!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSDictionary
                            if let parent = parseMack.objectForKey("parent") as? NSDictionary{
                                if let owner = parent.objectForKey("owner") as? NSDictionary{
                                    if let login = owner.objectForKey("login") as? String{
                                        if login == "mackmobile"{

                                            let urlRepo = NSURL(string: "https://api.github.com/repos/mackmobile/\(name!)/issues"+key)
                                            var dataRepo = NSData(contentsOfURL: urlRepo!)
                                            if dataRepo != nil{
                                                let parseRepo = NSJSONSerialization.JSONObjectWithData(dataRepo!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray
                                                for issue in parseRepo{
                                                    if let issueUser = issue["user"] as? NSDictionary{                                                        if let issueLogin = issueUser["login"] as? String{
                                                            if username == issueLogin{
                                                                //_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
                                                                if let issueLabels = issue["labels"] as? NSArray{
                                                                    for labels in issueLabels{
                                                                        if let labelName = labels["name"] as? String{
                                                                            println(labelName)//_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

