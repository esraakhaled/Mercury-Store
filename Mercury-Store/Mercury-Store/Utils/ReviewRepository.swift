//
//  ReviewRepository.swift
//  Mercury-Store
//
//  Created by mac hub on 22/06/2022.
//

import Foundation

struct ReviewModel {
    let date: String
    let email: String
    let reviewContent: String
    let rating: Double
    let imageName: String
}

struct ReviewRepository {
    static let reviewsArray = [
        ReviewModel(date: "20/06/2022", email: "mahmoudtest@gmail.com", reviewContent: "Pretty looks great with lots", rating: 9.7, imageName: "customer1"),
        ReviewModel(date: "19/06/2022", email: "esraa@gmail.com", reviewContent: "As advertised ,very nice product", rating: 8.7, imageName: "customer2"),
        ReviewModel(date: "17/06/2022", email: "raiaan@gmail.com", reviewContent: "I like it", rating: 8, imageName: "customer3"),
        ReviewModel(date: "15/06/2022", email: "esraaTest@gmail.com", reviewContent: "Very good quality, good colour", rating: 7.5, imageName: "customer4"),
        ReviewModel(date: "9/06/2022", email: "raiaanTest@gmail.com", reviewContent: "Very good quality , satisfied", rating: 9.7, imageName: "customer5")
    ]
}

