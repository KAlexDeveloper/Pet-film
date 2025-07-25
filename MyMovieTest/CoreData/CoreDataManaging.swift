//
//  CoreDataManaging.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//


import CoreData

protocol CoreDataManaging {
    var context: NSManagedObjectContext { get }
    func saveContext()
}

final class CoreDataManager: CoreDataManaging {
    static let shared = CoreDataManager()

    private init() {
        persistentContainer = NSPersistentContainer(name: "FavoriteMovieEntity") // Имя .xcdatamodeld
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Core Data load error: \(error)")
            }
        }
    }

    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
}
