//
//  FavoritesViewController.swift
//  MyMovieTest
//
//  Created by сонный on 16.07.2025.
//

protocol FavoritesViewProtocol: AnyObject {
    func show(favorites: [FavoriteMovieEntity])
    func showEmptyMessage()
}

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {

    var presenter: FavoritesPresenterProtocol!
    private var favorites: [FavoriteMovieEntity] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width * 0.45, height: 260)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(FavoriteMovieCell.self, forCellWithReuseIdentifier: "FavoriteMovieCell")
        cv.backgroundColor = .white
        return cv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Избранное пусто"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Избранное"
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    func show(favorites: [FavoriteMovieEntity]) {
        self.favorites = favorites
        emptyLabel.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showEmptyMessage() {
        emptyLabel.isHidden = false
        collectionView.isHidden = true
    }
}

// MARK: - UICollectionView

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCell", for: indexPath) as? FavoriteMovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: favorites[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(favorites[indexPath.item])
    }
}

// MARK: - FavoriteMovieCell

final class FavoriteMovieCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.3)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: FavoriteMovieEntity) {
        titleLabel.text = movie.title
        if let url = URL(string: movie.posterUrl ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
//import UIKit
//import SnapKit
//
//protocol FavoritesViewProtocol: AnyObject {
//    func show(favorites: [FavoriteMovieEntity])
//    func showEmptyMessage()
//}
//
//final class FavoritesViewController: UIViewController {
//    
//    var presenter: FavoritesPresenterProtocol!
//    private var favorites: [Movie] = []
//
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: view.frame.width * 0.95, height: 200)
//        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        layout.minimumLineSpacing = 10
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
//        cv.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
//        cv.backgroundColor = .white
//        return cv
//    }()
//
//    private let emptyLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Избранное пусто"
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 18, weight: .medium)
//        label.textColor = .gray
//        label.isHidden = true
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Избранное"
//        view.backgroundColor = .white
//        setupUI()
//        presenter.viewDidLoad()
//    }
//
//    private func setupUI() {
//        view.addSubview(collectionView)
//        view.addSubview(emptyLabel)
//
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        emptyLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//    }
//}
//
//// MARK: - FavoritesViewProtocol
//
//extension FavoritesViewController: FavoritesViewProtocol {
//    func show(favorites: [FavoriteMovieEntity]) {
//        self.favorites = favorites.map { FavoriteMovieMapper.toMovie(from: $0) }
//        collectionView.isHidden = false
//        emptyLabel.isHidden = true
//        collectionView.reloadData()
//    }
//
//    func showEmptyMessage() {
//        self.favorites = []
//        collectionView.isHidden = true
//        emptyLabel.isHidden = false
//    }
//}
//
//// MARK: - UICollectionView
//
//extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, MovieCellDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        favorites.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
//            return UICollectionViewCell()
//        }
//
//        let movie = favorites[indexPath.item]
//        cell.configure(with: movie, isFavorite: true)
//        cell.delegate = self
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let movie = favorites[indexPath.item]
//        presenter.didSelectMovie(movie)
//    }
//
//    func didTapFavorite(for movie: Movie) {
//        presenter.toggleFavorite(movie: movie)
//    }
//}
//
//enum FavoriteMovieMapper {
//    static func toMovie(from entity: FavoriteMovieEntity) -> Movie {
//        return Movie(
//            id: Int(entity.id),
//            title: entity.title ?? "",
//            description: entity.overview,
//            releaseDate: entity.releaseDate ?? "",
//            posterUrl: entity.posterUrl,
//            countries: [Country(name: entity.country ?? "")],
//            rating: Rating(kp: entity.kpRating, imdb: entity.imdbRating)
//        )
//    }
//}
