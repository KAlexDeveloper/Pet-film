//
//  MovieService.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//
import Alamofire
import Foundation

protocol MovieServiceProtocol {
//    func searchMovies(query: String, page: Int?, limit: Int?) async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let apiKey = "FMQ970S-76N461V-GYGMDYK-TSQT6ZQ"

    func searchMovies(query: String) async throws -> [Movie] {
        let url = "https://api.kinopoisk.dev/v1.4/movie/search"
        let parameters: Parameters = [
            "query": query
        ]
        let headers: HTTPHeaders = [
            "X-API-KEY": apiKey
        ]

        let request = AF.request(url, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)

        let dataResponse = await request.serializingData().response

        switch dataResponse.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔥 JSON-ответ сервера:\n\(jsonString)")
            }

            let decoder = JSONDecoder()
            let movieResponse = try decoder.decode(KinopoiskMovieResponse.self, from: data)
            return movieResponse.docs

        case .failure(let error):
            print("❌ Ошибка запроса: \(error.localizedDescription)")
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось загрузить фильмы"])
        }
    }
}
