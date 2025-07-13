//
//  Movie.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Foundation

struct KinopoiskMovieResponse: Decodable {
    let docs: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let name: String
    let description: String?
    let year: Int?
    let poster: Poster?

    var title: String { name }
    var overview: String { description ?? "Описание отсутствует" }
    var releaseDate: String {
        if let year = year {
            return String(year)
        } else {
            return "Год неизвестен"
        }
    }
    var posterUrl: String? { poster?.url }
}

struct Poster: Decodable {
    let url: String?
}
//struct KinopoiskMovieResponse: Decodable {
//    let docs: [Movie]
//}
//
//struct Movie: Decodable {
//    let id: Int
//    let name: String
//    let description: String?
//    let year: Int?
//    let poster: Poster?
//
//    var title: String { name }
//    var overview: String { description ?? "Описание отсутствует" }
//    var releaseDate: String { year != nil ? String(year!) : "Год неизвестен" }
//    var posterUrl: String? { poster?.url }
//}
//
//struct Poster: Decodable {
//    let url: String
//}
//
//struct Movie: Decodable {
//    let id: Int
//    let name: String
//    let description: String?
//    let year: Int?
//    let poster: Poster?
//    
//    var title: String { name }
//    var overview: String { description ?? "Описание отсутствует" }
//    var releaseDate: String { year != nil ? String(year!) : "Год неизвестен" }
//    var posterUrl: String? { poster?.url }
//}
//
//struct Poster: Decodable {
//    let url: String
//}
//
//struct KinopoiskMovieResponse: Decodable {
//    let docs: [Movie]
//}
