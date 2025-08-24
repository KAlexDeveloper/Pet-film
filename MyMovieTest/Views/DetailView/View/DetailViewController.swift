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

    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()

    private lazy var contentView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.alignment = .leading
        return v
    }()

    private lazy var posterImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill      // ← как у тебя
        v.clipsToBounds = true
        v.layer.cornerRadius = 8
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = .black
        l.numberOfLines = 0
        return l
    }()

    private lazy var yearCountryLabel: UILabel = {
        UILabel()
    }()

    private lazy var ratingLabel: UILabel = {
        UILabel()
    }()

    private lazy var genresLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()

    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.color = .myPinkSecond
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        startLoading()
        presenter.viewDidLoad()
    }

    // MARK: - Setup
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

        // начальная высота; потом updatePoster делает remakeConstraints по аспект-рейшу
        posterImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(300)
        }
    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(didTapBack))
        backButton.tintColor = .myPinkSecond
        navigationItem.leftBarButtonItem = backButton
    }

    // MARK: - Loading
    private func startLoading() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }

    private func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    // MARK: - Actions
    @objc private func didTapBack() {
        presenter.didTapBack()
    }
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func showMovieDetails(_ movie: Movie) {
        titleLabel.text = movie.title

        let country = movie.countries?.first?.name ?? "Страна неизвестна"
        yearCountryLabel.text = "\(movie.year ?? 0), \(country)"

        let kp = movie.rating?.kp ?? 0
        let imdb = movie.rating?.imdb ?? 0
        ratingLabel.text = "⭐️ KP: \(kp) | IMDb: \(imdb)"

        let genres = movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Нет жанров"
        genresLabel.text = "Жанры: \(genres)"

        descriptionLabel.text = movie.overview

        // если у фильма нет постера — сразу показать заглушку и остановить лоадер
        if movie.posterUrl == nil || movie.posterUrl?.isEmpty == true {
            updatePoster(nil)
        }
    }

    func updatePoster(_ image: UIImage?) {
        if let image = image {
            posterImageView.image = image
            // динамическая высота по аспект-рейшу, как у тебя
            let width = contentView.frame.width > 0 ? contentView.frame.width : view.frame.width - 32
            let aspectHeight = image.size.height * (width / image.size.width)

            posterImageView.snp.remakeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(aspectHeight)
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
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
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
//        
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private lazy var yearCountryLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    
//    private lazy var ratingLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    
//    private lazy var genresLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private lazy var descriptionLabel: UILabel = {
//        let label = UILabel()
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
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
//        
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//            $0.width.equalTo(scrollView.snp.width).offset(-32)
//        }
//        
//        contentView.addArrangedSubview(posterImageView)
//        contentView.addArrangedSubview(titleLabel)
//        contentView.addArrangedSubview(yearCountryLabel)
//        contentView.addArrangedSubview(ratingLabel)
//        contentView.addArrangedSubview(genresLabel)
//        contentView.addArrangedSubview(descriptionLabel)
//        
//        posterImageView.snp.makeConstraints {
//            $0.height.equalTo(0)
//            $0.width.equalToSuperview()
//        }
//    }
//    
//    private func setupNavigationBar() {
//        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(didTapBack))
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
//        presenter.didTapBack()
//    }
//}
//
//extension DetailViewController: DetailViewProtocol {
//    func showMovieDetails(_ movie: Movie) {
//        titleLabel.text = movie.title
//        yearCountryLabel.text = "Год: \(movie.releaseDate) "
//        ratingLabel.text = "Рейтинг: KP: \(movie.rating?.kp ?? 0) | IMDb: \(movie.rating?.imdb ?? 0)"
//        genresLabel.text = "Жанры: \(movie.genres?.map { $0.name }.joined(separator: ", ") ?? "Нет жанров" )"
//        descriptionLabel.text = movie.overview
//    }
//    
//    func updatePoster(_ image: UIImage?) {
//        if let image = image {
//            posterImageView.image = image
//            posterImageView.snp.remakeConstraints {
//                $0.width.equalToSuperview()
//                $0.height.equalTo(image.size.height * (contentView.frame.width / image.size.width))
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
//        presenter.showError(message)
//    }
//}
