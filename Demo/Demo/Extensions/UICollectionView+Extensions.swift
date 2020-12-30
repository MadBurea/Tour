
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String { String(describing: self) }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String { String(describing: self) }
}

// UICollectionView + Reusable Cell
extension UICollectionView {
    final func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    final func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    final func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView, T: NibLoadableView {
        register(T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: kind)
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusable supplementaryView with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UICollectionView {
    static private let NUMBER_OF_ITEM_IN_ROW : Double     = 7.0
    static private let CELL_SPACING          : CGFloat    = 10.0
    
    static private let CELL_WIDTH : CGFloat = {
        let deviceWidth = UIScreen.main.bounds.size.width
        let collectionViewWidth = deviceWidth - 2.0*CELL_SPACING        //Collection View Constraints, Leading and trailing
        let remainingWidth = collectionViewWidth - CGFloat(UICollectionView.NUMBER_OF_ITEM_IN_ROW-1.0)*CELL_SPACING     //Cell Spacing
        return remainingWidth/CGFloat(UICollectionView.NUMBER_OF_ITEM_IN_ROW)
    }()
    
    final func setMatricsLayout(){
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = UICollectionView.CELL_SPACING
            layout.itemSize = CGSize(width: UICollectionView.CELL_WIDTH, height: UICollectionView.CELL_WIDTH)
            layout.minimumInteritemSpacing = UICollectionView.CELL_SPACING
            layout.invalidateLayout()
        }
    }
}
