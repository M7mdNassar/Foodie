
import Foundation
import Firebase

class FUserListener{
    
    // MARK: variables
    
    static let shared = FUserListener()
    
    // MARK: Private Initializer (singleton)
    
    private init (){}
    
    // MARK: Login
    
    func loginUserWith(email: String , password: String , completion : @escaping (_ error: Error? , _ isEmailVerified : Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResults, error in
            
            if error == nil && authResults!.user.isEmailVerified{
                completion(error , true)
                self.downloadUserFromFirestore(userId: authResults!.user.uid)
            }
            else{
                completion(error , false)
            }
        }
    }
    
    // MARK: Logout
    
    func logoutUser(completion : @escaping (_ error : Error?) -> Void){
        
        do{
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            completion(nil)
            
        }catch let error as NSError {
            completion(error)
        }
        
    }
    
    // MARK: Register
    
    func registerUserWith(email: String , password:String , completion: @escaping (_ error : Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) {(authResults , error) in
            
            completion(error)
            
            if error == nil{
                authResults!.user.sendEmailVerification { error in
                    
                    completion(error)
                }
            }
            
            if authResults?.user != nil {
                let user = User(id: authResults!.user.uid, userName: email, email: email, pushId: "" , avatarLink: "" , date: "" , phoneNumber:"" , country: "")
                
                self.saveUserToFierbase(user: user)
                saveUserLocally(user: user)

            }
            
        }
        
    }
    
    // MARK: Save To Firebase store
    
    func saveUserToFierbase(user : User){
        
        do{
           try FirestoreReference(collectionReference: .User).document(user.id).setData(from:user)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // MARK: Download User From Firestore
    
    func downloadUserFromFirestore(userId : String){
        FirestoreReference(collectionReference: .User).document(userId).getDocument { document, error in
            
            guard let userDocument = document else {
                print("No data found")
                return
            }
            
            let result = Result{
                
                try? userDocument.data(as: User.self)     // bcoz FirebaseFirestoreSwift , you can convert document data to user object
            }
            
            switch result{
                
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user: user)
                }
                else{
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error in decoding ", error.localizedDescription)
            }
            
        }
    }
    
    
    
    // MARK: Resend Verfication With Email
    
    func resendVerficationEmailWith(email: String , completion : @escaping (_ error: Error?) -> Void){
        
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    
    // MARK: Resend Password
    
    func resetPasswordFor(email: String , completion: @escaping (_ error: Error?) -> Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    
    }
    
}
