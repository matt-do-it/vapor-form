//
//  JSONLinksResponse.swift
//  VaporForm
//
//  Created by Matt Herold on 23.12.24.
//
import Vapor

struct JSONAPILinksResponse : Content  {
    var selfLink : URL
    var first : URL?
    var last : URL?
    var prev : URL?
    var next : URL?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case first = "first"
        case last = "last"
        case prev = "prev"
        case next = "next"
    }
    
}

