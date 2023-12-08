
import Foundation
import UIKit

// MARK: Extension UITableView

extension UITableView{
    
    func register<cell: UITableViewCell>(Cell : cell.Type){
        
        let nibName = String(describing: cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeue<Cell : UITableViewCell >() -> Cell {
        
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell
                
        else {
            fatalError("Error")
        }
    return cell

    }
}
