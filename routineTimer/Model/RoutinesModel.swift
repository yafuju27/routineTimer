import Foundation
import RealmSwift

class Routine: Object {
    @objc dynamic var routineTitle = ""
    @objc dynamic var totalTime = 0
    @objc dynamic var routineID = UUID().uuidString
    @objc dynamic var routineOrder = 0
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
    @objc dynamic var taskOrder = 0
    override class func primaryKey() -> String? {
        return "taskID"
    }
}

extension Routine {
    func createRoutine(routineTitle: String, routineOrder: Int) {
        let realm = try! Realm()
        let routine = Routine()
        let orderNumber = realm.objects(Routine.self).count
        routine.routineTitle = routineTitle
        routine.routineOrder = orderNumber
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
        let orderNumber:Int = target?.task.count ?? 0
        let task = Task(value: ["taskTitle": taskTitle, "taskTime": taskTime])
        task.taskTitle = taskTitle
        task.taskTime = taskTime
        task.taskOrder = orderNumber
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
        try! realm.write {
            targetRoutine?.totalTime = totalValue
        }
    }
    
    func removeRoutine(indexPath: Int) {
        let realm = try! Realm()
        let routineItems = realm.objects(Routine.self).sorted(byKeyPath: "routineOrder", ascending: true)
        
        let item = routineItems[indexPath]
        try! realm.write {
        let nextOrder:Int = item.routineOrder + 1
        let lastOrder:Int = routineItems.count - 1
        if lastOrder == 0 || nextOrder == routineItems.count {
        } else {
            for index in nextOrder...lastOrder {
                let object = routineItems[index]
                object.routineOrder -= 1
            }
        }
            realm.delete(item)
        }
    }
    
//    func removeTask(indexPath: Int) {
//        let realm = try! Realm()
//        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
//        let taskItems = realm.object(ofType: Routine.self, forPrimaryKey: routineID)?.task.sorted(byKeyPath: "taskOrder", ascending: true)
//        let item = taskItems?[indexPath]
//    try! realm.write {
//        let nextOrder = (item?.taskOrder ?? 0) + 1
//        let lastOrder = (taskItems?.count ?? 0) - 1
//        if lastOrder == 0 || nextOrder == taskItems?.count {
//            targetRoutine?.totalTime -= item?.taskTime ?? 0
//        } else {
//            targetRoutine?.totalTime -= item?.taskTime ?? 0
//            for index in nextOrder...lastOrder {
//                let object = taskItems?[index]
//                object?.taskOrder -= 1
//            }
//        }
//        realm.delete(item!)
//    }
//    }
}
