import Foundation

struct APIErrorResponse: Error {
    let url: String
    let statusCode: Int
    let data: Data?
    let message: String
    
    init(url: String,
         statusCode: Int,
         data: Data? = nil,
         message: String) {
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

extension APIErrorResponse {
    static func malformedURL(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -5, message: "Malformed URL.")
    }
    
    static func network(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -1, message: "Network connection error.")
    }
    
    static func parseData(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -2, message: "Cannot parse data from URL.")
    }
    
    static func empty(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -4, message: "Empty data.")
    }
    
    static func unauthorized(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -5, message: "Wrong email or password. Please log in again.")
    }
    
    static func unknown(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -6, message: "Unknown server error")
    }
}
