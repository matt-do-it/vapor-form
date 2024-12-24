//
//  JSONQueryPageParams.swift
//  VaporForm
//
//  Created by Matt Herold on 24.12.24.
//
import Vapor

struct JSONQueryPageParams : Content {
    var offset : Int?
    var limit : Int?
}
