//
//  KeychainManager.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//  KeychainManager.shared.saveToken("FMQ970S-76N461V-GYGMDYK-TSQT6ZQ", for: "kinopoiskApiKey")


import Foundation
import Security

protocol KeychainManaging {
    func saveToken(_ token: String, for key: String) throws
    func getToken(for key: String) throws -> String
    func deleteToken(for key: String) throws
}

final class KeychainManager: KeychainManaging {
    static let shared = KeychainManager()
    private init() {}
    
    func saveToken(_ token: String, for key: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw NSError(domain: "KeychainManager", code: 1001, userInfo: [
                NSLocalizedDescriptionKey: "Невозможно преобразовать токен в Data"
            ])
        }
        
        // Удаляем существующий элемент с таким же ключом
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        // Добавляем новый элемент
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        if status != errSecSuccess {
            throw NSError(domain: "KeychainManager", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Ошибка сохранения токена. Код: \(status)"
            ])
        }
    }
    
    func getToken(for key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainManager", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Не удалось извлечь токен. Код: \(status)"
            ])
        }
        
        guard let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "KeychainManager", code: 1002, userInfo: [
                NSLocalizedDescriptionKey: "Невозможно декодировать токен из Data"
            ])
        }
        
        return token
    }
    
    func deleteToken(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw NSError(domain: "KeychainManager", code: Int(status), userInfo: [
                NSLocalizedDescriptionKey: "Ошибка удаления токена. Код: \(status)"
            ])
        }
    }
}
