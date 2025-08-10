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
    
    private let labelName = UILabel()
    private let searchContainerView = UIView()
    private let searchBackgroundView = UIView()
    private let searchPrefixImageView = UIImageView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .custom)
    private let leftSeparatorView = UIView()
    private let rightSeparatorView = UIView()
    private let collectionView: UICollectionView
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var movies: [Movie] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        labelName.text = "MMOVIES"
        labelName.textColor = .myPinkSecond
        labelName.font = .systemFont(ofSize: 26, weight: .bold)
        labelName.textAlignment = .center
        labelName.backgroundColor = .clear
        view.addSubview(labelName)
        
        view.backgroundColor = .white
        // Настройка searchBackgroundView (новый закруглённый фон)
        searchBackgroundView.backgroundColor = .myPinkSecond
        searchBackgroundView.layer.cornerRadius = 22 // Немного больше, чем у контейнера, для эффекта
        searchBackgroundView.clipsToBounds = true
        view.addSubview(searchBackgroundView)
        
        // Настройка searchContainerView
        searchContainerView.backgroundColor = .myPinkOne
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        searchBackgroundView.addSubview(searchContainerView)
        
        // Настройка searchPrefixImageView
        searchPrefixImageView.contentMode = .scaleAspectFit
        searchPrefixImageView.image = UIImage(named: "prefixImage")
        searchContainerView.addSubview(searchPrefixImageView)
        
        // Настройка searchTextField
        searchTextField.placeholder = "Введите название фильма..."
        searchTextField.borderStyle = .none
        searchTextField.font = .systemFont(ofSize: 16)
        searchTextField.textColor = .black
        searchContainerView.addSubview(searchTextField)
        
        // Настройка leftSeparatorView
        leftSeparatorView.backgroundColor = .black
        searchContainerView.addSubview(leftSeparatorView)
        
        // Настройка rightSeparatorView
        rightSeparatorView.backgroundColor = .black
        searchContainerView.addSubview(rightSeparatorView)
        
        // Настройка searchButton (лупа)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        searchContainerView.addSubview(searchButton)
        
        collectionView.backgroundColor = .white
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        view.addSubview(emptyLabel)
        
        // Констрейнты
        labelName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        searchBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(labelName.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        searchContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        searchPrefixImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        leftSeparatorView.snp.makeConstraints { make in
            make.leading.equalTo(searchPrefixImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(30)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(leftSeparatorView.snp.trailing).offset(8)
            make.trailing.equalTo(rightSeparatorView.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        rightSeparatorView.snp.makeConstraints { make in
            make.trailing.equalTo(searchButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(30)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBackgroundView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func searchTapped() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        presenter.searchButtonTapped(with: query)
    }
}

extension SearchViewController: SearchViewProtocol {
    func showMovies(_ movies: [Movie]) {
        print("‼️ showMovies called. Movies count: \(movies.count)")
        movies.forEach { print("Movie title: \($0.title), poster: \($0.posterUrl ?? "nil")") }
        self.movies = movies
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        emptyLabel.isHidden = !movies.isEmpty
    }
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        activityIndicator.color = .myPinkSecond
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        let isFavorite = presenter?.isFavorite(id: movie.id) ?? false
        cell.configure(with: movie, isFavorite: isFavorite)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        presenter.didSelectMovie(movie)
    }
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 * 2
        let width = collectionView.frame.width - padding
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}

extension SearchViewController: MovieCellDelegate {
    func didTapFavorite(for movie: Movie) {
        presenter?.toggleFavorite(movie: movie)
        collectionView.reloadData()
    }
}
