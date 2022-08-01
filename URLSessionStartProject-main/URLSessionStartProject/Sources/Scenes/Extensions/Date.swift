//
//  Extensions.swift
//  URLSessionStartProject
//
//  Created by Daniil Yarkovenko on 03.06.2022.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
