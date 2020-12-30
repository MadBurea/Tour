
import UIKit

class MatricsController: UIViewController {
    
    @IBOutlet final private weak var matricsCollectionView: UICollectionView!
    
    final private let numberArray = Array(1...49)
    
    final private var selectedNumbers = [Int]() {
        didSet {
            if selectedNumbers.count == 2 {
                let isFirstOdd = selectedNumbers[0]%2 == 1
                let isLastOdd  = selectedNumbers[1]%2 == 1
                
                switch (isFirstOdd, isLastOdd) {
                case (true, true):
                    print("SELECTED TWO ODD NUMBERS")
                    showAlert(withMessage: "SELECTED TWO ODD NUMBERS")
                    break
                case (false, false):
                    print("SELECTED TWO EVEN NUMBERS")
                    showAlert(withMessage: "SELECTED TWO EVEN NUMBERS")
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matricsCollectionView.setMatricsLayout()
        matricsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


extension MatricsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numberArray[indexPath.item]
        if !selectedNumbers.contains(number) {
            if selectedNumbers.count == 1 || selectedNumbers.count == 0 {
                selectedNumbers.append(number)
            }else{
                selectedNumbers = [selectedNumbers.last!, number]
            }
        }
        collectionView.reloadData()
    }
}

extension MatricsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { numberArray.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : NumberCell = collectionView.dequeueReusableCell(for: indexPath)
        let number = numberArray[indexPath.item]
        cell.number = number
        cell.showSelected = selectedNumbers.contains(number)
        return cell
    }
}
