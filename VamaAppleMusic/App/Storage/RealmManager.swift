//
//  RealmManager.swift
//  VamaAppleMusic
//
//  Created by Yogendra Solanki on 18/10/22.
//

import Realm
import RealmSwift

final class RealmManager {
    
    // MARK: Add
    
    /// Add single RealM object in local database
    /// - Parameters:
    ///   - data: RealM Object
    ///   - update: isUpdate
    static func addObject<T: Object>(_ data: T, update: Bool = true) {
        addObjects([data], update: update)
    }
    
    /// add RealM objects in local database
    /// - Parameters:
    ///   - data: array of data needs to be added
    ///   - update: isUpdate
    static func addObjects<T: Object>(_ data: [T], update: Bool = true) {
        do {
            let realm = try Realm()
            realm.refresh()
            if realm.isInWriteTransaction {
                realm.add(data, update: (update ? .modified : .all))
            } else {
                try? realm.write {
                    realm.add(data, update: (update ? .modified : .all))
                }
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    // MARK: Get
    
    /// get single object of type based on predicate
    /// - Parameters:
    ///   - type: Type of RealM object
    ///   - key: primary key
    /// - Returns: Object of requested type
    static func getObject<T: Object>(_ type: T.Type, key: Any) -> T? {
        do {
            let realm = try Realm()
            realm.refresh()
            return realm.object(ofType: type, forPrimaryKey: key)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    /// getObjects of type from local database based on predicate
    /// - Parameters:
    ///   - type: Type of RealM object
    ///   - predicate: predicate
    /// - Returns: Results/Objects of requested type
    static func getObjects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        do {
            let realm = try Realm()
            realm.refresh()
            guard let notNilPredicate = predicate else {
                return realm.objects(type)
            }
            return realm.objects(type).filter(notNilPredicate)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: Delete
    
    /// deleteObject
    /// - Parameter data: Type
    static func deleteObject<T: Object>(_ data: T) {
        deleteObjects([data])
    }
    
    /// deleteObjects
    /// - Parameter data: Type
    static func deleteObjects<T: Object>(_ data: [T]) {
        do {
            let realm = try Realm()
            realm.refresh()
            try? realm.write {
                realm.delete(data)
            }
        }  catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    /// deleteAllObjects of requested type
    /// - Parameter data: type
    static func deleteAllObjects<T: Object>(_ data: T.Type) {
        do {
            let realm = try Realm()
            try? realm.write {
               realm.delete(realm.objects(T.self))
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    // MARK: Clean up
    
    /// clear all data from local database
    static func cleanUp() {
        do {
            let realm = try Realm()
            realm.refresh()
            try? realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
}

// MARK: Configure

extension RealmManager {
    
    /// configure Realm
    static func configureRealm() {
        let fileManager = FileManager.default
        var config = Realm.Configuration()
        
        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        if let applicationSupportURL = urls.last {
            do {
                try fileManager.createDirectory(at: applicationSupportURL, withIntermediateDirectories: true, attributes: nil)
                config.fileURL = applicationSupportURL.appendingPathComponent("VamaAppleMusic.realm")
            } catch let err {
                debugPrint(err)
            }
        }
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
