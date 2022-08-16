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
    
    private let bookCoverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 24)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .bold, size: 20)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let authorLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 18)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private let publishedDateLabel = UILabel().then {
        $0.font = UIFont.setFont(type: .medium, size: 18)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private let descriptionTextView = UITextView().then {
        $0.font = UIFont.setFont(type: .medium, size: 18)
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
            $0.height.equalTo(250)
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

    //FIXME: 실제 data param
    func setupUI() {
        bookCoverImageView.image = UIImage(named: "testImage")
        titleLabel.text = "나는 제목입니다."
        subTitleLabel.text = "나는 부제목입니다."
        authorLabel.text = "전소영"
        publishedDateLabel.text = "2022-08-16"
        descriptionTextView.text = "제 인생에 답이 없어요. 근데 괜찮아요. 질문은 있으니까요. 답 없는 현생을 은근슬쩍 타넘는 유튜버 선바의 만담집 게임을 하는 것이 죄악이던 어린 시절, 하루 종일 컴퓨터만 하는 사람이 되고 싶다는 소원을 품었던 아이는 마침내 소원을 이루었다. 그리고 생각했다. ‘소원을 빌 때는 신중해지자.’ 대학을 10년째 다니고 있는 학생이자 게임 스트리밍 전문 유튜버, 선바. 인터넷 방송과 유머에 대한 그만의 지론은 물론, 그간 그가 걱정인지 잔소리인지 저주인지 모를 이야기들을 들으며 터득한 인생 해법을 풀어놓는다. ‘인생을 잘 산다는 건 어떤 걸까?’부터 ‘철학과를 나왔을 때 취업 루트는?’, ‘개그를 쳤는데 남들이 웃지 않으면 어떡하지?’까지, 별의별 질문이 다 모였다. 그 질문에 유튜버 선바는 조금 이상해도 은근히 설득력 있는 지론을 펼친다. 때로 자조 섞인 후회와 때로 우스우면서도 슬픈 이야기들이 함께하고, 내 인생에 끼어드는 오지라퍼들에게는 보내는 날카로운 일갈도 속 시원히 튀어나온다. ‘인생이 적성이 아닌 사람들’을 위한 삶의 TMI와 꿀팁이 난무한다. 50만 구독자의 웃음을 책임지는 유튜버 선바의 만담 에세이!"
    }
}
