import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routinetitle = ""
    @objc dynamic var routineID = ""
    var task = List<Task>()
}

class Task: Object {
    @objc dynamic var taskTitle = ""
    @objc dynamic var taskID = ""
}
