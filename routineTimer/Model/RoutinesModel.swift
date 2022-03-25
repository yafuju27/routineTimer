import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routinetitle = ""
    @objc dynamic var routineID = UUID().uuidString
    var task = List<Task>()
}

class Task: Object {
    @objc dynamic var taskTitle = ""
    @objc dynamic var taskID = UUID().uuidString
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
    
    func createTask(routineID: String, taskTitle: String) {
        let realm = try! Realm()
        let target = realm.objects(Routine.self).filter("routineID == %@", routineID).first
        let task = Task(value: ["taskTitle": taskTitle])
        task.taskTitle = taskTitle
        
        
        try! realm.write {
            target?.task.append(task)
        }
    }
}
