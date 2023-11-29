//
//  UIImage+Extensions.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, errorHandler: ((Error) -> Void)? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            
            if let error = error {
                DispatchQueue.main.async {
                    errorHandler?(error)
                    return
                }
            }

            if let httpURLResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpURLResponse.statusCode),
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler?(NSError(domain: "ErrorImage", code: -1))
                }
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, errorHandler: ((Error) -> Void)? = nil) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, errorHandler: errorHandler)
    }
}
