
import UIKit

extension UIViewController {
    final func showAlert(withMessage message: String?, title : String = "", color: UIColor = .blue, preferredStyle: UIAlertController.Style = .alert, withActions actions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        alert.view.tintColor = color
        present(alert, animated: true, completion: nil)
    }
}
