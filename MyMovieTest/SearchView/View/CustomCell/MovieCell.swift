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

    private var currentImageURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true

        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(systemName: "film")
        currentImageURL = nil
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title

        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
            currentImageURL = url
            posterImageView.image = UIImage(systemName: "film")

            // Загружаем изображение асинхронно
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data),
                      self.currentImageURL == url else { return }

                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }.resume()
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }
}
//final class MovieCell: UICollectionViewCell {
//    private let posterImageView = UIImageView()
//    private let titleLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .systemGray6
//        contentView.layer.cornerRadius = 8
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
//            make.height.equalTo(200)
//        }
//        
//        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .center
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(posterImageView.snp.bottom).offset(4)
//            make.leading.trailing.bottom.equalToSuperview().inset(4)
//        }
//    }
//    
//    required init?(coder: NSCoder) { fatalError() }
//    
//    func configure(with movie: Movie) {
//        titleLabel.text = movie.title
//        
//        if let posterUrl = movie.posterUrl, let url = URL(string: posterUrl) {
//            // Подключи Kingfisher или используй простую загрузку:
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.posterImageView.image = UIImage(data: data)
//                    }
//                }
//            }
//        } else {
//            posterImageView.image = UIImage(systemName: "film")
//        }
//    }
//}
