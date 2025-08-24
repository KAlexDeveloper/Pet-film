//
//  FavoriteMovieStoring.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//

import CoreData

protocol FavoriteMovieStoring {
    func fetchAll() -> [FavoriteMovieEntity]
    func save(movie: Movie)
    func delete(by id: Int)
    func isFavorite(id: Int) -> Bool
}

final class CoreDataService: FavoriteMovieStoring {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func fetchAll() -> [FavoriteMovieEntity] {
        let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func save(movie: Movie) {
        guard !isFavorite(id: movie.id) else { return }
        
        let entity = FavoriteMovieEntity(context: context)
        entity.id = Int64(movie.id)
        entity.title = movie.name
        entity.alternativeTitle = movie.alternativeName
        entity.overview = movie.description
        entity.posterUrl = movie.poster?.url ?? ""
        entity.year = movie.year != nil ? String(movie.year!) : nil
        entity.rating = movie.rating?.kp ?? 0.0
        entity.imdbRating = movie.rating?.imdb ?? 0.0
        entity.genresString = movie.genres?.map { $0.name }.joined(separator: ",")
        entity.countriesString = movie.countries?.map { $0.name }.joined(separator: ",")
        entity.externalId = Int64(movie.externalId?.tmdb ?? 0)
        
        CoreDataManager.shared.saveContext()
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func delete(by id: Int) {
        let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        if let result = try? context.fetch(request), let object = result.first {
            context.delete(object)
            CoreDataManager.shared.saveContext()
            NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        let request: NSFetchRequest<FavoriteMovieEntity> = FavoriteMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return ((try? context.fetch(request))?.first) != nil
    }
}
