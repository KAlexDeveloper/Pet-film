//
//  Mapper.swift
//  MyMovieTest
//
//  Created by сонный on 10.08.2025.
//

import Foundation

enum FavoriteMovieMapper {
    static func toMovie(from entity: FavoriteMovieEntity) -> Movie {
        return Movie(
            id: Int(entity.id),
            name: entity.title ?? "",
            alternativeName: nil,
            description: nil,
            year: Int(entity.year ?? ""),
            poster: Poster(url: entity.posterUrl, previewUrl: nil),
            rating: Rating(kp: entity.rating, imdb: nil, filmCritics: nil, russianFilmCritics: nil, await: nil),
            votes: nil,
            genres: nil,
            countries: nil,
            externalId: nil
        )
    }
}
