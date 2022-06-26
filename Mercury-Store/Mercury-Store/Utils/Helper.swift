//
//  userInfoHelper.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 26/06/2022.
//

import Foundation

func getCurrentUserId()->Int?{
    let sharedInstance: UserDefaults = UserDefaults.standard
    do{
        let user:User = try sharedInstance.getObject(forKey: "user", castTo: User.self)
        return user.id
    }catch( _){
        return nil
    }
}
