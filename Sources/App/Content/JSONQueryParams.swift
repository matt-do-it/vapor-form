//
//  JSONQueryParams.swift
//  VaporForm
//
//  Created by Matt Herold on 24.12.24.
//
import Vapor

struct JSONQueryParams : Content {
    var page : JSONQueryPageParams?
}
