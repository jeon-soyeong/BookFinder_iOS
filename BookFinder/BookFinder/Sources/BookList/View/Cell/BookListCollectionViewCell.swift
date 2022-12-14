//
//  BookListCollectionViewCell.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import UIKit

import RxSwift
import Acorn

final class BookListCollectionViewCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private let contentsLimitWidth = UIScreen.main.bounds.width - 120
    private var dataTask: URLSessionDataTask?
    
    private let bookCoverImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.addBorder(color: .lightGray, width: 0.5)
        $0.addShadow()
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 12)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }

    private let publishedDateLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 12)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private let lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bookCoverImageView.image = nil
        dataTask?.cancel()
        dataTask = nil
    }

    private func setupView() {
        self.addSubviews([bookCoverImageView, titleLabel, authorLabel, publishedDateLabel, lineView])
        setupConstraints()
    }

    private func setupConstraints() {
        bookCoverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(50)
            $0.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookCoverImageView.snp.top).offset(2)
            $0.leading.equalTo(bookCoverImageView.snp.trailing).offset(24)
            $0.width.equalTo(contentsLimitWidth)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(contentsLimitWidth)
        }

        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
            $0.leading.equalTo(authorLabel.snp.leading)
        }

        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(0.2)
        }
    }

    func setupUI(data: BookItem) {
        let thumbnailImage = data.volumeInfo.imageLinks?.thumbnail
        dataTask = bookCoverImageView.setImage(with: thumbnailImage, placeholder: UIImage(named: "defaultImage"))
        
        titleLabel.text = data.volumeInfo.title
        authorLabel.text = data.volumeInfo.authors?.first
        publishedDateLabel.text = data.volumeInfo.publishedDate
    }
}
