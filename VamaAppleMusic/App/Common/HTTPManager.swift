//
//  HTTPManager.swift
//  SampleMusicApp
//
//  Created by Yogendra Solanki on 17/10/22.
//

import Foundation

class HTTPManager: NSObject {
    
    // MARK: Properties
    
    static let shared = HTTPManager() // Singleton
    
    /// setup url session
    var urlSession: URLSession = {
        let config = URLSessionConfiguration.default // Session Configuration
        config.timeoutIntervalForRequest = 60.0
        let session = URLSession(configuration: config) // Load configuration into Session
        return session
    }()
    
    /// Make a network call with get method
    /// - Parameters:
    ///   - strEndpoint: API end point
    ///   - params: parameters (Optional)
    ///   - completionHandler: completionHandler (NetworkResult?, AppError?)
    func getNetworkCall(strEndpoint: String, params: [String : Any]? = nil, completionHandler: @escaping ((NetworkResult?, AppError?) -> Void)) {
        guard let urlRequest = createUrlRequest(strEndpoint: strEndpoint, httpMethod: .get) else {
                completionHandler(nil, AppError(_message: Constants.Message.unknownUrl))
            return
        }
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let json = self.jsonSerializationWithData(data: data)
            else {
                var code = NSURLErrorUnknown
                if let error {
                    code = (error as NSError).code
                }
                completionHandler(nil, AppError(_message: self.prepareErrorResponce(code: code), _code: code))
                return
            }
            guard let data else {
                completionHandler(nil, AppError(_message: Constants.Message.unknownError))
                return
            }
            completionHandler(NetworkResult(_data: data, _value: json), nil)
        }
        task.resume()
    }

    /// createUrlRequest
    /// - Parameters:
    ///   - strEndpoint: API end point
    ///   - params: params optional
    ///   - httpMethod: httpMethod
    /// - Returns: URLRequest?
    private func createUrlRequest(strEndpoint: String, params: [String : Any]? = nil, httpMethod: NetworkHttpMethod) -> URLRequest? {
        
        //append endpoint in base url
        var combineUrl = Constants.AppUrl.BaseURL + strEndpoint
        var urlRequest: URLRequest
        
        if let params, params.count > 0 {
            combineUrl = combineUrl + params.queryString
        }
        
        guard let url = NSURL(string:combineUrl) else { return nil }
        urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    /// method for JSON serialization
    ///
    /// - Parameter data: response data
    /// - Returns: key value pair
    private func jsonSerializationWithData(data: Data?) -> [String:Any]? {
        guard let data else { return nil }
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            return response
        } catch {
            debugPrint("error in JSONSerialization")
            debugPrint(String(data: data, encoding: .utf8) ?? "")
        }
        return nil
    }
    
    /// Prepare error message according to Error Code
    ///
    /// - Parameter code: code INT
    /// - Returns: Message
    private func prepareErrorResponce(code: Int) -> String {
        var message = ""
        switch code {
        case NSURLErrorTimedOut:
            message = Constants.Message.requestTimeOut
        case NSURLErrorNotConnectedToInternet,NSURLErrorCannotConnectToHost:
            message = Constants.Message.noInternet
        case NSURLErrorNetworkConnectionLost:
            message = Constants.Message.connectionLost
        default:
            message = Constants.Message.unknownError
        }
        return message
    }
}

/// define result type
struct NetworkResult {
    var data: Data
    var value: [String:Any]
    
    /// init result object
    ///
    /// - Parameters:
    ///   - data: in form of binary data
    ///   - value: key/value pair value
    init(_data: Data, _value: [String:Any]) {
        data = _data
        value = _value
    }
}

/// http method
private enum NetworkHttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        output = "?" + output
        let newStr = output.replacingOccurrences(of: " ", with: "+")
        return newStr
    }
}
