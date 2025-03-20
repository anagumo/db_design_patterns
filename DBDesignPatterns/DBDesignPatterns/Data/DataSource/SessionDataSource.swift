import Foundation

protocol SessionDataSourceProtocol {
    func store(_ session: Data?)
    func get() -> Data?
}


final class SessionDataSource: SessionDataSourceProtocol {
    static let shared: SessionDataSourceProtocol = SessionDataSource()
    private var token: Data?
    
    func store(_ session: Data?) {
        token = session
    }
    
    func get() -> Data? {
        token
    }
}
