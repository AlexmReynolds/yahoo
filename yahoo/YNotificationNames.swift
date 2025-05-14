//
//  YNotificationNames.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import Foundation

enum YNotificationName: String {
    case settingsChanged
    func toName() -> Notification.Name {
        return Notification.Name.init(self.rawValue)
    }
}
