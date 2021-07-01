//
//  ApiError.swift
//  Ashtanga Yoga Cork
//
//  Created by daoneill on 19/06/2021.
//

import Foundation

class ApiError: ObservableObject {
    @Published var shown: Bool = false
    @Published var title: String = ""
    @Published var description: String = ""
    
    init(_ title: String, _ description: String){
        self.title = title
        self.description = description
    }
}
