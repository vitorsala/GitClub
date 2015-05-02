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
    Atualiza os dados, de forma assíncrona, do Git e lança uma notificação (Via notification center) avisando que a operação foi concluido

    Lança a notificação **updateDidFinished** contendo o dicionário com o resultado da busca; **nil** se não encontrar nada ou falhar

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
    */
    func getUserInfo(username : String){

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let notificationManager : NSNotificationCenter = NSNotificationCenter.defaultCenter()

            // Chave de autenticação
            let key = "?client_id=7d779a951ee19719efe8&client_secret=f9f8dd209bf721833eeff1953840c5b4b0c561ac"

            let link = "https://api.github.com/users/\(username)/repos\(key)&type=all"
            var data = NSData(contentsOfURL: NSURL(string: link)!)

            if data == nil {
                notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                return
            }

            var parseErro: NSError?
            let parseUser = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray

            var resultSet: Dictionary = [String : AnyObject]()

            var resultArray : Array<Dictionary<String,AnyObject>> = []

            for userInfo in parseUser{
                let repoName = userInfo["name"] as! String
                if (userInfo["fork"] as! Bool){
                    let repoUrl : String! = (userInfo["url"] as! String)+key
                    let urlMack = NSURL(string: repoUrl)
                    let dataMack = NSData(contentsOfURL: urlMack!)

                    if dataMack == nil{
                        notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                        return
                    }
                    let parseMack = NSJSONSerialization.JSONObjectWithData(dataMack!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSDictionary

                    if(((parseMack["parent"] as! NSDictionary)["owner"] as! NSDictionary)["login"] as! String == "mackmobile"){
                        let urlRepo = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/issues\(key)&creator=\(username)")

                        println(urlRepo)

                        var dataRepo = NSData(contentsOfURL: urlRepo!)

                        if dataRepo == nil{
                            notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: nil)
                            return
                        }

                        let parseRepo = NSJSONSerialization.JSONObjectWithData(dataRepo!, options: NSJSONReadingOptions.MutableContainers, error: &parseErro) as! NSArray

                        for issue in parseRepo{

                            var repos : Dictionary<String,AnyObject> = ["name":repoName]
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
            notificationManager.postNotificationName("updateDidFinished", object: nil, userInfo: resultSet)
        })
    }
}

