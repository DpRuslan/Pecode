//
//  ArticleCell.swift
//

import UIKit
import Kingfisher

protocol ArticleCellDelegate: AnyObject {
    func showAlert(completion: @escaping (() -> Void))
}

class ArticleCell: UITableViewCell {
    weak var delegate: ArticleCellDelegate?
    private var titleLabel = UILabel(frame: .zero)
    private var descriptionLabel = UILabel(frame: .zero)
    private var authorLabel = UILabel(frame: .zero)
    private var sourceLabel = UILabel(frame: .zero)
    private var newsImageView = UIImageView(frame: .zero)
    private var favoriteButton = UIButton(frame: .zero)
    
    var favoriteController = false
    
    private var articleData: ArticlesData?
    
    let storageService = StorageService()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(authorLabel)
        addSubview(sourceLabel)
        addSubview(newsImageView)
        addSubview(favoriteButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ArticleCell {
    private func setupUI() {
        contentView.isUserInteractionEnabled = true
        
        titleLabel.setStyle(text: nil, textColor: .black, font: UIFont.boldSystemFont(ofSize: 15))
        descriptionLabel.setStyle(text: nil, textColor: .black, font: UIFont.systemFont(ofSize: 13))
        authorLabel.setStyle(text: nil, textColor: .black, font: UIFont.systemFont(ofSize: 13))
        sourceLabel.setStyle(text: nil, textColor: .black, font: UIFont.systemFont(ofSize: 13))
        
        newsImageView.contentMode = .scaleAspectFit
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.addTarget(self, action: #selector(changeFavoritePressed(_:)), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ArticleCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -18),
            
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -18),
            
            sourceLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            sourceLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -18),
            
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            newsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 70),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1),
            
            favoriteButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor)
        ])
    }
}

extension ArticleCell {
    func configure(article: ArticlesData) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        authorLabel.text = article.author
        sourceLabel.text = article.sourceName
        favoriteButton.setImage(article.favoriteImage, for: .normal)
        articleData = article
        
        guard let urlToImage = article.urlToImage else {
            newsImageView.image = Model.placeholderImage
            return
        }
        
        if let imageUrl = URL(string: urlToImage) {
            newsImageView.kf.setImage(
                with: imageUrl,
                placeholder: Model.placeholderImage,
                options: [.transition(.fade(0.2))]
            )
        }
    }
}

extension ArticleCell {
    @objc private func changeFavoritePressed(_ sender: Any) {
        if favoriteButton.image(for: .normal) == Model.favoriteImage {
            delegate?.showAlert {
                if !self.favoriteController {
                    self.favoriteButton.setImage(self.favoriteButton.image(for: .normal) == Model.favoriteImage ? Model.unfavoriteImage : Model.favoriteImage, for: .normal)
                }
                self.storageService.deleteFromCoreData(articleId: self.articleData!.url!)
            }
        } else {
            storageService.saveToCoreData(article: articleData!)
            favoriteButton.setImage(favoriteButton.image(for: .normal) == Model.favoriteImage ? Model.unfavoriteImage : Model.favoriteImage, for: .normal)
        }
    }
}
