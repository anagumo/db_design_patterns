import Foundation
@testable import DBDesignPatterns

enum MockAppData {
    
    static func givenJWTData() -> Data? {
        """
        {
            eyJhbGciOiJIUzI1NiIsImtpZCI6InByaXZhdGUiLCJ0eXAiOiJKV1QifQ.eyJlbWFpbCI6ImFyaW5hZ3Vtb0BnbWFpbC5jb20iLCJpZGVudGlmeSI6IjI1NzlDOUY3LUEyRUMtNERBRi1BNUZELTM3NUY3RTA4NTVBOCIsImV4cGlyYXRpb24iOjY0MDkyMjExMjAwfQ.VfxPJL7L3ZlLgumzcXH_V7rFqhsR3TLptnzQ7m-cg60
        }
        """.data(using: .utf8)
    }
    
    static let givenHeroList = [
        HeroModel(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                  name: "Goku",
                  description: "Sobran las presentaciones cuando se habla de Goku.",
                  favorite: false,
                  photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"),
        HeroModel(identifier: "D13A40E5-4418-4223-9CE6-D2F9A28EBE95",
                  name: "Vegeta",
                  description: "Sobran las presentaciones cuando se habla de Vegeta.",
                  favorite: true,
                  photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegeta1.jpg?width=300"),
        HeroModel(identifier: "64143856-12D8-4EF9-9B6F-F08742098A18",
                  name: "Bulma",
                  description: "Sobran las presentaciones cuando se habla de Bulma.",
                  favorite: false,
                  photo: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Bulma-Dragon-Ball.jpg?width=300"),
        HeroModel(identifier: "CBCFBDEC-F89B-41A1-AC0A-FBDA66A33A06",
                  name: "Piccolo",
                  description: "Sobran las presentaciones cuando se habla de Piccolo.",
                  favorite: true,
                  photo: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Piccolo.jpg?width=300"),
        HeroModel(identifier: "CBCFBDEC-F89B-41A1-AC0A-FBDA66A33A03",
                  name: "Krilin",
                  description: "Sobran las presentaciones cuando se habla de Krilin.",
                  favorite: false,
                  photo: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Krilin.jpg?width=300")
    ]
}
