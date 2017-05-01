//
//  Bork
//  GeoBork
//
//  Created by Tania on 28/03/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation


//recevied json {"_id":"58d03934f46bfb000f144379","type":"inspector","name":"inspector","loc":[32.097418246610346,34.77824890784302],"updated":1490041140476}
struct Bork: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    let id: String
    let name: String
    let type: String
    let loc : (latitude:Double, longitude:Double)
    let updated: Int64
    
    var description: String {
        return "User: { name: \(name) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        print(response.url?.lastPathComponent ?? "")
        guard
            let representation = representation as? [String: Any],
            let id = representation["_id"] as? String,
            let name = representation["name"] as? String,
            let type = representation["type"] as? String,
            let updated = representation["updated"] as? Int64,
            let loc = representation["loc"] as? [Double]
            else { return nil }
        
        self.id = id
        self.name = name
        self.type = type
        self.updated = updated
        self.loc = (latitude: loc[0], longitude: loc[1])
    }
}
