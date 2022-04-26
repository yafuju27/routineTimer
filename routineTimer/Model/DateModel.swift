import Foundation



class DateModel{
    
    func getTodayDate() -> String {
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = formatter.string(from: now)
        
        return dateString
    }
}

