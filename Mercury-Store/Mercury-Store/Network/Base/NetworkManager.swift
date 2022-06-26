//
//  NetworkManager.swift
//  Mercury-Store
//
//  Created by mac hub on 19/06/2022.
//

import Foundation
import Reachability


class NetworkReachability {
    let reachability: Reachability
    
    static let shared = NetworkReachability()
    private init(){
        reachability = try! Reachability()
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    func checkNetwork(target:UIViewController) {
        let noInternetView  = DefaultView(color: .white, raduis: 0)
        let noInternetStateImage = DefaultImageView(frame: .zero)
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                
            } else {
                print("Reachable via Cellular")
            }
            
            self.configureRemoveNoInternetView(view: target.view, noInternetView: noInternetView, noInternetStateImage: noInternetStateImage)
            
        }
        reachability.whenUnreachable = { _ in
            let alert = UIAlertController(title: "No Connection!",message:"Please Check Your Internet Connection",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",style: .default, handler: nil))
            target.present(alert, animated: true, completion: nil)
            
            
            self.configureShowNoInternetView(view: target.view, noInternetView: noInternetView, noInternetStateImage: noInternetStateImage)
        }
        
    }
    
    private func configureShowNoInternetView(view:UIView, noInternetView:DefaultView, noInternetStateImage:DefaultImageView){
        view.addSubview(noInternetView)
        noInternetView.addSubview(noInternetStateImage)
        noInternetStateImage.image       = UIImage(named: "noInternetConnection")
        noInternetStateImage.contentMode = .center
        
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: view.topAnchor),
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noInternetStateImage.topAnchor.constraint(equalTo: noInternetView.topAnchor),
            noInternetStateImage.leadingAnchor.constraint(equalTo: noInternetView.leadingAnchor),
            noInternetStateImage.trailingAnchor.constraint(equalTo: noInternetView.trailingAnchor),
            noInternetStateImage.bottomAnchor.constraint(equalTo: noInternetView.bottomAnchor),
            
        ])
    }
    
    private func configureRemoveNoInternetView(view:UIView,noInternetView:DefaultView,noInternetStateImage:DefaultImageView){
        noInternetView.removeFromSuperview()
    }
}

