//
//  MovieService.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//
import Alamofire
import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String, page: Int?, limit: Int?) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let apiKey = "FMQ970S-76N461V-GYGMDYK-TSQT6ZQ"
    private let session: Session

    init() {
        self.session = Session()
    }

    func searchMovies(query: String, page: Int? = nil, limit: Int? = nil) async throws -> [Movie] {
        let urlString = "https://api.kinopoisk.dev/v1.4/movie/search"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var parameters: [String: Any] = [
            "query": query
        ]
        if let page = page {
            parameters["page"] = page
        }
        if let limit = limit {
            parameters["limit"] = limit
        }

        let headers: HTTPHeaders = [
            "X-API-KEY": apiKey
        ]

        let request = session.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)

        // Получаем полный ответ, чтобы проверить статус
        let response = await request.serializingResponse(using: DataResponseSerializer()).response

        let statusCode = response.response?.statusCode ?? -1
        print("🔎 HTTP статус: \(statusCode)")

        if statusCode == 504 {
            print("❌ Сервер не ответил (504 Gateway Timeout)")
            throw NSError(domain: "", code: 504, userInfo: [NSLocalizedDescriptionKey: "Сервер не ответил. Попробуйте позже."])
        }

        // Проверяем тип контента
        let contentType = response.response?.headers["Content-Type"] ?? ""
        if !contentType.contains("application/json") {
            print("❌ Сервер вернул не JSON, а HTML или другой тип")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Сервер вернул неверный формат данных."])
        }

        let rawData = try await request.serializingData().value

        if let jsonString = String(data: rawData, encoding: .utf8) {
            print("📄 JSON-ответ: \(jsonString)")
        }

        do {
            let decoded = try JSONDecoder().decode(KinopoiskMovieResponse.self, from: rawData)
            print("✅ Успешно декодировано: \(decoded.docs.count) фильмов")
            return decoded.docs
        } catch {
            print("❌ Ошибка декодирования: \(error)")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось обработать данные от сервера."])
        }
    }
}
