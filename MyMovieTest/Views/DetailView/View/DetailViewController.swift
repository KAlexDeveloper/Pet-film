//
//  DetailViewProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 21.08.2025.
//

import UIKit
import SnapKit


protocol DetailViewProtocol: AnyObject {
    func showMovieDetails(_ movie: Movie)
    func showError(_ message: String)
    func updatePoster(_ image: UIImage?)
}
final class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yearCountryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .myPinkSecond
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        startLoading()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        contentView.addArrangedSubview(posterImageView)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(yearCountryLabel)
        contentView.addArrangedSubview(ratingLabel)
        contentView.addArrangedSubview(genresLabel)
        contentView.addArrangedSubview(descriptionLabel)
        
        posterImageView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.width.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = .myPinkSecond
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func startLoading() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    @objc private func didTapBack() {
        presenter.didTapBack()
    }
}

extension DetailViewController: DetailViewProtocol {
    func showMovieDetails(_ movie: Movie) {
        titleLabel.text = movie.title
        yearCountryLabel.text = "Год: \(movie.releaseDate) "
        ratingLabel.text = "Рейтинг: KP: \(movie.rating?.kp ?? 0) | IMDb: \(movie.rating?.imdb ?? 0)"
        genresLabel.text = "Жанры: \(movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Нет жанров" )"
        descriptionLabel.text = movie.overview
    }
    
    func updatePoster(_ image: UIImage?) {
        if let image = image {
            posterImageView.image = image
            posterImageView.snp.remakeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(image.size.height * (contentView.frame.width / image.size.width))
            }
        } else {
            posterImageView.image = UIImage(systemName: "photo")
            posterImageView.tintColor = .myPinkOne
            posterImageView.snp.remakeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(300)
            }
        }
        stopLoading()
        view.layoutIfNeeded()
    }
    
    func showError(_ message: String) {
        stopLoading()
        presenter.showError(message)
    }
}
//динамический расчет высоты
//final class DetailViewController: UIViewController {
//    var presenter: DetailPresenterProtocol!
//
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        return scrollView
//    }()
//
//    private lazy var contentView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 12
//        stackView.alignment = .leading
//        return stackView
//    }()
//
//    private lazy var posterImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
//        return imageView
//    }()
//
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 22, weight: .bold)
//        label.textColor = .black
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private lazy var yearCountryLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.textColor = .darkGray
//        return label
//    }()
//
//    private lazy var ratingLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .semibold)
//        label.textColor = .systemYellow
//        return label
//    }()
//
//    private lazy var genresLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16)
//        label.textColor = .black
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private lazy var descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 15)
//        label.textColor = .darkGray
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private lazy var activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .large)
//        indicator.color = .myPinkSecond
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        setupNavigationBar()
//        startLoading()
//        presenter.viewDidLoad()
//    }
//
//    private func setupUI() {
//        // ScrollView + StackView
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
//
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//            $0.width.equalTo(scrollView.snp.width).offset(-32)
//        }
//
//        // Добавляем все субвью в contentView
//        contentView.addArrangedSubview(posterImageView)
//        contentView.addArrangedSubview(titleLabel)
//        contentView.addArrangedSubview(yearCountryLabel)
//        contentView.addArrangedSubview(ratingLabel)
//        contentView.addArrangedSubview(genresLabel)
//        contentView.addArrangedSubview(descriptionLabel)
//
//        // Устанавливаем начальные ограничения для posterImageView
//        posterImageView.snp.makeConstraints {
//            $0.height.equalTo(0)
//            $0.width.equalToSuperview()
//        }
//    }
//
//    private func setupNavigationBar() {
//        let backButton = UIBarButtonItem(title: "Назад",
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(didTapBack))
//        backButton.tintColor = .myPinkSecond
//        navigationItem.leftBarButtonItem = backButton
//    }
//
//    private func startLoading() {
//        view.addSubview(activityIndicator)
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        activityIndicator.startAnimating()
//    }
//
//    private func stopLoading() {
//        activityIndicator.stopAnimating()
//        activityIndicator.removeFromSuperview()
//    }
//
//    @objc private func didTapBack() {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//extension DetailViewController: DetailViewProtocol {
//    func showMovieDetails(_ movie: Movie) {
//        titleLabel.text = movie.title
//
//        let country = movie.countries?.first?.name ?? "Страна неизвестна"
//        yearCountryLabel.text = "\(movie.year ?? 0), \(country)"
//
//        let kp = movie.rating?.kp ?? 0
//        let imdb = movie.rating?.imdb ?? 0
//        ratingLabel.text = "⭐️ KP: \(kp) | IMDb: \(imdb)"
//
//        let genres = movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Нет жанров"
//        genresLabel.text = "Жанры: \(genres)"
//
//        descriptionLabel.text = movie.overview
//    }
//
//    func updatePoster(_ image: UIImage?) {
//        if let image = image {
//            let aspectRatio = image.size.width / image.size.height
//            let posterWidth = contentView.frame.width
//            let posterHeight = posterWidth / aspectRatio
//
//            posterImageView.image = image
//            posterImageView.snp.remakeConstraints {
//                $0.width.equalToSuperview()
//                $0.height.equalTo(posterHeight)
//            }
//        } else {
//            posterImageView.image = UIImage(systemName: "photo")
//            posterImageView.tintColor = .myPinkOne
//            posterImageView.snp.remakeConstraints {
//                $0.width.equalToSuperview()
//                $0.height.equalTo(300)
//            }
//        }
//        stopLoading()
//        view.layoutIfNeeded()
//    }
//
//    func showError(_ message: String) {
//        stopLoading()
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
//            self.didTapBack()
//        })
//
//        present(alert, animated: true)
//    }
//}

