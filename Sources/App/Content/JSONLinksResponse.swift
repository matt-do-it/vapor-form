//
//  JSONLinksResponse.swift
//  VaporForm
//
//  Created by Matt Herold on 23.12.24.
//
import Vapor

struct JSONAPILinksResponse : Content  {
    var selfLink : URL
  
    enum CodingKeys: String, CodingKey {
            case selfLink = "self"
        }

}

