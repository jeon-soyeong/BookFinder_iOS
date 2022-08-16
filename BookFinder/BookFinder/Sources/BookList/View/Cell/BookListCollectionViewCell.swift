//
//  BookListCollectionViewCell.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import UIKit

class BookListCollectionViewCell: UICollectionViewCell {
    private let bookCoverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.addBorder(color: .lightGray, width: 0.5)
        $0.addShadow()
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let authorLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 12)
        $0.textColor = .darkGray
        $0.textAlignment = .center
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

    private func setupView() {
        self.addSubviews([bookCoverImageView, titleLabel, authorLabel, publishedDateLabel, lineView])
        setupConstraints()
    }

    private func setupConstraints() {
        bookCoverImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.width.equalTo(50)
            $0.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookCoverImageView.snp.top).offset(2)
            $0.leading.equalTo(bookCoverImageView.snp.trailing).offset(24)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top).offset(36)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.top).offset(18)
            $0.leading.equalTo(authorLabel.snp.leading)
        }
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(0.2)
        }
    }

    //FIXME: 실제 data param
    func setupUI() {
        bookCoverImageView.image = UIImage(named: "testImage")
        titleLabel.text = "나는 제목입니다."
        authorLabel.text = "전소영"
        publishedDateLabel.text = "2022-08-16"
    }
}
