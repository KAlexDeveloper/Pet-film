//
//  FavoritesViewController.swift
//  MyMovieTest
//
//  Created by сонный on 16.07.2025.
//
import UIKit
import SnapKit

protocol FavoritesViewProtocol: AnyObject {
    func show(favorites: [FavoriteMovieEntity])
    func showEmptyMessage()
}

final class FavoritesViewController: UIViewController {
    
    var presenter: FavoritesPresenterProtocol!
    private var favorites: [FavoriteMovieEntity] = []
    
    private let labelName = UILabel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        // Заголовок
        labelName.text = "Избранное"
        labelName.textColor = .myPinkSecond
        labelName.font = .systemFont(ofSize: 26, weight: .bold)
        labelName.textAlignment = .center
        labelName.backgroundColor = .clear
        view.addSubview(labelName)
        
        // Коллекция
        collectionView.backgroundColor = .white
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // Пустое сообщение
        view.addSubview(emptyLabel)
        
        // Констрейнты
        labelName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(labelName.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
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
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MovieCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = FavoriteMovieMapper.toMovie(from: favorites[indexPath.item])
        cell.configure(with: movie, isFavorite: true)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(favorites[indexPath.item])
    }
    
    func didTapFavorite(for movie: Movie) {
        presenter.toggleFavorite(movie: movie)
    }
    
    // Размер
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 * 2
        let width = collectionView.frame.width - padding
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}
