//
//  JSONAPISingleRequest.swift
//  VaporForm
//
//  Created by Matt Herold on 23.12.24.
//

import Vapor

struct JSONAPISingleRequest<T> : Content where T : Content {
    var data : JSONAPIObject<T>
}
