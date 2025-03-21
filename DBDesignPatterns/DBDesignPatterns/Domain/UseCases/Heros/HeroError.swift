struct HeroError: Error {
    let reason: String
}

extension HeroError {
    static func empty() -> HeroError {
        HeroError(reason: "Empty hero")
    }
    
    static func network(_ errorMessage: String) -> HeroError {
        HeroError(reason: errorMessage)
    }
    
    static func uknown() -> HeroError {
        HeroError(reason: "Hero unknown error")
    }
}
