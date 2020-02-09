//
//  ConvertToData.swift
//  iTunes
//
//  Created by GÖKMEN AKAR on 9.02.2020.
//

import Foundation
//
//func encode<T>(value: T) -> NSData {
//    return withUnsafePointer(to: &value) { (pointer) in
//        return NSData(bytes: pointer, length: sizeOf(T.Type))
//    }
//}

func convertStructToData<T:Codable>(value: T) -> Data {
    return try! JSONEncoder().encode(value)
}

func convertDataToStruct<T: Codable>(data: Data) -> [T] {
    return try! JSONDecoder().decode([T].self, from: data)
}
