//
//  FISGitHubAPIClient.swift
//  github-repo-list-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class GitHubAPIClient {
    
    // MARK: Path Router
    enum URLRouter {
        static let repo = "https://api.github.com/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
//        static let tokenURL = ""
//        static let oauthURL = ""
        static let token = "https://github.com/login/oauth/access_token"
        static let oauth = "https://github.com/login/oauth/authorize?client_id=\(Secrets.clientID)&scope=repo"
        
        static func starred(repoName repo: String) -> String? {
            
            let starredURL = "https://api.github.com/user/starred/\(repo)?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)&access_token="
            
//            if let token = GitHubAPIClient.getAccessToken() {
//                return starredURL + token
//            }
            return nil
        }
    }

}

// MARK: Repositories
extension GitHubAPIClient {
    
    class func getRepositoriesWithCompletion(completionHandler: (JSON?) -> Void) {
        
        Alamofire.request(.GET, URLRouter.repo)
            .validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success:
                    if let data = response.data {
                        completionHandler(JSON(data: data))
                    }
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            })
        
    }
    
}


// MARK: OAuth
extension GitHubAPIClient {
    
    class func startAccessTokenRequest(url url: NSURL, completionHandler: (Bool) -> ()) {
        
//        guard let code = url.getQueryItemValue(named: "code") else {return}
//        
//        let params = ["client_id": Secrets.clientID, "client_secret": Secrets.clientSecret, "code": code]
//        
//        Alamofire.request(.POST, URLRouter.token, parameters: params)
//            .validate()
//            .responseString(completionHandler: { response in
//                switch response.result {
//                case .Success:
//                    
//                    self.saveAccessTokenFrom(response: response.result.value, completionHandler: { success in
//                        if success {
//                            completionHandler(true)
//                        } else {
//                            print("ERROR: Unable to save access token")
//                            completionHandler(false)
//                        }
//                        
//                    })
//                    
//                case .Failure(let error):
//                    print("\nERROR: \(error.localizedDescription)")
//                    completionHandler(false)
//                }
//            })
        
    }
    
    private class func saveAccessTokenFrom(response response: String?, completionHandler: (Bool) -> ()) {
        
//        let params = response?.componentsSeparatedByString("&").first
//        guard let token = params?.componentsSeparatedByString("=").last else {
//            completionHandler(false)
//            return
//        }
//        
//        do {
//            try Locksmith.saveData(["token": token], forUserAccount: "github")
//            completionHandler(true)
//        } catch let error {
//            print("ERROR: \(error)")
//            completionHandler(false)
//            return
//        }
        
    }
    
    private class func getAccessToken() -> String? {
        
//        if let data = Locksmith.loadDataForUserAccount("github") {
//            print(data["token"] as? String)
//            return data["token"] as? String
//        }
        return nil
        
    }
    
    class func deleteAccessToken(completionHandler: (Bool) -> ()) {
        
//        do {
//            try Locksmith.deleteDataForUserAccount("github")
//            completionHandler(true)
//        } catch let error {
//            print("ERROR: \(error)")
//            completionHandler(false)
//        }
        
    }
    
    class func hasToken() -> Bool {
        
//        let token = getAccessToken()
//        if token != nil {
//            return true
//        }
        return false
    }
    
    

    
}


// MARK: Activity
extension GitHubAPIClient {
    
    class func checkIfRepositoryIsStarred(fullName: String, completionHandler: (Bool?) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(nil)
            return
        }
        
        Alamofire.request(.GET, urlString)
            .validate(statusCode: 204...404)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    if response.response?.statusCode == 204 {
                        completionHandler(true)
                    } else if response.response?.statusCode == 404 {
                        completionHandler(false)
                    }
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(nil)
                }
                
                
            })
        
    }
    
    class func starRepository(fullName: String, completionHandler: (Bool) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(false)
            return
        }
        
        Alamofire.request(.PUT, urlString)
            .validate(statusCode: 204...204)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    completionHandler(true)
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(false)
                }
            })
        
    }
    
    class func unStarRepository(fullName: String, completionHandler: (Bool) -> ()) {
        
        guard let urlString = URLRouter.starred(repoName: fullName) else {
            print("ERROR: Unable to get url path for starred status")
            completionHandler(false)
            return
        }
        
        Alamofire.request(.DELETE, urlString)
            .validate(statusCode: 204...204)
            .responseString(completionHandler: { response in
                switch response.result {
                case .Success:
                    completionHandler(true)
                case .Failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completionHandler(false)
                }
            })
        
    }
    
}

