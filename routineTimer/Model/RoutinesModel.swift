import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routineTitle = ""
    @objc dynamic var totalTime = 0
    @objc dynamic var routineID = UUID().uuidString
    var task = List<Task>()
    override class func primaryKey() -> String? {
        return "routineID"
    }
}

class RoutineList: Object {
    let list = List<Routine>()
}

class Task: Object {
    @objc dynamic var taskTitle = ""
    @objc dynamic var taskTime = 0
    @objc dynamic var taskID = UUID().uuidString
    override class func primaryKey() -> String? {
        return "taskID"
    }
}

extension Routine {
    func createRoutine(routineTitle: String) {
        let realm = try! Realm()
        let routine = Routine()
        routine.routineTitle = routineTitle
        try! realm.write {
            realm.add(routine)
        }
    }
    
    func updateRoutine(routineID: String, routineTitle: String) {
        let realm = try! Realm()
        let target = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        try! realm.write {
            target?.routineTitle = routineTitle
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
    
    func calcTotalTime(routineID: String, taskTime: Int) {
        let realm = try! Realm()
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        var totalValue:Int = 0
        if let targetRoutine = targetRoutine {
            for task in targetRoutine.task {
                totalValue += task.taskTime
            }
        }
        //let totalValue:Int = realm.objects(Task.self).sum(ofProperty: "taskTime")
        try! realm.write {
            targetRoutine?.totalTime = totalValue
        }
    }
}

