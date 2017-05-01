//
//  BackendError.swift
//  GeoBork
//
//  Created by Tania on 11/04/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation
enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
