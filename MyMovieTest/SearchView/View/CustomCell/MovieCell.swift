//
//  MovieCell.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit
import SnapKit

final class MovieCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearCountryLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewLabel = UILabel()
    
    private var currentImageURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        // Poster
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.backgroundColor = .systemGray5
        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        posterImageView.tintColor = .lightGray
        contentView.addSubview(posterImageView)
        
        // Title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        // Year & Country
        yearCountryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        yearCountryLabel.numberOfLines = 0
        yearCountryLabel.textAlignment = .left
        contentView.addSubview(yearCountryLabel)
        
        // Rating
        ratingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        ratingLabel.numberOfLines = 0
        ratingLabel.textAlignment = .left
        contentView.addSubview(ratingLabel)
        
        // Overview
        overviewLabel.font = .systemFont(ofSize: 14, weight: .regular)
        overviewLabel.numberOfLines = 0
        overviewLabel.textAlignment = .left
        overviewLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.addSubview(overviewLabel)
        
        // Layout
        posterImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalToSuperview()
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
        
        // Выравнивание и приоритеты
        titleLabel.textAlignment = .left
        yearCountryLabel.textAlignment = .left
        ratingLabel.textAlignment = .left
        overviewLabel.textAlignment = .left
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        yearCountryLabel.setContentHuggingPriority(.required, for: .vertical)
        ratingLabel.setContentHuggingPriority(.required, for: .vertical)
        overviewLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
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
        
        // Сброс размеров
        titleLabel.sizeToFit()
        yearCountryLabel.sizeToFit()
        ratingLabel.sizeToFit()
        overviewLabel.sizeToFit()
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        titleLabel.sizeToFit()
        
        let country = movie.countries?.first?.name ?? "Страна неизвестна"
        yearCountryLabel.text = "\(movie.releaseDate), \(country)"
        yearCountryLabel.sizeToFit()
        
        let imdbRating = movie.rating?.imdb ?? 0.0
        let kpRating = movie.rating?.kp ?? 0.0
        let averageRating = imdbRating > 0 ? imdbRating : kpRating > 0 ? kpRating : 0.0
        ratingLabel.text = averageRating > 0 ? "Оценка: \(String(format: "%.1f", averageRating))" : "Оценка отсутствует"
        ratingLabel.sizeToFit()
        
        if let desc = movie.description, !desc.isEmpty {
            overviewLabel.text = desc
        } else {
            overviewLabel.text = "Описание отсутствует"
        }
        overviewLabel.sizeToFit()
        overviewLabel.isHidden = false
        
        posterImageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        posterImageView.tintColor = .lightGray
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.backgroundColor = .systemGray5
        
        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
            currentImageURL = url
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data),
                      self.currentImageURL == url else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                    self.posterImageView.contentMode = .scaleAspectFill
                    self.posterImageView.layer.cornerRadius = 10
                    self.contentView.setNeedsLayout()
                    self.contentView.layoutIfNeeded()
                }
            }.resume()
        }
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