//final class DetailViewController: UIViewController {
//    var presenter: DetailPresenterProtocol!
//
//    private let scrollView = UIScrollView()
//    private let contentView = UIStackView()
//
//    private let posterImageView = UIImageView()
//    private let titleLabel = UILabel()
//    private let yearCountryLabel = UILabel()
//    private let ratingLabel = UILabel()
//    private let genresLabel = UILabel()
//    private let descriptionLabel = UILabel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        setupNavigationBar()
//        presenter.viewDidLoad()
//    }
//
//    private func setupUI() {
//        // ScrollView + StackView
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
//
//        scrollView.addSubview(contentView)
//        contentView.axis = .vertical
//        contentView.spacing = 12
//        contentView.alignment = .leading
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//            $0.width.equalTo(scrollView.snp.width).offset(-32)
//        }
//
//        // Постер
//        posterImageView.contentMode = .scaleAspectFit
//        posterImageView.clipsToBounds = true
//        posterImageView.layer.cornerRadius = 8
//        posterImageView.backgroundColor = .lightGray.withAlphaComponent(0.2)
//        contentView.addArrangedSubview(posterImageView)
//        posterImageView.snp.makeConstraints {
//            $0.height.equalTo(300)
//            $0.width.equalToSuperview()
//        }
//
//        // Название
//        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        titleLabel.textColor = .black
//        titleLabel.numberOfLines = 0
//        contentView.addArrangedSubview(titleLabel)
//
//        // Год + страна
//        yearCountryLabel.font = .systemFont(ofSize: 16, weight: .medium)
//        yearCountryLabel.textColor = .darkGray
//        contentView.addArrangedSubview(yearCountryLabel)
//
//        // Рейтинг
//        ratingLabel.font = .systemFont(ofSize: 16, weight: .semibold)
//        ratingLabel.textColor = .systemYellow
//        contentView.addArrangedSubview(ratingLabel)
//
//        // Жанры
//        genresLabel.font = .systemFont(ofSize: 16)
//        genresLabel.textColor = .black
//        genresLabel.numberOfLines = 0
//        contentView.addArrangedSubview(genresLabel)
//
//        // Описание
//        descriptionLabel.font = .systemFont(ofSize: 15)
//        descriptionLabel.textColor = .darkGray
//        descriptionLabel.numberOfLines = 0
//        contentView.addArrangedSubview(descriptionLabel)
//    }
//
//    private func setupNavigationBar() {
//        let backButton = UIBarButtonItem(title: "Назад",
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(didTapBack))
//        backButton.tintColor = .myPinkSecond
//        navigationItem.leftBarButtonItem = backButton
//    }
//
//    @objc private func didTapBack() {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//extension DetailViewController: DetailViewProtocol {
//    func showMovieDetails(_ movie: Movie) {
//        titleLabel.text = movie.title
//
//        let country = movie.countries?.first?.name ?? "Страна неизвестна"
//        yearCountryLabel.text = "\(movie.year ?? 0), \(country)"
//
//        let kp = movie.rating?.kp ?? 0
//        let imdb = movie.rating?.imdb ?? 0
//        ratingLabel.text = "⭐️ KP: \(kp) | IMDb: \(imdb)"
//
//        let genres = movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Нет жанров"
//        genresLabel.text = "Жанры: \(genres)"
//
//        descriptionLabel.text = movie.overview
//    }
//
//    func updatePoster(_ image: UIImage?) {
//        if let image = image {
//            posterImageView.image = image
//        } else {
//            posterImageView.image = UIImage(systemName: "photo")
//            posterImageView.tintColor = .myPinkOne
//        }
//    }
//
//    func showError(_ message: String) {
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
//            self.didTapBack()
//        })
//        present(alert, animated: true)
//    }
//}
