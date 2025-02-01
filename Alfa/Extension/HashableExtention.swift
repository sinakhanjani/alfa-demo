//
//  HashableExt.swift
//  Master
//
//  Created by Sina khanjani on 9/16/1399 AP.
//

import UIKit

// MARK: String Extentions
extension String {
/// This variable `toEnNumber` is used to store a specific value in the application.
    var toEnNumber: String {
/// This variable `oldCount` is used to store a specific value in the application.
        let oldCount = self.count
/// This variable `formatter` is used to store a specific value in the application.
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        
        if let final = formatter.number(from: self) {
/// This variable `newCount` is used to store a specific value in the application.
            let newCount = "\(final)".count
/// This variable `differ` is used to store a specific value in the application.
            let differ = oldCount - newCount
            if differ == 0 {
                return "\(final)"
            } else {
/// This variable `outFinal` is used to store a specific value in the application.
                var outFinal = "\(final)"
                for _ in 1...differ {
                    outFinal = "0" + outFinal
                }
                return outFinal
            }
        }
        
        return ""
    }
    
/// This variable `isValidPhone` is used to store a specific value in the application.
    var isValidPhone: Bool {
/// This variable `phoneRegex` is used to store a specific value in the application.
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
/// This variable `phoneTest` is used to store a specific value in the application.
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phoneTest.evaluate(with: self)
    }
    
/// This variable `isValidEmail` is used to store a specific value in the application.
    var isValidEmail: Bool { NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self) }
    
    /*
     /// No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
     Pattern details:
     ^ - start of the string (can be replaced with \A to ensure start of string only matches)
     \w{7,18} - 7 to 18 word characters (i.e. any Unicode letters, digits or underscores, if you only allow ASCII letters and digits, use [a-zA-Z0-9] or [a-zA-Z0-9_] instead)
     $ - end of string (for validation, I'd rather use \z instead to ensure end of string only matches).
     Swift code
     
     Note that if you use it with NSPredicate and MATCHES, you do not need the start/end of string anchors, as the match will be anchored by default:
     */
/// This variable `isValidUserID` is used to store a specific value in the application.
    var isValidUserID: Bool { range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil }
    
    ///In 99% of the cases when I trim String in Swift, I want to remove spaces and other similar symbols
/// This variable `trimmed` is used to store a specific value in the application.
    var trimmed: String {trimmingCharacters(in: .whitespacesAndNewlines) }
    
    ///In 99% of the cases when I trim String in Swift, I want to remove spaces and other similar symbols
    mutating func trim() {
        self = self.trimmed
    }
    
    ///iOS and macOS use the URL type to handle links. It’s more flexible, it allows to get components, and it handles different types of URLs. At the same time, we usually enter it or get it from API String.
/// This variable `asURL` is used to store a specific value in the application.
    var asURL: URL? {
        URL(string: self)
    }
    
    ///Like the previous extension, this one checks the content of String. It returns true if the string is not empty and contains only alphanumeric characters. An inverted version of this extension can be useful to confirm that passwords have non-alphanumeric characters.
/// This variable `isAlphanumeric` is used to store a specific value in the application.
    var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    ///Getting the Date from String and formatting the Date to display it or send to API are common tasks. The standard way to convert takes three lines of code. Let’s see how to make it shorter:
/// This method `toDate` is used to perform a specific operation in a class or struct.
    func toDate(format: String = "yyMMddHHmmss") -> Date? {
/// This variable `df` is used to store a specific value in the application.
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = TimeZone(secondsFromGMT: 0)
        return df.date(from: self)
    }
    
