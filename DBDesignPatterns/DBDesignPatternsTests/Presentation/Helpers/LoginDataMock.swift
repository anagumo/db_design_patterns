import Foundation

enum LoginDataMock {
    
    static func givenJWTData() -> Data? {
        """
        {
            eyJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUiLCJ0eXAiOiJKV1QifQ.eyJlbWFpbCI6ImFyaW5hZ3Vtb0BnbWFpbC5jb20iLCJpZGVudGlmeSI6IjI1NzlDOUY3LUEyRUMtNERBRi1BNUZELTM3NUY3RTA4NTVBOCIsImV4cGlyYXRpb24iOjY0MDkyMjExMjAwfQ.VfxPJL7L3ZlLgumzcXH_V7rFqhsR3TLptnzQ7m-cg60
        }
        """.data(using: .utf8)
    }
}
