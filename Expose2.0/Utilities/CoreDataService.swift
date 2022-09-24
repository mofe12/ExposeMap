//
//  CoreDataService.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 9/16/22.
//

import Foundation
import CoreData


class CoreDataService{
    static let instance = CoreDataService() // Singleton
    
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    
    
    init() {
        container = NSPersistentContainer(name: "AppInterestContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING DATA. \(error)")
            }
        }
        
        context = container.viewContext
    }
    
    func save(){
        do{
            try context.save()
            print("SAVING SUCCESSFUL.")
        }catch let error{
            print("ERROR SAVING CORE DATA. \(error.localizedDescription)")
        }
    }
}