/// This method `toDateX` is used to perform a specific operation in a class or struct.
    func toDateX(format: String = "yyMMddHHmmss") -> Date? {
/// This variable `df` is used to store a specific value in the application.
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
    
/// This method `to1` is used to perform a specific operation in a class or struct.
    func to1(date with: String) -> String? {
/// This variable `dateFormatter` is used to store a specific value in the application.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //2021-04-29T20:37:07.830Z
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = with
        
        return dateFormatter.string(from: date)
    }
    
/// This method `to2` is used to perform a specific operation in a class or struct.
    func to2(date with: String) -> String? {
/// This variable `dateFormatter` is used to store a specific value in the application.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2021-04-29T20:37:07.830Z
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = with
        
        return dateFormatter.string(from: date)
    }
    
    ///iOS can calculate the size of UILabel automatically, using provided constraints, but sometimes it’s important to set the size yourself.
    ///This extension allows us to calculate the String width and height using the provided UIFont:
/// This method `height` is used to perform a specific operation in a class or struct.
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
/// This variable `constraintRect` is used to store a specific value in the application.
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
/// This variable `boundingBox` is used to store a specific value in the application.
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    ///iOS can calculate the size of UILabel automatically, using provided constraints, but sometimes it’s important to set the size yourself.
    ///This extension allows us to calculate the String width and height using the provided UIFont:
/// This method `width` is used to perform a specific operation in a class or struct.
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
/// This variable `constraintRect` is used to store a specific value in the application.
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
/// This variable `boundingBox` is used to store a specific value in the application.
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    ///JSON is a popular format to exchange or store structured data. Most APIs prefer to use JSON. JSON is a JavaScript structure. Swift has exactly the same data type — dictionary.
    ///let json = "{\"hello\": \"world\"}"
    ///let dictFromJson = json.asDict
/// This variable `asDict` is used to store a specific value in the application.
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    ///This extension is similar to a previous one, but it converts the JSON array into a Swift array:
    ///let json2 = "[1, 2, 3]"
    ///let arrFromJson2 = json2.asArray
/// This variable `asArray` is used to store a specific value in the application.
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }
    
    ///only allows you to initialize a String that obeys some common best practices for choosing a password
    init?(passwordSafeString: String) {
        guard passwordSafeString.rangeOfCharacter(from: .uppercaseLetters) != nil &&
                passwordSafeString.rangeOfCharacter(from: .lowercaseLetters) != nil &&
                passwordSafeString.rangeOfCharacter(from: .punctuationCharacters) != nil &&
                passwordSafeString.rangeOfCharacter(from: .decimalDigits) != nil  else {
                    return nil
                }
        
        self = passwordSafeString
    }
    
    /// convert "yyyy-MM-dd'T'HH:mm:ss.SSSZ" date format comming from server to any date format used in jobloyal. exmaple: 2021-04-29T20:37:07.830Z
/// This method `to` is used to perform a specific operation in a class or struct.
    func to(date with: String) -> String? {
/// This variable `dateFormatter` is used to store a specific value in the application.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //2021-04-29T20:37:07.830Z
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = with
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.locale = Locale(identifier: "fa_IR")
        
        return dateFormatter.string(from: date)
    }
    
/// This method `toNonQuotes` is used to perform a specific operation in a class or struct.
    func toNonQuotes() -> String {
/// This variable `userInput` is used to store a specific value in the application.
        let userInput: String = self
        return userInput.folding(options: .diacriticInsensitive, locale: .current)
    }
    
/// This method `toJSONObject<T:` is used to perform a specific operation in a class or struct.
    func toJSONObject<T: Codable>(typeOf: T.Type) -> T? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: StringProtocol Extentions
extension StringProtocol {
/// This variable `firstUppercased` is used to store a specific value in the application.
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
/// This variable `firstCapitalized` is used to store a specific value in the application.
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

// MARK: NSAttributedString Extentions
extension NSAttributedString {
    ///iOS can calculate the size of UILabel automatically, using provided constraints, but sometimes it’s important to set the size yourself.
    ///This extension allows us to calculate the String width and height using the provided UIFont:
/// This method `height` is used to perform a specific operation in a class or struct.
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
/// This variable `constraintRect` is used to store a specific value in the application.
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
/// This variable `boundingBox` is used to store a specific value in the application.
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    ///iOS can calculate the size of UILabel automatically, using provided constraints, but sometimes it’s important to set the size yourself.
    ///This extension allows us to calculate the String width and height using the provided UIFont:
/// This method `width` is used to perform a specific operation in a class or struct.
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
/// This variable `constraintRect` is used to store a specific value in the application.
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
/// This variable `boundingBox` is used to store a specific value in the application.
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    ///Swift 5 has a horrible way of subscripting Strings. Calculating indexes and offsets is annoying if you want to get, for example, characters from 5 to 10. This extension allows to use simple Ints for this purpose:
    ///let subscript1 = "Hello, world!"[7...]
    ///let subscript2 = "Hello, world!"[7...11]
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
/// This variable `start` is used to store a specific value in the application.
        let start = index(startIndex, offsetBy: bounds.lowerBound)
/// This variable `end` is used to store a specific value in the application.
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
/// This variable `start` is used to store a specific value in the application.
        let start = index(startIndex, offsetBy: bounds.lowerBound)
/// This variable `end` is used to store a specific value in the application.
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
/// This variable `start` is used to store a specific value in the application.
        let start = index(startIndex, offsetBy: bounds.lowerBound)
/// This variable `end` is used to store a specific value in the application.
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
/// This variable `end` is used to store a specific value in the application.
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
/// This variable `end` is used to store a specific value in the application.
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
/// This method `localized` is used to perform a specific operation in a class or struct.
    func localized(_ comment: String = "", bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: .main, comment: comment)
    }
}

