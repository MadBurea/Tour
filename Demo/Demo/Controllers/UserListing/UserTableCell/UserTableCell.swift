import UIKit

class UserTableCell: UITableViewCell {
    
    @IBOutlet final private weak var userImageView:  UIImageView!
    @IBOutlet final private weak var userNameLabel:  UILabel!
    @IBOutlet final private weak var userScoreLabel: UILabel!
    
    @IBOutlet final private weak var userIndexLabel:  UILabel!

    var user: UserModel! {
        didSet {
            userImageView.image = user.image
            userNameLabel.text  = user.name
            userScoreLabel.text = "\(user.score)"
        }
    }
    
    var index: Int! {
        didSet {
            userIndexLabel.text = "\(index ?? 0)"
        }
    }
}
