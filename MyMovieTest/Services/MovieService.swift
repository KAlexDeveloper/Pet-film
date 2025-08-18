//
//  MovieService.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Security
import Foundation
import Alamofire

protocol MovieServiceProtocol {
    func searchMovies(query: String) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    private let tokenKey = "kinopoiskApiKey"
    
    func searchMovies(query: String) async throws -> [Movie] {
        // Получение API-ключа из Keychain
        let apiKey: String
        do {
            apiKey = try KeychainManager.shared.getToken(for: tokenKey)
        } catch {
            print("❌ Не удалось получить API-ключ: \(error.localizedDescription)")
            throw AppError.unknownError
        }
        
        // Формирование URL и параметров запроса
        let url = "https://api.kinopoisk.dev/v1.4/movie/search"
        let parameters: Parameters = ["query": query]
        let headers: HTTPHeaders = ["X-API-KEY": apiKey]
        
        // Выполнение сетевого запроса
        let request = AF.request(url, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
        let dataResponse = await request.serializingData().response
  
        
        switch dataResponse.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔥 JSON-ответ сервера:\n\(jsonString)")
            }
            do {
                let movieResponse = try JSONDecoder().decode(KinopoiskMovieResponse.self, from: data)
                return movieResponse.docs
            } catch {
                print("❌ Ошибка декодирования: \(error.localizedDescription)")
                throw AppError.decodingError
            }
            
        case .failure(let afError):
            print("❌ Ошибка запроса: \(afError.localizedDescription)")
            if let urlError = afError.underlyingError as? URLError {
                print("⚠️ URLError код: \(urlError.code)")
                throw urlError
            } else {
                throw AppError.networkError
            }
        }
    }
}