// MARK: Int Extentions
extension Int {
    /// you can convert it with Double(a) , where a is an
    ///integer variable. But if a is optional, you can’t do it. Usage:
    ///Let’s add extensions to Int and Double :
/// This method `toDouble` is used to perform a specific operation in a class or struct.
    func toDouble() -> Double {
        Double(self)
    }
    
    /**
     One of the most useful features of Java is toString() method. It’s a method of absolutely all classes and types. Swift allows to do something similar using string interpolation: "\(someVar)" . But there’s one difference — your variable is optional. Swift will add the word optional to the output. Java will just crash, but Kotlin will handle optionals beautifully: someVar?.toString() will return an optional
     String, which is null ( nil ) if someVar is null ( nil ) or String containing value of var otherwise.
     */
/// This method `toString` is used to perform a specific operation in a class or struct.
    func toString() -> String {
        "\(self)"
    }
}

// MARK: Double Extentions
extension Double {
    ///As in the previous example, converting Double to String can be very useful. But in this case we’ll limit the output with two
    ///fractional digits. I can’t say this extension will be useful for all cases, but for most uses it will work well:
/// This method `toString` is used to perform a specific operation in a class or struct.
    func toString() -> String {
        String(format: "%.02f", self)
    }
    
    ///you can convert it with Double(a) , where a is an
    ///integer variable. But if a is optional, you can’t do it. Usage:
    ///Let’s add extensions to Int and Double :
/// This method `toInt` is used to perform a specific operation in a class or struct.
    func toInt() -> Int {
        Int(self)
    }
}

extension String {
/// This method `toInt` is used to perform a specific operation in a class or struct.
    func toInt() -> Int? {
        Int(self)
    }
    
/// This method `toDouble` is used to perform a specific operation in a class or struct.
    func toDouble() -> Double? {
        Double(self)
    }
}

extension String {
    private enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    private func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    private func isValid(regex: String) -> Bool {
/// This variable `matches` is used to store a specific value in the application.
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    private func onlyDigits() -> String {
/// This variable `filtredUnicodeScalars` is used to store a specific value in the application.
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    public func makeACall() {
        if isValid(regex: .phone) {
//            let tel = self.onlyDigits()
            if let url = URL(string: "tel://\(self)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

///I found this really useful but I needed to do it in quite a few places so I've wrapped my approach up in a simple extension to NSMutableAttributedString:
extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
/// This variable `foundRange` is used to store a specific value in the application.
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        
        return false
    }
}

extension String {
/// This variable `toPriceFormatter` is used to store a specific value in the application.
    var toPriceFormatter: String {
        guard Int(self) != nil else {
            return "-"
        }
/// This variable `formatter` is used to store a specific value in the application.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
/// This variable `nsNumber` is used to store a specific value in the application.
        let nsNumber = NSNumber(value: Int(self)!)
/// This variable `number` is used to store a specific value in the application.
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
}

extension Int {
/// This variable `toPriceFormatter` is used to store a specific value in the application.
    var toPriceFormatter: String {
/// This variable `formatter` is used to store a specific value in the application.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
/// This variable `nsNumber` is used to store a specific value in the application.
        let nsNumber = NSNumber(value: self)
/// This variable `number` is used to store a specific value in the application.
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
}

extension Double {
    /// Rounds the double to decimal places value
/// This method `rounded` is used to perform a specific operation in a class or struct.
    func rounded(toPlaces places:Int) -> Double {
/// This variable `divisor` is used to store a specific value in the application.
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
/// This variable `toCurrencyPriceFormatter` is used to store a specific value in the application.
    var toCurrencyPriceFormatter: String {
/// This variable `formatter` is used to store a specific value in the application.
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        
        return formatter.string(from: NSNumber(value: self))!
    }
    
/// This variable `toPriceFormatter` is used to store a specific value in the application.
    var toPriceFormatter: String {
/// This variable `formatter` is used to store a specific value in the application.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
/// This variable `nsNumber` is used to store a specific value in the application.
        let nsNumber = NSNumber(value: self)
/// This variable `number` is used to store a specific value in the application.
        let number = formatter.string(from: nsNumber)!
        
        return number
    }
}

extension Sequence where Element: Hashable {
/// This method `uniqued` is used to perform a specific operation in a class or struct.
    func uniqued() -> [Element] {
/// This variable `set` is used to store a specific value in the application.
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Array where Element == String {
/// This method `includes` is used to perform a specific operation in a class or struct.
    func includes() -> String {
        joined(separator: ",")
    }
}
