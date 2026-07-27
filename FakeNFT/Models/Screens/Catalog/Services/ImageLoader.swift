import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    @discardableResult
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard
                error == nil,
                let data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
        return task
    }
}

