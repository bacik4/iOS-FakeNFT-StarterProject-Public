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
<<<<<<< .merge_file_L0652B
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?
    
=======
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask?

>>>>>>> .merge_file_2ieHkO
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
<<<<<<< .merge_file_L0652B
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
=======
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
>>>>>>> .merge_file_2ieHkO
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.decodingQueue = decodingQueue
    }
<<<<<<< .merge_file_L0652B
    
=======

    // MARK: - Data Request

>>>>>>> .merge_file_2ieHkO
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
<<<<<<< .merge_file_L0652B
        guard let urlRequest = create(request: request) else { return nil }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }
            
            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }
            
            if let data = data {
                onResponse(.success(data))
                return
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
=======

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
>>>>>>> .merge_file_2ieHkO
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
<<<<<<< .merge_file_L0652B
    
=======

    // MARK: - Decodable Request

>>>>>>> .merge_file_2ieHkO
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
<<<<<<< .merge_file_L0652B
    
    // MARK: - Private
    private func create(request: NetworkRequest) -> URLRequest? {
=======

    // MARK: - Private Methods

    private func create(
        request: NetworkRequest
    ) -> URLRequest? {
>>>>>>> .merge_file_2ieHkO
        guard let endpoint = request.endpoint else {
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
<<<<<<< .merge_file_L0652B
        
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
=======

        urlRequest.setValue(
            RequestConstants.token,
            forHTTPHeaderField: "X-Practicum-Mobile-Token"
        )

        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

>>>>>>> .merge_file_2ieHkO
        if let dtoDictionary = request.dto?.asDictionary() {
            var urlComponents = URLComponents()

            urlComponents.queryItems = dtoDictionary.map { field in
                URLQueryItem(
                    name: field.key,
                    value: field.value
                )
            }
<<<<<<< .merge_file_L0652B
            urlComponents.queryItems = queryItems
            urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
=======

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
>>>>>>> .merge_file_2ieHkO
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
