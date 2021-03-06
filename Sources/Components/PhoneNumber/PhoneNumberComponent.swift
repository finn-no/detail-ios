//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct PhoneNumberComponent: Component {
    public let id: String
    public let phoneNumber: String
    let descriptionText: String
    let showNumberText: String
    let accessibilityLabelPrefix: String

    public init(id: String = UUID().uuidString, phoneNumber: String, descriptionText: String, showNumberText: String, accessibilityLabelPrefix: String) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.descriptionText = descriptionText
        self.showNumberText = showNumberText
        self.accessibilityLabelPrefix = accessibilityLabelPrefix
    }

    var formattedPhoneNumber: String? {
        if phoneNumber.count > 8 {
            let landCodeIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let firstIndex = phoneNumber.index(landCodeIndex, offsetBy: 3)
            let middleIndex = phoneNumber.index(firstIndex, offsetBy: 2)

            let landCodeString = phoneNumber.prefix(upTo: landCodeIndex)
            let landCodeAndFirstString = phoneNumber.prefix(upTo: firstIndex)
            let firstString = landCodeAndFirstString.suffix(from: landCodeIndex)
            let firstAndMiddleString = phoneNumber.prefix(upTo: middleIndex)
            let middleString = firstAndMiddleString.suffix(from: firstIndex)
            let lastString = phoneNumber.suffix(from: middleIndex)

            let firstHalfOfString = landCodeString + " " + firstString + " "

            return firstHalfOfString + middleString + " " + lastString
        } else {
            let firstIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            let middleIndex = phoneNumber.index(firstIndex, offsetBy: 2)

            let firstString = phoneNumber.prefix(upTo: firstIndex)
            let firstAndMiddleString = phoneNumber.prefix(upTo: middleIndex)
            let middleString = firstAndMiddleString.suffix(from: firstIndex)
            let lastString = phoneNumber.suffix(from: middleIndex)

            return firstString + " " + middleString + " " + lastString
        }
    }
}
