import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case invalidRequest
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

extension NetworkClientError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .httpStatusCode(let code):
            return "Сервер вернул ошибку с кодом \(code)"
            
        case .invalidRequest:
            return "Не удалось сформировать сетевой запрос"
            
        case .urlRequestError(let error):
            return error.localizedDescription
            
        case .urlSessionError:
            return "Не удалось получить ответ от сервера"
            
        case .parsingError:
            return "Не удалось обработать ответ сервера"
        }
    }
}

protocol NetworkClient {
    
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask?
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask?
}

// MARK: - Default parameters

extension NetworkClient {
    
    @discardableResult
    func send(
        request: NetworkRequest,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        send(
            request: request,
            completionQueue: .main,
            onResponse: onResponse
        )
    }
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        send(
            request: request,
            type: type,
            completionQueue: .main,
            onResponse: onResponse
        )
    }
}

struct DefaultNetworkClient: NetworkClient {
    
    // MARK: - Private Properties
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let decodingQueue: DispatchQueue
    
    // MARK: - Initializer
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        decodingQueue: DispatchQueue = DispatchQueue(
            label: "DefaultNetworkClient.decoding",
            qos: .userInitiated
        )
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.decodingQueue = decodingQueue
    }
    
    // MARK: - Data Request
    
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let complete: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        
        guard let urlRequest = create(request: request) else {
            complete(
                .failure(NetworkClientError.invalidRequest)
            )
            return nil
        }
        
        let task = session.dataTask(
            with: urlRequest
        ) { data, response, error in
            if let error {
                complete(
                    .failure(
                        NetworkClientError.urlRequestError(error)
                    )
                )
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                complete(
                    .failure(NetworkClientError.urlSessionError)
                )
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                complete(
                    .failure(
                        NetworkClientError.httpStatusCode(
                            httpResponse.statusCode
                        )
                    )
                )
                return
            }
            
            guard let data else {
                complete(
                    .failure(NetworkClientError.urlSessionError)
                )
                return
            }
            
            complete(.success(data))
        }
        
        task.resume()
        
        return DefaultNetworkTask(dataTask: task)
    }
    
    // MARK: - Decodable Request
    
    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        let complete: (Result<T, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }
        
        /*
         Данные передаются на decodingQueue, поэтому JSONDecoder.decode
         выполняется не на главном потоке.
         */
        return send(
            request: request,
            completionQueue: decodingQueue
        ) { result in
            switch result {
            case .success(let data):
                let parsedResult: Result<T, Error> = self.parse(
                    data: data,
                    type: type
                )
                
                complete(parsedResult)
                
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func create(
        request: NetworkRequest
    ) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        urlRequest.setValue(
            RequestConstants.token,
            forHTTPHeaderField: "X-Practicum-Mobile-Token"
        )
        
        if let dtoDictionary = request.dto?.asDictionary() {
            var urlComponents = URLComponents()
            
            urlComponents.queryItems = dtoDictionary.map { field in
                URLQueryItem(
                    name: field.key,
                    value: field.value
                )
            }
            
            urlRequest.httpBody = urlComponents
                .percentEncodedQuery?
                .data(using: .utf8)
            
            urlRequest.setValue(
                "application/x-www-form-urlencoded; charset=utf-8",
                forHTTPHeaderField: "Content-Type"
            )
        }
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(
        data: Data,
        type: T.Type
    ) -> Result<T, Error> {
        do {
            let response = try decoder.decode(
                type,
                from: data
            )
            
            return .success(response)
        } catch {
            return .failure(
                NetworkClientError.parsingError
            )
        }
    }
}
