//
//  NetworkService.swift
//  iOSSkillsTest
//
//  Created by Milos Otasevic on 18.9.21..
//

import Foundation

class NetworkService{
    
    private init() {}
    
    static let shared = NetworkService()
    
    func usernameAvailable(_ username: String, completion: (Bool) -> Void) {
        username.count < 5 ? completion(false) : completion(true) }
}
