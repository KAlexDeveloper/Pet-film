//
//  ErrorHandler.swift
//  MyMovieTest
//
//  Created by сонный on 17.08.2025.
//

import Foundation

// MARK: - AppError
enum AppError: Error {
    case networkError
    case serverError(code: Int)
    case decodingError
    case movieNotFound
    case unknownError
    
    var userFriendlyMessage: String {
        switch self {
        case .networkError:
            return "Нет подключения к интернету. Проверьте соединение."
        case .serverError(let code):
            return "Сервер вернул ошибку: \(code). Попробуйте позже."
        case .decodingError:
            return "Не удалось обработать данные. Попробуйте обновить экран."
        case .movieNotFound:
            return "Фильмы по вашему запросу не найдены."
        case .unknownError:
            return "Произошла неизвестная ошибка. Попробуйте снова."
        }
    }
}

// MARK: - ErrorHandlerProtocol
protocol ErrorHandlerProtocol {
    func map(_ error: Error) -> AppError
    func message(for error: Error) -> String
}

// MARK: - ErrorHandler
final class ErrorHandler: ErrorHandlerProtocol {
    
    func map(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .networkError
            case .timedOut:
                return .networkError
            default:
                return .unknownError
            }
        } else if error is DecodingError {
            return .decodingError
        } else {
            return .unknownError
        }
    }
    
    func message(for error: Error) -> String {
        let appError = map(error)
        return appError.userFriendlyMessage
    }
}
