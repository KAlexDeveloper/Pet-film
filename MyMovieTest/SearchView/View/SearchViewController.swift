//
//  SearchViewProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit
import SnapKit

protocol SearchViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

final class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol!
    
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let collectionView: UICollectionView
    
    private var movies: [Movie] = []
    
    // MARK: - Init
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 250)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // TextField
        searchTextField.placeholder = "Введите название фильма"
        searchTextField.borderStyle = .roundedRect
        view.addSubview(searchTextField)
        
        // Button
        searchButton.setTitle("Найти", for: .normal)
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        view.addSubview(searchButton)
        
        // Collection
        collectionView.backgroundColor = .white
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // Layout
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func searchTapped() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        presenter.searchButtonTapped(with: query)
        print("Нажата кнопка поиска с запросом: \(query)")
    }
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol {
    func showMovies(_ movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
        print("Отображаем \(movies.count) фильмов")
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        // Можно добавить loader, например, UIActivityIndicatorView
    }
    
    func hideLoading() {
        // Скрыть loader
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        presenter.didSelectMovie(movie)
    }
}
