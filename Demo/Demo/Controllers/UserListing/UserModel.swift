import UIKit

struct UserModel {
    let name : String
    let image: UIImage
    let score: Int
}

extension UserModel {
    static func getUserList() -> [UserModel] {
        let user1 = UserModel(name: "Chiragdip",
                              image: UIImage(named: "user1")!,
                              score: 1004)
        
        let user2 = UserModel(name: "Mayank",
                              image: UIImage(named: "user2")!,
                              score: 1000)
        
        let user3 = UserModel(name: "Sagar",
                              image: UIImage(named: "user3")!,
                              score: 1001)
        
        let user4 = UserModel(name: "Saurabh",
                              image: UIImage(named: "user4")!,
                              score: 1003)
        
        let user5 = UserModel(name: "Pranjal",
                              image: UIImage(named: "user5")!,
                              score: 999)
        
        return [user1, user2, user3, user4, user5].sorted { $0.score > $1.score }
    }
}
