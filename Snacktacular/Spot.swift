//
//  Spot.swift
//  Snacktacular
//
//  Created by Brenden Picioane on 10/31/20.
//  Copyright © 2020 Brenden Picioane. All rights reserved.
//

import Foundation
import Firebase

class Spot {
    var name: String
    var address: String
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String : Any] {
        return ["name" : name, "address" : address, "averageRating" : averageRating, "numberOfReviews" : numberOfReviews, "postingUserID" : postingUserID]
    }
    
    init(name: String, address: String, averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", address: "", averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String : Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        self.init(name: name, address: address, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("L. Don't have a valid posting user ID.")
            return completion(false)
        }
        self.postingUserID = postingUserID
        let dataToSave: [String : Any] = self.dictionary
        print(dataToSave["name"]!)
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    print("L. error making doc. \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("W. added document \(self.documentID)")
                completion(true)
            }
        } else {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("L. error updating doc. \(error!.localizedDescription)")
                    return completion(false)
                }
                print("W. updated document \(self.documentID)")
                completion(true)
            }
        }
    }
}
