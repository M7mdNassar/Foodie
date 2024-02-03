
import Foundation
import FirebaseFirestoreInternal


enum FCollectionReference : String{
    case User
}

// MARK: Get the refernce of specific collection

func FirestoreReference(collectionReference : FCollectionReference) -> CollectionReference
{
    return Firestore.firestore().collection(collectionReference.rawValue)
}


