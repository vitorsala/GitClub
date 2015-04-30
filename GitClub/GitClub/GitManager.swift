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

    /**
    Atualiza os dados do Git e lança uma notificação avisando que a operação foi concluido

    Lança a notificação "updateDidFinished" contendo o dicionário [String : Array<String>]; nil se não encontrar nada ou falhar

    :param: username - String contendo o username do usuário
    */
    func getUserInfo(username : String){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let notificationManager : NSNotificationCenter = NSNotificationCenter.defaultCenter()

            let key = "?client_id=7d779a951ee19719efe8&client_secret=f9f8dd209bf721833eeff1953840c5b4b0c561ac"

            let link = "https://api.github.com/users/\(username)/repos"+key
            var data = NSData(contentsOfURL: NSURL(string: link)!)

            if data == nil {
                notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                return
            }

            var parseErro: NSError?
            let parseUser = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray

            var resultSet: Dictionary = [String : Array<String>]()
            
            for i in parseUser{
                let repoName = i["name"] as! String
                if (i["fork"] as! Bool){
                    let repoUrl : String! = i["url"] as! String
                    let urlMack = NSURL(string: repoUrl+key)
                    let dataMack = NSData(contentsOfURL: urlMack!)

                    if dataMack == nil{
                        notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                        return
                    }

                    let parseMack = NSJSONSerialization.JSONObjectWithData(dataMack!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSDictionary

                    if ((((parseMack["parent"] as! NSDictionary)["owner"] as! NSDictionary)["login"] as! String) == "mackmobile"){

                        let urlRepo = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/issues"+key)
                        var dataRepo = NSData(contentsOfURL: urlRepo!)

                        if dataRepo == nil{
                            notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                            return
                        }

                        let parseRepo = NSJSONSerialization.JSONObjectWithData(dataRepo!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray
                        for issue in parseRepo{
                            if(username == ((issue["user"] as! NSDictionary)["login"] as! String)){

    //                            println(repoName)//_-_-_-_-_-_-_-_-_-_-_-_-_-
                                resultSet[repoName] = []

                                for labels in issue["labels"] as! NSArray{

    //                                println(labels["name"] as! String)//_-_-_-_-_-_-_-_-_-_-_-_-_-
                                    resultSet[repoName]?.append(labels["name"] as! String)

                                }
                            }
                        }
                    }
                }
            }
            notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: resultSet)
        })
    }
}

