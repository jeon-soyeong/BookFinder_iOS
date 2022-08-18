//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import UIKit
import RxSwift

class BookDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentsLimitWidth = UIScreen.main.bounds.width - 48
    
    private let bookCoverImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.addBorder(color: .lightGray, width: 0.5)
        $0.addShadow()
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 18)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 16)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private let publishedDateLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 16)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private let descriptionTextView = UITextView().then {
        $0.font = UIFont.setFont(type: .medium, size: 16)
        $0.textColor = .black
        $0.textAlignment = .justified
        $0.showsVerticalScrollIndicator = false
        $0.addBorder(color: .lightGray, width: 0.5)
        $0.addShadow()
    }

    private let leftBarBackButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "back")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLeftBarBackButton()
        bindAction()
    }

    private func setupView() {
        view.backgroundColor = .white

        setupSubViews()
        setupConstraints()
    }

    private func setupSubViews() {
        view.addSubviews([bookCoverImageView, titleLabel, subTitleLabel, authorLabel, publishedDateLabel, descriptionTextView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        bookCoverImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bookCoverImageView.snp.bottom).offset(18)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
            $0.width.equalTo(contentsLimitWidth)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
        }

        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(12)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
        }

        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(publishedDateLabel.snp.bottom).offset(12)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
    }

    private func setupLeftBarBackButton() {
        navigationItem.leftBarButtonItem = leftBarBackButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    private func bindAction() {
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }

    func setupUI(data: BookItem) {
        if let thumbnailImage = data.volumeInfo.imageLinks?.thumbnail {
            bookCoverImageView.setImage(with: thumbnailImage, disposeBag: disposeBag)
        } else {
            bookCoverImageView.image = UIImage(named: "defaultImage")
        }
        titleLabel.text = data.volumeInfo.title
        subTitleLabel.text = data.volumeInfo.subtitle
        authorLabel.text = data.volumeInfo.authors?.first
        publishedDateLabel.text = data.volumeInfo.publishedDate
        guard let description = data.volumeInfo.description else {
            descriptionTextView.text = "소개 글 없음."
            return
        }
        descriptionTextView.text = description
    }
}
