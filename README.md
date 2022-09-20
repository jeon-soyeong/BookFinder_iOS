# BookFinder
### Google book API를 이용해 사용자가 제목 또는 작가를 검색하여 결과 List를 표시하는 앱.
<br/>

## [Preview]
### [검색]
<img src="https://user-images.githubusercontent.com/61855905/191176804-032022ed-2c41-43fc-a8f1-c6c6458b9b69.gif" width="200" /> <img src="https://user-images.githubusercontent.com/61855905/191176797-9fcb59f6-0e66-4ec4-95a6-c98d62c614e8.gif" width="200" />
<br/> 
- 검색 기능 구현
- 검색 결과 없을시 Alert 알림 띄우기
- 페이지네이션 구현
- 커스텀 로딩뷰 구현
- Image Cache(memory / disk cache) 기능 구현, 모듈화 및 오픈소스 라이브러리 [Acorn](https://github.com/jeon-soyeong/Acorn) 배포
- 공통 네트워킹 모듈 구현
- MockURLSession, MockURLSessionDataTask, MockResponse을 통한 TestCode 작성<br/><br/>

## [Reference]
### Architecture
- MVVM

 ### UI
- SnapKit
- Then
- Acorn

 ### Reactive
- RxSwift
- RxCocoa
- RxRelay
