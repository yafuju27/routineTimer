import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routinetitle = ""
    @objc dynamic var routineID = UUID().uuidString
    var task = List<Task>()
}

class Task: Object {
    @objc dynamic var taskTitle = ""
    @objc dynamic var taskID = ""
}

extension Routine {
    func createRoutine(routineTitle: String) {
        let realm = try! Realm()
        let routine = Routine()
        routine.routinetitle = routineTitle
        try! realm.write {
            realm.add(routine)
        }
    }
}
