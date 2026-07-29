import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    @discardableResult
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return nil
        }

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            let complete: (UIImage?) -> Void = { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }

            if error != nil {
                complete(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                complete(nil)
                return
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                complete(nil)
                return
            }

            guard
                let mimeType = httpResponse.mimeType,
                mimeType.hasPrefix("image/")
            else {
                complete(nil)
                return
            }

            guard
                let data,
                let image = UIImage(data: data)
            else {
                complete(nil)
                return
            }

            self?.cache.setObject(
                image,
                forKey: url as NSURL
            )

            complete(image)
        }

        task.resume()
        return task
    }
}
