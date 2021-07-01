//
//  Device.swift
//  Ashtanga Yoga Cork
//
//  Created by Ashtanga Yoga Cork on 30/04/2020.
//  Copyright © 2020 Ashtanga Yoga Cork. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class AYCDevice {
    public static let systemVersion = UIDevice.current.systemVersion
    public static let modelName = UIDevice.modelName
    public static func getDescription() -> String {
        var bugreportTemplate: String = ""
        bugreportTemplate += "Model: \(modelName)\n"
        bugreportTemplate += "System Version: \(systemVersion)\n\n"
        bugreportTemplate += "Steps to reproduce:\nI clicked the buy button and nothing happened happened\n\n"
        bugreportTemplate += "Expected Result:\nI expected the buy view to be presented\n\n"
        bugreportTemplate += "Actual Result:\nThe view did show\n\n"
        bugreportTemplate += "Severity/Priority:\nHigh severity.  I am unable to puchase and book classes\n\n"
        return bugreportTemplate
    }
}
