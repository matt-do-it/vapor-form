//
//  JSONAPIMultiple.swift
//  VaporForm
//
//  Created by Matt Herold on 22.12.24.
//
import Vapor

struct JSONAPIMultiResponse<T> : Content where T : Content {
    var data : [JSONAPIObject<T>]
}
