import Foundation
import UIKit
 
struct Feedbacker {
 
  static func notice(type: UINotificationFeedbackGenerator.FeedbackType) {
    if #available(iOS 10.0, *) {
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(type)
    }
  }
 
  static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    if #available(iOS 10.0, *) {
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.prepare()
      generator.impactOccurred()
    }
  }
 
  static func selection() {
    if #available(iOS 10.0, *) {
      let generator = UISelectionFeedbackGenerator()
      generator.prepare()
      generator.selectionChanged()
    }
  }
}
//使い方(ボタンの記述にこの１行追加するだけ)
 
// notice
//Feedbacker.notice(type: .success)
//Feedbacker.notice(type: .warning)
//Feedbacker.notice(type: .error)
 
// impact
//Feedbacker.impact(style: .heavy)
//Feedbacker.impact(style: .light)
//Feedbacker.impact(style: .medium)
 
// selection
//Feedbacker.selection()
