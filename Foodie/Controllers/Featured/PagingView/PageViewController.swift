
import UIKit

class PageViewController: UIViewController {
    
    // MARK: - Properties
    
    let restaurantManager = RestaurantServiceManager()
    var restaurants: [Restaurant] = []
    var currentCellIndex = 0
    @IBOutlet weak var pagingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer: Timer?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        restaurants = restaurantManager.fetchData()!
        setUpCollectionView()
        startTimer()
    }
    
    deinit {
           stopTimer()
       }
    
}
    // MARK: - Private Methods

private extension PageViewController{
    
    func setUpCollectionView() {
        pagingCollectionView.dataSource = self
        pagingCollectionView.delegate = self
        pageControl.numberOfPages = restaurants.count
        
        pagingCollectionView.isUserInteractionEnabled = false

    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNext), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNext(){
        if (currentCellIndex < restaurants.count - 1){
            currentCellIndex += 1
        }else {
            currentCellIndex = 0
        }
        
        pagingCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
        
    }
    
    private func stopTimer() {
           timer?.invalidate()
           timer = nil
       }
    
    func configureNavigationBar() {
        self.navigationController?.tabBarItem.title = NSLocalizedString("Featured", comment: "")
        self.navigationController?.tabBarItem.image = UIImage(systemName: "star.circle.fill")

        if let tabBarItem = self.navigationController?.tabBarItem {
            let scaledFont = UIFont.systemFont(ofSize: UIFont.labelFontSize).withSize(12.0)
            tabBarItem.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
    }
}

     // MARK: - UICollection DataSource

extension PageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! PageCollectionViewCell
        let data = restaurants[indexPath.row]
        cell.setUpCell(img: data.imageName, name: data.name, city: data.city)
        
        return cell
    }
    
}

extension PageViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




