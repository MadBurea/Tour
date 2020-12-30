
import UIKit

extension UITableView {
    final private func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        register(UINib.init(nibName: String(describing: T.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: T.self))
    }
    final func dequeueCellFromNIB<T: UITableViewCell>(_: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T{
            return cell
        }else{
            register(T.self)
            return dequeueCellFromNIB(T.self)
        }
    }
}
