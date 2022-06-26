//
//  UpdateAddressNavigationFlow.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 15/06/2022.
//

import Foundation
protocol UpdateAddressNavigationFlow: AnyObject {
    func goToUpdateAddressScreen(with address: CustomerAddress)
    func popEditController()
    func goToAddAddressScreen()
}
