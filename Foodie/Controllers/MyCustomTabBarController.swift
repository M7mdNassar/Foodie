
import UIKit
import Foundation

class MyCustomTabBarController : UITabBarController {
    
    let btnMiddle : UIButton = {
       let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = UIColor.foodieLightBlue
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -20, width: 60, height: 60)
        btnMiddle.addTarget(self, action: #selector(btnMiddleTapped), for: .touchUpInside)
        
        
        // Disable the last tab
        disableTab(atIndex: 2)

    }
    
    @objc func btnMiddleTapped() {
        // get the first tab , not new instance of community controller
        guard let communityViewController = viewControllers?[0] as? CommunityViewController else {
            return
        }

        let addPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController

        // Pass the reference to CommunityViewController to AddPostViewController
        addPostVC.communityViewController = communityViewController


        // Present the AddPostViewController
        present(addPostVC, animated: true, completion: nil)
    }

    
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        let path: UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.foodieLightBlue.cgColor
        shape.fillColor = UIColor.foodieLightBlue.cgColor

        self.tabBar.layer.insertSublayer(shape, at: 0)

        self.tabBar.tintColor = UIColor.foodieLightGreen
    }

    
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.view.bounds.height  // Use the view's height to align with the bottom
        let holeWidth = 150
        let holeHeight = 50
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)

        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1. Line
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6, y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I

        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II

        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // part III
        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
        path.close()
        return path
    }
    
    
    func disableTab(atIndex index: Int) {
        
         if let tabBarItem = viewControllers?[index].tabBarItem {
             tabBarItem.isEnabled = false
         }
     }

}
