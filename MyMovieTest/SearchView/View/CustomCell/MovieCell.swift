//
//  MovieCell.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit
import SnapKit

//final class MovieCell: UICollectionViewCell {
//    
//    private let posterImageView = UIImageView()
//    private let titleLabel = UILabel()
//    private let yearCountryLabel = UILabel()
//    private let ratingLabel = UILabel()
//    private let overviewLabel = UILabel()
//    private let favoriteButton = UIButton(type: .system)
//    
//    private var currentImageURL: URL?
//    private var isFavorite: Bool = false {
//        didSet {
//            let imageName = isFavorite ? "heart.fill" : "heart"
//            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
//            favoriteButton.tintColor = isFavorite ? .myPinkSecond : .lightGray
//        }
//    }
//    
//    static let imageCache = NSCache<NSURL, UIImage>()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .systemGray6
//        contentView.layer.cornerRadius = 10
//        contentView.layer.masksToBounds = true
//        
//        posterImageView.contentMode = .scaleAspectFit
//        posterImageView.clipsToBounds = true
//        posterImageView.layer.cornerRadius = 10
//        posterImageView.backgroundColor = .systemGray5
//        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
//        posterImageView.tintColor = .lightGray
//        contentView.addSubview(posterImageView)
//        
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(yearCountryLabel)
//        contentView.addSubview(ratingLabel)
//        contentView.addSubview(overviewLabel)
//        contentView.addSubview(favoriteButton)
//        
//        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        titleLabel.numberOfLines = 0
//        titleLabel.textAlignment = .left
//        
//        yearCountryLabel.font = .systemFont(ofSize: 14, weight: .medium)
//        yearCountryLabel.numberOfLines = 0
//        yearCountryLabel.textAlignment = .left
//        
//        ratingLabel.font = .systemFont(ofSize: 14, weight: .medium)
//        ratingLabel.numberOfLines = 0
//        ratingLabel.textAlignment = .left
//        
//        overviewLabel.font = .systemFont(ofSize: 14, weight: .regular)
//        overviewLabel.numberOfLines = 0
//        overviewLabel.textAlignment = .left
//        overviewLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
//        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        
//        posterImageView.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(2.0 / 5.0)
//        }
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
//            make.trailing.equalToSuperview().offset(-8)
//        }
//        
//        yearCountryLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(4)
//            make.leading.trailing.equalTo(titleLabel)
//        }
//        
//        ratingLabel.snp.makeConstraints { make in
//            make.top.equalTo(yearCountryLabel.snp.bottom).offset(4)
//            make.leading.trailing.equalTo(titleLabel)
//        }
//        
//        overviewLabel.snp.makeConstraints { make in
//            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
//            make.leading.trailing.equalTo(titleLabel)
//            make.bottom.equalToSuperview().offset(-8)
//        }
//        
//        favoriteButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.trailing.equalToSuperview().offset(-8)
//            make.width.height.equalTo(24)
//        }
//        
//        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
//        
//        titleLabel.setContentHuggingPriority(.required, for: .vertical)
//        yearCountryLabel.setContentHuggingPriority(.required, for: .vertical)
//        ratingLabel.setContentHuggingPriority(.required, for: .vertical)
//        overviewLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
//        posterImageView.tintColor = .lightGray
//        posterImageView.backgroundColor = .systemGray5
//        titleLabel.text = nil
//        yearCountryLabel.text = nil
//        ratingLabel.text = nil
//        overviewLabel.text = nil
//        overviewLabel.isHidden = false
//        currentImageURL = nil
//        isFavorite = false
//        
//        titleLabel.sizeToFit()
//        yearCountryLabel.sizeToFit()
//        ratingLabel.sizeToFit()
//        overviewLabel.sizeToFit()
//    }
//    
//    func configure(with movie: Movie, isFavorite: Bool = false) {
//        self.isFavorite = isFavorite
//        titleLabel.text = movie.title
//        titleLabel.sizeToFit()
//        
//        let country = movie.countries?.first?.name ?? "Страна неизвестна"
//        yearCountryLabel.text = "\(movie.releaseDate), \(country)"
//        yearCountryLabel.sizeToFit()
//        
//        let imdbRating = movie.rating?.imdb ?? 0.0
//        let kpRating = movie.rating?.kp ?? 0.0
//        let averageRating = imdbRating > 0 ? imdbRating : kpRating > 0 ? kpRating : 0.0
//        ratingLabel.text = averageRating > 0 ? "Оценка: \(String(format: "%.1f", averageRating))" : "Оценка отсутствует"
//        ratingLabel.sizeToFit()
//        
//        if let desc = movie.description, !desc.isEmpty {
//            overviewLabel.text = desc
//        } else {
//            overviewLabel.text = "Описание отсутствует"
//        }
//        overviewLabel.sizeToFit()
//        overviewLabel.isHidden = false
//        
//        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
//        posterImageView.tintColor = .lightGray
//        posterImageView.contentMode = .scaleAspectFit
//        posterImageView.backgroundColor = .systemGray5
//        
//        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
//            currentImageURL = url
//            
//            if let cachedImage = MovieCell.imageCache.object(forKey: url as NSURL) {
//                posterImageView.image = cachedImage
//                posterImageView.contentMode = .scaleAspectFill
//                posterImageView.layer.cornerRadius = 10
//                return
//            }
//            
//            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
//                guard let self = self,
//                      let data = data,
//                      let image = UIImage(data: data),
//                      self.currentImageURL == url else { return }
//                
//                MovieCell.imageCache.setObject(image, forKey: url as NSURL)
//                
//                DispatchQueue.main.async {
//                    self.posterImageView.image = image
//                    self.posterImageView.contentMode = .scaleAspectFill
//                    self.posterImageView.layer.cornerRadius = 10
//                    self.contentView.setNeedsLayout()
//                    self.contentView.layoutIfNeeded()
//                }
//            }.resume()
//        }
//        contentView.setNeedsLayout()
//        contentView.layoutIfNeeded()
//    }
//    
//    @objc private func favoriteTapped() {
//        isFavorite.toggle()
//        // 💬 В будущем сюда добавим логику сохранения в хранилище.
//    }
//}
import UIKit
import SnapKit

