# Gasoline

`임금님귀는 당나귀귀처럼 시원하게 말하고 잊자!` 🦙

> 일정시간이 지나면 사라지는 글을 쓸 수 있는 커뮤니티 앱


<img src="https://github.com/user-attachments/assets/6d9b08c8-c40c-44cc-b2ad-df627ce83b0e" width="200"/>
<img src="https://github.com/user-attachments/assets/99c954d3-99eb-4cae-b96a-9068c338be62" width="200"/>
<img src="https://github.com/user-attachments/assets/7a3dcbca-4be4-4c6d-8b6f-2b4866607ff7" width="200"/>
<img src="https://github.com/user-attachments/assets/1f9a2b89-c67d-4b3d-a5ce-50e47149e80b" width="200"/>



## 프로젝트 주요 기능


- 커뮤니티에 글을 쓰면서 이미지 올리기
- 일정 시간이 지난 후 자동으로 게시물을 삭제해주는 기능
- 다른 사람이 올린 글에 좋아요 누르기 및 좋아요 취소
- 카드 결제 및 영수증 검증을 통한 실제 결제 기능

## 프로젝트 개발 환경

- **개발 인원**
    - iOS 개발자 1명
- **개발 기간**
    - oo.oo.oo ~ oo.oo.oo

## 프로젝트 기술 스택

- **활용 기술 및 키워드**
    - **iOS:** iOS 15.0+, Xcode 15.3, swift 5.0+
    - **Architecture:** MVVM
    - **Reactive:** RxSwift
    - **Network:** Alamofire
    - **UI:** CodeBaseUI, Snapkit
- **라이브러리**

| **라이브러리** | **사용 목적** | **Version** |
| --- | --- | --- |
| RxSwift | Observable Stream을 통한 반응형 프로그래밍 | 5.7.1 |
| SnapKit | CodeBaseUI 구현 | 6.8.0 |
| KingFisher | 이미지 데이터 비동기 다운로드 | 8.0.3 |

## 폴더 구조

```
LZLSLP
 ┣ Resources
 ┃ ┣ Assets.xcassets
 ┃ ┗ Lottie
 ┗ Sources
   ┣ App
   ┃ ┣ Base.lproj
   ┃ ┣ AppDelegate.swift
   ┃ ┣ Info.plist
   ┃ ┗ SceneDelegate.swift
   ┣ Domains
   ┣ Presenters
   ┃ ┣ Community
   ┃ ┣ Creator
   ┃ ┣ DetailPost
   ┃ ┣ Donation
   ┃ ┣ Launch
   ┃ ┣ Login
   ┃ ┣ Logo
   ┃ ┣ Payment
   ┃ ┣ Post
   ┃ ┣ Profile
   ┃ ┣ Signup
   ┃ ┣ TabBar
   ┃ ┗ Trending
   ┗ Utils
     ┣ Bases
     ┣ Constants
     ┣ Extensions
     ┣ Interceptor
     ┣ Keys
     ┣ Managers
     ┣ Models
     ┣ Protocols
     ┗ Routers
```

## 프로젝트 아키텍쳐

< 프로젝트 구조도 >

> MVVM + RxSwift
> 
- MVVM 디자인 패턴을 이용한 뷰 객체와 비즈니스 로직 역할 분리에 따른 <유지보수성 향상>
- RxSwift의 Observable Stream을 이용하여 비동기 이벤트에 대한 <선언형 코드 구현>
- BaseCode들의 상속을 통한 재사용성을 높히고 전체 코드량 줄임

> 싱글톤 + 레포지토리 패턴
> 
- 네트워크 통신 담당 객체를 싱글톤 객체로 구현하여 <메모리 절약>
- 싱글톤 네트워크 객체에서 데이터를 받아 변환하여 뷰모델로 넘겨주는 레포지토리를 구현하여 <코드량 및 사이드이펙트 감소>
