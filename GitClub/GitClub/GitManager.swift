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

        let link = "https://api.github.com/users/\(username)/repos"
        let url = NSURL(string: link)
        var data = NSData(contentsOfURL: url!)
        
        
        
        
    }
    
}