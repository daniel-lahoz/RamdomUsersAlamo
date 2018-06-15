//
//  ArrayExtensions.swift
//  RamdomUsersAlmo
//
//  Created by Daniel Lahoz on 14/6/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Hashtable and Equatalbe Extension for get Unique Elements genderator @see: http://stackoverflow.com/a/33553374
public extension Sequence where Iterator.Element: Hashable {
    var uniqueElements: [Iterator.Element] {
        return Array(
            Set(self)
        )
    }
}
public extension Sequence where Iterator.Element: Equatable {
    var uniqueElements: [Iterator.Element] {
        return self.reduce([]) {uniqueElements, element in
            uniqueElements.contains(element) ? uniqueElements : uniqueElements + [element]
        }
    }
}

// MARK: - Array extension for remove objects and get favorites
extension Array where Element: User {

    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }

    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }

    mutating func sortByName() {
        self.sort(by: { $0.name < $1.name })
    }

    mutating func sortByGender() {
        self.sort(by: { $0.gender < $1.gender })
    }

    func favoriteElements() -> [User] {
        return self.reduce([]) {favoriteElements, element in
            element.favorite ? favoriteElements + [element] : favoriteElements
        }
    }

    func onekmElements(_ location: CLLocation) -> [User] {
        return self.reduce([]) {onekmElements, element in
            element.fakelocation.distance(from: location) < 1000 ? onekmElements + [element] : onekmElements
        }

    }

    func filtredElements(_ filtred: String) -> [User] {

        if filtred.count > 0 {

            let emailList = self.filter({
                if $0.email.range(of: filtred) != nil {
                    return true
                }
                return false
            })

            let namelList = self.filter({
                if $0.name.range(of: filtred) != nil {
                    return true
                }
                return false
            })

            let surnameList = self.filter({
                if $0.surname.range(of: filtred) != nil {
                    return true
                }
                return false
            })

            let rawList = emailList + namelList + surnameList
            let list = rawList.uniqueElements

            return list

        }

        return self
    }

}
