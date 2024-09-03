//
//  PostViewController.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit
import PhotosUI

import RxCocoa
import RxSwift

final class PostViewController: BaseViewController<PostView, PostViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Post View"
    }
    
    override func configureBind() {
        super.configureBind()
        
        baseView.submitButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    baseView.titleTextField.rx.text.orEmpty,
                    baseView.contentView.rx.text.orEmpty)
            )
            .bind(with: self, onNext: { owner, value in
                let postForm = PostForm(title: value.0, content: value.1, files: [])
                owner.viewModel.store.postForm.accept(postForm)
                owner.viewModel.store.submitButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        baseView.imagePickerButton.rx.tap
            .bind(with: self) { owner, _ in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 5
                
                configuration.filter = .images
                
                let imagePicker = PHPickerViewController(configuration: configuration)
                imagePicker.delegate = owner
                
                owner.present(imagePicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.store.postUploadedCompleted
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.store.imageArray
            .share()
            .bind(to: baseView.imageCollectionView.rx.items(cellIdentifier: PostImageCell.identifier, cellType: PostImageCell.self)) {[weak self] row, imageForm, cell in
                
                guard let vc = self else { return }
                
                cell.imageView.image = UIImage(data: imageForm.data)
                
                cell.deleteButton.rx.tap
                    .share()
                    .bind(with: vc) { owner, _ in
                        print("\(row) 버튼 눌림")
                        owner.viewModel.store.deleteButtonTapped.onNext(row)
                    }
                    .disposed(by: vc.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
        viewModel.store.reloadCollectionView
            .bind(with: self) { owner, _ in
                owner.baseView.imageCollectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.imageCollectionView.register(PostImageCell.self, forCellWithReuseIdentifier: PostImageCell.identifier)
    }
}


extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] image, error in
                guard error ==  nil else {
                    print("Image 로딩 에러")
                    return
                }
                
                // image work
                guard let imageName = itemProvider.suggestedName, let image = image as? UIImage else { print("Error Converting")
                    return }
                guard let imageData = image.jpegData(compressionQuality: 0.80) else {
                    print("To Data failed")
                    return }
                
                let imageForm = ImageForm(dataName: imageName, data: imageData)
                self?.viewModel.store.selectedImageData.accept(imageForm)
            }
        }
        
        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
    }
}

struct PostForm {
    let title: String
    let content: String
    var files: [String]
    let product_id: String = "gasoline_post"
}

protocol Uploadable {
    var dataName: String { get }
    var data: Data { get }
}
struct ImageForm: Uploadable {
    let dataName: String
    let data: Data
}
