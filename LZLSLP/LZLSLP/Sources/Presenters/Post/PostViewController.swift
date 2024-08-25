//
//  PostViewController.swift
//  LZLSLP
//
//  Created by user on 8/21/24.
//

import UIKit
import PhotosUI

import RxSwift

final class PostViewController: BaseViewController<PostView, PostViewModel> {
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        
        navigationItem.title = "Post View"
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        
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
                guard let imageData = image.pngData() else {
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
}

protocol Uploadable {
    var dataName: String { get }
    var data: Data { get }
}
struct ImageForm: Uploadable {
    let dataName: String
    let data: Data
}