protocol MovieCellDelegate: AnyObject {
    func didTapFavorite(for movie: Movie)
}

final class MovieCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearCountryLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var currentImageURL: URL?
    private var movie: Movie?
    
    weak var delegate: MovieCellDelegate?

    private var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
            favoriteButton.tintColor = isFavorite ? .myPinkSecond : .lightGray
        }
    }
    
    static let imageCache = NSCache<NSURL, UIImage>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        posterImageView.tintColor = .lightGray
        posterImageView.backgroundColor = .systemGray5
        titleLabel.text = nil
        yearCountryLabel.text = nil
        ratingLabel.text = nil
        overviewLabel.text = nil
        overviewLabel.isHidden = false
        currentImageURL = nil
        isFavorite = false
        movie = nil
    }

    func configure(with movie: Movie, isFavorite: Bool = false) {
        self.movie = movie
        self.isFavorite = isFavorite

        titleLabel.text = movie.title

        let country = movie.countries?.first?.name ?? "Страна неизвестна"
        yearCountryLabel.text = "\(movie.releaseDate), \(country)"
        
        let imdbRating = movie.rating?.imdb ?? 0.0
        let kpRating = movie.rating?.kp ?? 0.0
        let averageRating = imdbRating > 0 ? imdbRating : kpRating > 0 ? kpRating : 0.0
        ratingLabel.text = averageRating > 0 ? "Оценка: \(String(format: "%.1f", averageRating))" : "Оценка отсутствует"
        
        overviewLabel.text = movie.description?.isEmpty == false ? movie.description : "Описание отсутствует"
        overviewLabel.isHidden = false

        configurePoster(from: movie.posterUrl)
    }

    private func configurePoster(from urlString: String?) {
        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        posterImageView.tintColor = .lightGray
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.backgroundColor = .systemGray5
        
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        currentImageURL = url

        if let cachedImage = MovieCell.imageCache.object(forKey: url as NSURL) {
            posterImageView.image = cachedImage
            posterImageView.contentMode = .scaleAspectFill
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  self.currentImageURL == url else { return }
            
            MovieCell.imageCache.setObject(image, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                self.posterImageView.image = image
                self.posterImageView.contentMode = .scaleAspectFill
                self.contentView.setNeedsLayout()
                self.contentView.layoutIfNeeded()
            }
        }.resume()
    }

    @objc private func favoriteTapped() {
        guard let movie = movie else { return }
        delegate?.didTapFavorite(for: movie)
    }

    // MARK: - Setup Methods

    private func setupUI() {
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.backgroundColor = .systemGray5

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0

        yearCountryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        yearCountryLabel.numberOfLines = 0

        ratingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        ratingLabel.numberOfLines = 0

        overviewLabel.font = .systemFont(ofSize: 14, weight: .regular)
        overviewLabel.numberOfLines = 0
        overviewLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        favoriteButton.tintColor = .lightGray
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearCountryLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(favoriteButton)
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(2.0 / 5.0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        yearCountryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(yearCountryLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-8)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
    }

    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
    }
}
