import UIKit

protocol ImageLoadingTask: AnyObject {
    func cancel()
}

extension URLSessionDataTask: ImageLoadingTask {}

protocol ImageLoading: AnyObject {

    @discardableResult
    func loadImage(
        from url: URL,
        completion: @escaping (UIImage?) -> Void
    ) -> ImageLoadingTask?
}
