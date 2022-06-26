//
//  LaunchViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 16/06/2022.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    private weak var launchScreenFlow: LaunchScreenNavigationFlow?
    
    // MARK: - Set up
    init(_ launchScreenFlow: LaunchScreenNavigationFlow) {
        super.init(nibName: nil, bundle: nil)
        self.launchScreenFlow = launchScreenFlow
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func showAnimation() {
        let animationView = AnimationView()
        animationView.animation = Animation.named("E-commerce")
        animationView.frame = view.bounds
        animationView.center = view.center
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        view.addSubview(animationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self = self else {return}
            let hasSeenOnBoard = UserDefaults.standard.bool(forKey: "hasSeenOnBoard")
            if(hasSeenOnBoard == false) {
                self.launchScreenFlow?.goToOnBoardingScreen()
            }else {
                self.launchScreenFlow?.goToHomeTabbar()
            }
           
        }
    }
}
