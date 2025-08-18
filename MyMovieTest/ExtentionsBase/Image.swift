//
//  Image.swift
//  MyMovieTest
//
//  Created by сонный on 18.08.2025.
//

import Foundation
import UIKit

private var imageURLKey: UInt8 = 0

extension UIImageView {
    
    private var currentURL: String? {
        get { objc_getAssociatedObject(self, &imageURLKey) as? String }
        set { objc_setAssociatedObject(self, &imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func setImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        // Сохраняем текущий URL для проверки при асинхронной загрузке
        currentURL = urlString
        
        // Если есть в кэше — используем сразу
        if let cached = ImageCache.shared.image(for: urlString) {
            self.image = cached
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            // Сохраняем в кэш
            ImageCache.shared.setImage(image, for: urlString)
            
            DispatchQueue.main.async {
                // Проверка: ячейка могла переиспользоваться
                if self?.currentURL == urlString {
                    self?.image = image
                }
            }
        }
    }
}


