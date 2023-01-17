//
//  CoursesModel.swift
//  cookiesTestApp
//
//  Created by mac on 1/16/23.
//

import Foundation

struct CoursesModel: Decodable {
    var pagination: Pagination
    var courses: [Course]
}

struct Pagination: Decodable {
    var page: Int
    var limit: Int
    var count: Int
}

struct Course: Decodable {
    var id: Int
    var type: String
    var status: String
    var minUserToStart: Int
    var imageUrl: String
    var createDate: String
    var updateDate: String
    var title: String
}
