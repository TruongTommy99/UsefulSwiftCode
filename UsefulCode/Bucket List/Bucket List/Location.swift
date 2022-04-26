//
//  Location.swift
//  Bucket List
//
//  Created by Truong Tommy on 4/12/22.
//

import Foundation

struct Location: Identifiable,Codable,Equatable {
    let id : UUID
    var name : String
    var description : String
    let latitude : Double
    let longitude : Double
}


