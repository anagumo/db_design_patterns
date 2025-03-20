import Foundation

protocol SessionDataSourceProtocol {
    func save(_ session: Data?)
    func get() -> Data?
}


final class SessionDataSource: SessionDataSourceProtocol {
    static let shared: SessionDataSourceProtocol = SessionDataSource()
    private var token: Data?
    
    func save(_ session: Data?) {
        token = session
    }
    
    func get() -> Data? {
        token
    }
}
