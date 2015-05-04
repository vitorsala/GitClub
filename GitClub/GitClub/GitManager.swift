//
//  GitManager.swift
//  GitClub
//
//  Created by João Marcos on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation

var date1, date2 : NSDate?

class GitManager{
    static let sharedInstance : GitManager = GitManager()
    private init(){}

    /**    
    Atualiza os dados do Git

    Estrutura do dicionário

    :Estrutura:
    - [String : Array]  -> Dicionário cuja chave é "result", não tem outra chave.
    - - [Dictionary]    -> Array de dicionários contendo repositórios forkado do mackmobile.
    - - - [Array : AnyObject]   -> Dicionário contendo as informações de cada um dos repositórios.
    
    :Chaves para o dicionário do projeto:
    - "name" : Retorna uma String contendo o nome do repositório.
    - "labels" : Retorna uma array de dicionários contendo informações de cada uma das labels.
    - - "name" : Retorna o nome da label.
    - - "color" : Retorna o código de cor (usado pelo GitHub) da determinada label.

    :param: username - String contendo o username no qual deve executar a busca
    :return: Dictionary<String,AnyObject>
    */
    private func getUserInfo(username : String) -> Dictionary<String,AnyObject>?{

        // Chave de autenticação
        let key = "?client_id=7d779a951ee19719efe8&client_secret=f9f8dd209bf721833eeff1953840c5b4b0c561ac"

        let link = "https://api.github.com/users/\(username)/repos\(key)&type=all"
        var data = NSData(contentsOfURL: NSURL(string: link)!)

        if data == nil {
            return nil
        }

        var parseErro: NSError?
        let parseUser = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray

        var resultSet: Dictionary = [String : AnyObject]()

        var resultArray : Array<Dictionary<String,AnyObject>> = []

        for userRepo in parseUser{
            let repoName = userRepo["name"] as! String
            if (userRepo["fork"] as! Bool){
                let repoUrl : String! = (userRepo["url"] as! String)+key
                let urlMack = NSURL(string: repoUrl)
                let dataMack = NSData(contentsOfURL: urlMack!)

                if dataMack == nil{
                    return nil
                }
                let parseMack = NSJSONSerialization.JSONObjectWithData(dataMack!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSDictionary

                if(((parseMack["parent"] as! NSDictionary)["owner"] as! NSDictionary)["login"] as! String == "mackmobile"){
                    let urlRepo = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/issues\(key)&creator=\(username)")

                    println(urlRepo)

                    var dataRepo = NSData(contentsOfURL: urlRepo!)

                    if dataRepo == nil{
                        return nil
                    }

                    let parseRepo = NSJSONSerialization.JSONObjectWithData(dataRepo!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray

                    for issue in parseRepo{
                        let creationDate = userRepo["created_at"] as! String

                        var repos : Dictionary<String,AnyObject> = ["name":repoName]
                        repos["date"] = creationDate

                        var labelList : Array<Dictionary<String,String>> = []
                        for labels in issue["labels"] as! NSArray{
                            var formatedLabel : Dictionary<String,String> = [:]
                            formatedLabel["name"] = labels["name"] as? String
                            formatedLabel["color"] = labels["color"] as? String
                            labelList.append(formatedLabel)
                        }
                        repos["labels"] = labelList
                        resultArray.append(repos)
                    }
                }
                
            }
        }
        resultSet["result"] = resultArray
        return resultSet
    }

    /**
    Persiste os dados do Git no CoreData
    */
    func checkGitRepositories(username:String){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in

            let notificationManager : NSNotificationCenter = NSNotificationCenter.defaultCenter()

            let gitData = self.getUserInfo(username)
            
            if gitData == nil{
                notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                return
            }
            let projMan : ProjectManager = ProjectManager.sharedInstance
            let chalMan : ChallengeManager = ChallengeManager.sharedInstance

            var hasChange = false
            var changeCount = 0

            if(gitData != nil){
                let projectList : Array = gitData!["result"] as! Array<Dictionary<String,AnyObject>>

                for projectData in projectList{

                    var project : Project?

                    let projectName = projectData["name"] as! String

                    let projectResult = projMan.Project(NSPredicate(format: "name = '\(projectName)'"))

                    var challenge : Challenge?
                    var challengeResult : NSSet?
                    if projectResult == nil || projectResult?.count == 0{
                        project = projMan.newProject()
                        project!.name = projectName
                        hasChange = true
                    }
                    else{
                        project = projectResult?.first
                        challengeResult = project?.hasChallenge
                    }

                    let challengeList : Array = projectData["labels"] as! Array<Dictionary<String,AnyObject>>

                    for challengeData in challengeList{

                        if(challengeResult != nil && challengeResult?.count > 0){
                            var isPresent = false
                            for c : Challenge in challengeResult!.allObjects as! Array<Challenge>{
                                if c.challengeDescription == challengeData["name"] as! String{
                                    isPresent = true
                                }
                            }
                            if(!isPresent){
                                let temp = chalMan.newChallenge()
                                temp.challengeDescription = challengeData["name"] as! String
                                project?.addChallenge(temp)
                                hasChange = true
                                changeCount++
                            }
                        }
                        else{
                            let temp = chalMan.newChallenge()
                            temp.challengeDescription = challengeData["name"] as! String
                            project?.addChallenge(temp)
                            hasChange = true
                            changeCount++
                        }
                        
                    }
                    
                }
                
            }

            projMan.save()

            BackgroundManager.sharedInstance.hasUpdate = hasChange

            notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: ["hasChange":hasChange,"changeCount":changeCount])

        })
    }
}

