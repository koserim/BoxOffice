//
//  Model.swift
//  BoxOffice
//
//  Created by 고세림 on 2018. 12. 7..
//  Copyright © 2018년 serim. All rights reserved.
//

import Foundation

struct MovieAPIResponse: Codable {
    let movies: [Movie]
}

struct CommentAPIResponse: Codable {
    let comments: [Comment]
}

struct Movie: Codable {
    let grade: Int
    let thumb: URL
    let reservationGrade: Int
    let title: String
    let userRating: Double
    let reservationRate: Double
    let date: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case grade, thumb, title, date, id
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
    }
}

struct MovieInfo: Codable {
    let image: URL
    let reservationRate: Double
    let synopsis: String
    let director: String
    let audience: Int
    let grade: Int
    let actor: String
    let title: String
    let userRating: Double
    let reservationGrade: Int
    let genre: String
    let id: String
    let date: String
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case image, synopsis, director, audience, grade, actor, title, genre, id, date, duration
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case reservationGrade = "reservation_grade"
    }
}

struct Comment: Codable {
    let rating: Double
    let movieId: String
    let writer: String
    let timestamp: Double
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, writer, timestamp, contents
        case movieId = "movie_id"
    }
}
