//
//  String+.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/27.
//

import Foundation

extension String {

    var isEmailForm: Bool {
        let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]$"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        guard let _ = regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else { return false }
        return true
    }

    var isPasswordForm: Bool {
        if self.count < 8 { return false }

        let passwordPattern = "^[0-9a-zA-Z!@#$%]*$"
        let regex = try? NSRegularExpression(pattern: passwordPattern)
        guard let _ = regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else { return false }

        let regexNumber = try? NSRegularExpression(pattern: "[0-9]")
        guard let _ = regexNumber?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else { return false }

        let regexAlphabet = try? NSRegularExpression(pattern: "[a-zA-Z]")
        guard let _ = regexAlphabet?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else { return false }

        let regexSpecialChar = try? NSRegularExpression(pattern: "[!@#$%]")
        guard let _ = regexSpecialChar?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) else { return false }

        return true
    }

    var isDateForm: Bool {
        if self == "" { return false }
        // yyyyMMdd
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let _ = dateFormatter.date(from: self) {
            return true
        } else { return false }
    }

    func dateFormatTransForUser() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = dateFormatter.date(from: self) else { return nil }

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: date)
    }

}
