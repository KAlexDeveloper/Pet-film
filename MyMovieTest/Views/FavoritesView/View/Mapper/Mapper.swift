//
//  Mapper.swift
//  MyMovieTest
//
//  Created by сонный on 10.08.2025.
//

import Foundation

enum FavoriteMovieMapper {
    static func toMovie(from entity: FavoriteMovieEntity) -> Movie {
        // Разбиваем строки жанров и стран на массивы структур
        let genres: [Genre]? = entity.genresString?.split(separator: ",").map { Genre(name: $0.trimmingCharacters(in: .whitespaces)) }
        let countries: [Country]? = entity.countriesString?.split(separator: ",").map { Country(name: $0.trimmingCharacters(in: .whitespaces)) }
        
        // Преобразуем год из String в Int
        let year: Int? = {
            if let yearString = entity.year, let intYear = Int(yearString) {
                return intYear
            } else {
                return nil
            }
        }()
        
        // Проверяем рейтинг
        let kpRating: Double? = entity.rating > 0 ? entity.rating : nil
        let imdbRating: Double? = entity.imdbRating > 0 ? entity.imdbRating : nil
        
        
        // Преобразуем externalId в структуру
        let externalId: ExternalID? = {
            guard entity.externalId > 0 else { return nil }
            return ExternalID(kpHD: String(entity.externalId), imdb: nil, tmdb: nil)
        }()
        
        return Movie(
            id: Int(entity.id),
            name: entity.title,
            alternativeName: entity.alternativeTitle,
            description: entity.overview,
            year: year,
            poster: Poster(url: entity.posterUrl, previewUrl: nil),
            rating: Rating(kp: kpRating, imdb: imdbRating, filmCritics: nil, russianFilmCritics: nil, await: nil),
            votes: nil,
            genres: genres,
            countries: countries,
            externalId: externalId
        )
    }
}
