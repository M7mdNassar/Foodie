
import Foundation
 
    // MARK: - Assistent

protocol ApiDelegate{
    
    func didRetriveData(user:UserResult)
}


//Connect to Internet (API):

// 1. Create URL
// 2. Create URLSession
// 3. Create Task
// 4. Start / Resume Task


class UserApi{
    
    let urlBase = "https://randomuser.me/api/"
    
    var delegate: ApiDelegate?
    
    func feachData(){
        
        // 1. create url
    
        if let url = URL(string: urlBase){
            
            // 2. create URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3.create Task
            
            let task = session.dataTask(with: url, completionHandler: taskHandler(data:url:error:) )
            
            // 4. start / resume task
            
            task.resume()
        }
    }
    
    // i dont need use clousur in compleation handler.. i need make method
    
    func taskHandler(data:Data? , url:URLResponse? , error:Error?){
             do{
                 let user:UserResult = try JSONDecoder().decode(UserResult.self, from: data!)
                //print(user)
                 delegate?.didRetriveData(user: user)
             }catch{
                 print(error)
             }
         }
    }
