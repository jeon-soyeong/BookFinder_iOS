//
//  BookListViewController.swift
//  BookFinder
//
//  Created by 전소영 on 2022/08/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class BookListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = BookListViewModel()

    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.searchTextField.layer.cornerRadius = 20
        $0.placeholder = "책 또는 저자를 검색해주세요📚"
    }

    private let searchResultCountLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .regular, size: 14)
        $0.textColor = .black
    }

    private let bookListCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 4
    }

    private lazy var bookListCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: bookListCollectionViewFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var loadingIndicatorView = LoadingIndicatorView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        $0.center = view.center
        $0.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupCollectionView()
        setupGestureRecognizer(to: bookListCollectionView)
        bindAction()
        bindViewModel()
    }

    private func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar

        setupSubViews()
        setupConstraints()
    }

    private func setupSubViews() {
        view.addSubviews([searchResultCountLabel, bookListCollectionView, loadingIndicatorView])
    }

    private func setupConstraints() {
        searchResultCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }

        bookListCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchResultCountLabel.snp.bottom).offset(10)
            $0.centerX.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func setupCollectionView() {
        bookListCollectionView.dataSource = self
        bookListCollectionView.delegate = self
        bookListCollectionView.registerCell(cellType: BookListCollectionViewCell.self)
    }

    private func setupGestureRecognizer(to view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer().then {
            $0.cancelsTouchesInView = false
            view.addGestureRecognizer($0)
        }

        tapGestureRecognizer.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
        .disposed(by: disposeBag)
    }

    private func bindAction() {
        searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] _ in
                self?.initialize()
                if let searchText = self?.searchBar.searchTextField.text {
                    self?.searchBar.resignFirstResponder()
                    self?.viewModel.action.didSearch.onNext((searchText))
                }
            }
            .disposed(by: self.disposeBag)

        searchBar.searchTextField.rx.text
            .orEmpty
            .filter { $0.isEmpty }
            .bind { [weak self] _ in
                self?.initialize()
                self?.hideSearchResultCountLabel()
            }
            .disposed(by: self.disposeBag)

        bookListCollectionView.rx.prefetchItems
            .compactMap(\.last?.item)
            .bind { [weak self] item in
                if let searchText = self?.searchBar.searchTextField.text,
                   let dataCount = self?.viewModel.bookItems.count,
                   item >= dataCount - 3 {
                    self?.viewModel.action.didSearch.onNext((searchText))
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.searchResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    guard let totalItemsCount = self?.viewModel.totalItemsCount else {
                        return
                    }
                    
                    if totalItemsCount == 0 {
                        self?.hideSearchResultCountLabel()
                        self?.showAlert(title: "📚 검색 결과 없음", message: "검색 결과가 없으므로 다른 키워드로 검색 바랍니다.")
                    } else {
                        self?.searchResultCountLabel.text = "📚 검색 결과: \(totalItemsCount)개"
                        self?.bookListCollectionView.reloadData()
                    }
                case .failure:
                    self?.hideSearchResultCountLabel()
                    self?.showAlert(title: "📚 검색 결과 불러올 수 없음", message: "검색 결과를 불러올 수 없으므로 재검색 바랍니다.")
                    self?.hideActivityIndicator()
                }
            })
            .disposed(by: disposeBag)

        viewModel.state.isRequesting
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isRequesting in
                if isRequesting {
                    self?.showActivityIndicator()
                } else {
                    self?.hideActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
    }

    private func initialize() {
        viewModel.initialize()
        searchResultCountLabel.isHidden = false
        bookListCollectionView.contentOffset = .zero
        bookListCollectionView.reloadData()
    }

    private func hideSearchResultCountLabel() {
        searchResultCountLabel.text = nil
        searchResultCountLabel.isHidden = true
    }

    private func showActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.startAnimation()
        }
    }

    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicatorView.isHidden = true
        }
    }
}

// MARK: UICollectionViewDataSource
extension BookListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bookItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCollectionViewCell", for: indexPath)
        let bookListCollectionViewCell = cell as? BookListCollectionViewCell
        guard indexPath.item < viewModel.bookItems.count else {
            return cell
        }
        bookListCollectionViewCell?.setupUI(data: viewModel.bookItems[indexPath.item])

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension BookListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.setupUI(data: viewModel.bookItems[indexPath.item])
        navigationController?.pushViewController(bookDetailViewController, animated: false)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension BookListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {       
        let titleSize = NSString(string: viewModel.bookItems[indexPath.row].volumeInfo.title).boundingRect(
                    with: CGSize(width: UIScreen.main.bounds.width - 120, height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
                    ],
                    context: nil)
        let authorSize = NSString(string: viewModel.bookItems[indexPath.row].volumeInfo.authors?.first ?? "").boundingRect(
                    with: CGSize(width: UIScreen.main.bounds.width - 120, height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
                    ],
                    context: nil)
        
        return CGSize(width: collectionView.frame.width, height: titleSize.height + authorSize.height + 70)
    }
}
