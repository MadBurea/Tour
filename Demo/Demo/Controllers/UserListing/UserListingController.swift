
import UIKit

class UserListingController: UIViewController {
    
    @IBOutlet final private weak var userTableView: UITableView!
    
    private let userList = UserModel.getUserList()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

extension UserListingController {
    final private func prepareView() {
        userTableView.reloadData()
    }
}

extension UserListingController: UITableViewDelegate {

}

extension UserListingController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { userList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCellFromNIB(UserTableCell.self)
        cell.user = userList[indexPath.row]
        cell.index = indexPath.row + 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
}
