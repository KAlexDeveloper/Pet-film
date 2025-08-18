//
//  Movie.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Foundation

struct KinopoiskMovieResponse: Decodable {
    let docs: [Movie]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}

struct Movie: Decodable {
    let id: Int
    let name: String
    let alternativeName: String?
    let description: String?
    let year: Int?
    let poster: Poster?
    let rating: Rating?
    let votes: Votes?
    let genres: [Genre]?
    let countries: [Country]?
    let externalId: ExternalID?
    
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
    let previewUrl: String?
}

struct Rating: Decodable {
    let kp: Double?
    let imdb: Double?
    let filmCritics: Double?
    let russianFilmCritics: Double?
    let await: Double?
}

struct Votes: Decodable {
    let kp: Int?
    let imdb: Int?
    let filmCritics: Int?
    let russianFilmCritics: Int?
    let await: Int?
}

struct Genre: Decodable {
    let name: String
}

struct Country: Decodable {
    let name: String
}

struct ExternalID: Decodable {
    let kpHD: String?
    let imdb: String?
    let tmdb: Int?
}
