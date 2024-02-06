
import UIKit

class ExpandableLabel :UILabel {
    
    var isExpaded = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let buttonAray =  self.superview?.subviews.filter({ (subViewObj) -> Bool in
            return subViewObj.tag ==  9090
        })
        
        if buttonAray?.isEmpty == true {
            self.addReadMoreButton()
        }
    }
    
    //Add readmore button in the label.
    func addReadMoreButton() {
        
        let theNumberOfLines = self.countLines()
        
        let height = self.frame.height
        self.numberOfLines =  self.isExpaded ? 0 : min(2,theNumberOfLines)
        
        if theNumberOfLines > 2{
            
            self.numberOfLines = 2
            
            let button = UIButton(frame: CGRect(x: 0, y: height+17, width: 70, height: 15))
            button.tag = 9090
            button.frame = self.frame
            button.frame.origin.y =  self.frame.origin.y  +  self.frame.size.height + 25
            button.setTitle("إقرأ المزيد", for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(17)
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.blue, for: .normal)
            button.addTarget(self, action: #selector(ExpandableLabel.buttonTapped(sender:)), for: .touchUpInside)
            self.superview?.addSubview(button)
            self.superview?.bringSubviewToFront(button)
            button.setTitle("أقل", for: .selected)
            button.isSelected = self.isExpaded
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                button.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: +17)
                ])
        }
        
    }
    
    //Calculating the number of lines. -> Int
    func countLines() -> Int{
        guard let text = self.text else {return 0}
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : self.font as Any], context: nil)
        
        return Int(ceil(labelSize.height / self.font.lineHeight))
        
    }
    
    //ReadMore Button Action
    @objc func buttonTapped(sender : UIButton) {
        
        self.isExpaded = !isExpaded
        sender.isSelected =   self.isExpaded
        
        self.numberOfLines =  sender.isSelected ? 0 : 2
        
        self.layoutIfNeeded()
        
        var viewObj :UIView?  = self
        var cellObj :UITableViewCell?
        while viewObj?.superview != nil  {
          
           if let cell = viewObj as? UITableViewCell  {
                
              cellObj = cell
            }
            
            if let tableView = (viewObj as? UITableView)  {
               
                if let indexPath = tableView.indexPath(for: cellObj ?? UITableViewCell()){
                                        
                    tableView.beginUpdates()
                    print(indexPath)
                    tableView.endUpdates()
                    
                }
                return
            }

            viewObj = viewObj?.superview
        }
        
    }
    
}
