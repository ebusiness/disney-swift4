//
//  CoreData.swift
//  disneyNavigationPreview
//
//  Created by ebuser on 2018/01/29.
//  Copyright © 2018 ebuser. All rights reserved.
//

import CoreData
import UIKit

class DB {

    static var context: NSManagedObjectContext! {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return app.persistentContainer.viewContext
    }

    static func save() {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        app.saveContext()
    }

}

// 闹钟
extension DB {

    struct AlarmModel {
        let park: TokyoDisneyPark
        let str_id: String
        let lang: Language
        let name: String
        let time: Date
        let thum: String
        let identifier: String
    }

    static func insert(alarm: AlarmModel) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = app.persistentContainer.viewContext

        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "Alarm", into: managedContext) as? Alarm else { return }
        entity.park = alarm.park.rawValue
        entity.str_id = alarm.str_id
        entity.lang = alarm.lang.rawValue
        entity.name = alarm.name
        entity.time = alarm.time
        entity.thum = alarm.thum
        entity.identifier = alarm.identifier
        app.saveContext()
    }

    static func exists(alarmIdentifier: String) -> Bool {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = app.persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", alarmIdentifier)
            let fetchResult = try managedContext.fetch(fetchRequest)
            if !fetchResult.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            print("Fetch error!")
        }
        return false
    }

    static func delete(alarmIdentifier: String) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = app.persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier = %@", alarmIdentifier)
            let fetchResults = try managedContext.fetch(fetchRequest)
            for object in fetchResults {
                managedContext.delete(object)
            }
            app.saveContext()
        } catch {
            print("Delete error!")
        }
    }
}
