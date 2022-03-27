import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routinetitle = ""
    @objc dynamic var routineID = UUID().uuidString
    var task = List<Task>()
    override class func primaryKey() -> String? {
        return "routineID"
    }
}

class Task: Object {
    @objc dynamic var taskTitle = ""
    @objc dynamic var taskTime: Int = 0
    @objc dynamic var taskID = UUID().uuidString
    override class func primaryKey() -> String? {
        return "taskID"
    }
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
    
    func updateRoutine(routineID: String, routineTitle: String) {
        let realm = try! Realm()
        let target = realm.object(ofType: Routine.self, forPrimaryKey: routineTitle)
        try! realm.write {
            target?.routinetitle = routineTitle
        }
    }
    
    func createTask(taskTitle: String, taskTime: Int, routineID: String) {
        let realm = try! Realm()
        let target = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        let task = Task(value: ["taskTitle": taskTitle, "taskTime": taskTime])
        task.taskTitle = taskTitle
        task.taskTime = taskTime
        try! realm.write {
            target?.task.append(task)
        }
    }

    func updateTask(taskTitle: String, taskTime: Int, routineID: String, taskID: String) {
        let realm = try! Realm()
        let target = realm.object(ofType: Task.self, forPrimaryKey: taskID)
        try! realm.write {
            if let target = target {
                target.taskTitle = taskTitle
                target.taskTime = taskTime
            }
        }
    }
}
