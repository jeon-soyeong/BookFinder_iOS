//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import UIKit
import RxSwift

final class BookDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentsLimitWidth = UIScreen.main.bounds.width - 48
    private let viewModel: BookDetailViewModel

    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .clear
    }

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
        $0.numberOfLines = 0
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 16)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
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
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.isEditable = false
        $0.addBorder(color: .lightGray, width: 0.5)
        $0.addShadow()
    }

    private let leftBarBackButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "back")
    }

    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUI(data: viewModel.bookItem)
        setupLeftBarBackButton()
        bindAction()
    }

    private func setupView() {
        view.backgroundColor = .white
        setNavigationBarTransparency()
        setupSubViews()
        setupConstraints()
    }

    private func setupSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([bookCoverImageView, titleLabel, subTitleLabel, authorLabel, publishedDateLabel, descriptionTextView])
        setupConstraints()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
        }

        bookCoverImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
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
            $0.width.equalTo(contentsLimitWidth)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
            $0.width.equalTo(contentsLimitWidth)
        }

        publishedDateLabel.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(12)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
        }

        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(publishedDateLabel.snp.bottom).offset(12)
            $0.leading.equalTo(bookCoverImageView.snp.leading)
            $0.width.equalToSuperview().inset(24)
            $0.height.equalTo(300)
            $0.bottom.equalToSuperview().inset(60)
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
        let thumbnailImage = data.volumeInfo.imageLinks?.thumbnail
        bookCoverImageView.setImage(with: thumbnailImage, placeholder: UIImage(named: "defaultImage"))
        
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
