import UIKit

protocol ImageService {

    func fetchImage(with url: URL, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void)
}

class DefaultImageService: ImageService {

    func fetchImage(with url: URL, completion: @escaping (Result<UIImage, ImageServiceError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}

enum ImageServiceError: Error {

    case unknown
}
