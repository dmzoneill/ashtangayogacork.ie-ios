//
//  ApiError.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 02/05/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
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
