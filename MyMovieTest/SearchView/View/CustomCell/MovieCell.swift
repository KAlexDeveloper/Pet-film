//
//  MovieCell.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//


import UIKit
import SnapKit

//final class MovieCell: UICollectionViewCell {
//    private let posterImageView = UIImageView()
//    private let titleLabel = UILabel()
//
//    private var currentImageURL: URL?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .systemGray6
//        contentView.layer.cornerRadius = 10
//        contentView.layer.masksToBounds = true
//
//        contentView.addSubview(posterImageView)
//        contentView.addSubview(titleLabel)
//
//        posterImageView.contentMode = .scaleAspectFill
//        posterImageView.clipsToBounds = true
//
//        posterImageView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(400)
//        }
//
//        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .center
//
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(posterImageView.snp.bottom).offset(4)
//            make.leading.trailing.bottom.equalToSuperview().inset(4)
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        posterImageView.image = UIImage(systemName: "film")
//        currentImageURL = nil
//    }
//
//    func configure(with movie: Movie) {
//        titleLabel.text = movie.title
//
//        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
//            currentImageURL = url
//            posterImageView.image = UIImage(systemName: "film")
//
//            // Загружаем изображение асинхронно
//            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
//                guard let self = self,
//                      let data = data,
//                      let image = UIImage(data: data),
//                      self.currentImageURL == url else { return }
//
//                DispatchQueue.main.async {
//                    self.posterImageView.image = image
//                }
//            }.resume()
//        } else {
//            posterImageView.image = UIImage(systemName: "film")
//        }
//    }
//}
final class MovieCell: UICollectionViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let smallPosterImageView = UIImageView()

    private var currentImageURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        // Настройка smallPosterImageView (100x50)
        smallPosterImageView.contentMode = .scaleAspectFill
        smallPosterImageView.clipsToBounds = true
        contentView.addSubview(smallPosterImageView)

        // Настройка titleLabel
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)

        // Настройка overviewLabel
        overviewLabel.font = .systemFont(ofSize: 14, weight: .regular)
        overviewLabel.numberOfLines = 3
        overviewLabel.textAlignment = .left
        contentView.addSubview(overviewLabel)

        // Настройка releaseDateLabel
        releaseDateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        releaseDateLabel.textAlignment = .left
        contentView.addSubview(releaseDateLabel)

        // Auto Layout
        smallPosterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalTo(smallPosterImageView.snp.leading).offset(-8)
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        smallPosterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        releaseDateLabel.text = nil
        currentImageURL = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = movie.releaseDate

        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
            currentImageURL = url
            smallPosterImageView.image = UIImage(systemName: "film")

            // Загружаем изображение асинхронно
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data),
                      self.currentImageURL == url else { return }

                DispatchQueue.main.async {
                    self.smallPosterImageView.image = image
                }
            }.resume()
        } else {
            smallPosterImageView.image = UIImage(systemName: "film")
        }
    }
}
