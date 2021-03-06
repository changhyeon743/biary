//
//  WriteVC.swift
//  biary
//
//  Created by 이창현 on 15/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON
import UITextView_Placeholder
import ActionSheetPicker_3_0
import Photos
import CropViewController
import AMPopTip

class WriteVC: UIViewController {
    var detailDelegate: BookDetailDelegate?
    let pop = PopTip()

    
    @IBOutlet weak var titleLbl:SpringLabel!
    let line = UIView()
    @IBOutlet weak var contentTextView:SpringTextView!
    
    let toolBar = UIToolbar()
    
    let backBtn = UIButton()
    let doneBtn = UIButton()
    
    var bookInfo:Book!
    var contentInfo:Content?
    
    var firstText: String = ""
    
    var percent : Double = 0
    
    var indicator : IndicatorView?
    var keyboard : CGRect?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(titlePressed(_:)))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(gesture)
        
        contentTextView.becomeFirstResponder()
        line.isHidden = true
        createViews()
        setConstraints()
        setContent()
        contentTextView.placeholder = "책에 대한 생각을 들려주세요!".localized
        contentTextView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        //TextView
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        addToolBar(textView: contentTextView)
        
        indicator = IndicatorView(uiView: self.view)
    }
    
    
    
    @objc func titlePressed(_ sender: Any) {
        let questionList = ["페이지".localized,"책의 시작".localized,"생각".localized,"좋은 점".localized,"나쁜 점".localized,"문장".localized,"직접 입력".localized]
        var initialSelection = questionList.index(of: self.titleLbl.text ?? "")
        if initialSelection == nil {
            initialSelection = 0
        }
        
        
        if let action = ActionSheetStringPicker(title: "글 제목 선택".localized, rows: questionList
            , initialSelection: initialSelection!, doneBlock: {
                picker, indexes, values in
                
                
                let selectedText = values! as! String
                
                if (selectedText == "직접 입력".localized || selectedText == "페이지".localized) {
                    let alert = UIAlertController(title: "입력".localized, message: nil, preferredStyle: .alert)
                    let backAction = UIAlertAction(title: "취소".localized, style: .default)
                    let okAction = UIAlertAction(title: "확인".localized, style: .default) { (alertAction) in
                        let textField = alert.textFields![0] as UITextField
                        
                        self.titleLbl.text = textField.text!
                        if (selectedText == "페이지".localized) {
                            self.titleLbl.text = textField.text!+" P."
                        }
                    }
                    
                    alert.addTextField { (textField) in
                        textField.text = ""
                        textField.placeholder = "제목을 직접 입력해주세요".localized
                        if (selectedText == "페이지".localized) {
                            textField.keyboardType = .numberPad
                            textField.placeholder = "페이지를 직접 입력해주세요".localized
                        }
                    }
                    
                    alert.addAction(backAction)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated:true, completion: nil)
                    return
                }
                
                self.titleLbl.text = selectedText
                return
        }, cancel: { ActionStringCancelBlock in return }, origin: titleLbl) {
            
            action.toolbarButtonsColor = UIColor.mainColor
            action.show()
        }
    }
    
    func setContent() {
        if (contentInfo != nil) {
            contentTextView.text = contentInfo?.article
            titleLbl.text = contentInfo?.title
            firstText = contentTextView.text
        }
    }
    
    func createViews() {
        
        backBtn.setImage(UIImage(named:"close"), for: .normal)
        backBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        backBtn.tintColor = UIColor(r: 90, g: 90, b: 90)
        
        doneBtn.setTitle("완료".localized, for: .normal)
        
        doneBtn.setTitleColor(UIColor.mainColor, for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15,weight: .bold)//UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        
        doneBtn.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        
        line.backgroundColor = UIColor(r: 90, g: 90, b: 90, alpha: 1)
        
        view.addSubview(line)
        view.addSubview(backBtn)
        view.addSubview(doneBtn)
    }
    
    func setConstraints() {
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            doneBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            doneBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            titleLbl.topAnchor.constraint(equalTo: doneBtn.bottomAnchor, constant: 18),
            titleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            titleLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 26),
            titleLbl.heightAnchor.constraint(equalToConstant: 28),
            
            line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 7),
            
            contentTextView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 4),
            contentTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22),
            contentTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22),
            contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 26)

        ])
    }
    
    
    @objc func back(_ button: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        if (firstText != contentTextView.text) {
            let alert = UIAlertController(title: "닫기".localized, message: "완료를 눌러 저장하지 않으면 작성한 내용은 사라집니다.".localized, preferredStyle: .actionSheet)
            alert.popoverPresentationController?.sourceView = button
            alert.addAction(UIAlertAction(title: "계속 쓰기".localized, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "나가기".localized, style: .destructive, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func done(_ button: UIButton) {
        if (contentTextView.isFirstResponder) {
            
            view.endEditing(true)
            contentTextView.setNeedsDisplay()
            
        } else {
//            guard let title = titleLbl.text, !title.isEmpty else {
//                self.titleLbl.animation = "shake"
//                self.titleLbl.force = 0.5
//                self.titleLbl.animate()
//                return
//            }
            
            
            save()

            
            self.dismiss(animated: true) {
                print("2:" ,API.currentContents.count)
                self.detailDelegate?.reloadOnce()
                
                self.detailDelegate?.scrollToLast()
                
            }
            
            //self.navigationController?.popViewController(animated: true)
        }
    }
    
    func save() {
        guard let title = titleLbl.text, !title.isEmpty else { return }
        guard let content = contentTextView.text, !content.isEmpty else { return }
        if (contentInfo == nil) { //새로 생성 중
            Content.append(title: title, article: content, token: bookInfo.token)
        } else {
            Content.edit(title: title, article: content, bookToken: bookInfo.token, contentToken: contentInfo!.token)
        }
        API.user.update { (json) in
            //print("server send",json)
            if (json["status"].intValue != 200) {
                let action = UIAlertController(title: "앗! 서버와 통신 중에 문제가 발생했습니다!".localized, message: nil, preferredStyle: .alert)
                
                action.addAction(UIAlertAction(title: "확인".localized, style: .default, handler: nil))
                
                self.present(action, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //save()
    }
    
    @objc func updateTextView(notification:Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        let offset:CGFloat = 48
        
        if notification.name == UIWindow.keyboardWillHideNotification {
            contentTextView.contentInset = UIEdgeInsets.zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height + offset, right: 0)
            contentTextView.scrollIndicatorInsets = contentTextView.contentInset
        }
        
        contentTextView.scrollRangeToVisible(contentTextView.selectedRange)
    }
    
    
}

extension WriteVC : UITextViewDelegate {
    func addToolBar(textView: UITextView) {
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let highLightBtn = UIBarButtonItem(image: UIImage(named:"highlight"), style: .plain, target: self, action: #selector(highlightPressed))
        
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: #selector(cameraBtnPressed))
        cameraBtn.tintColor = UIColor.mainColor
        
        
        
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let undoBtn_ = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        undoBtn_.setBackgroundImage(UIImage(named: "undo"), for: .normal)
        undoBtn_.addTarget(self, action: #selector(undoPressed), for: .touchUpInside)
        undoBtn_.tintColor = UIColor(r: 85, g: 85, b: 85)
        let undoBtn = UIBarButtonItem(customView: undoBtn_)
        
        let fixedSpaceBetweenBtns = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpaceBetweenBtns.width = 10
        
        let redoBtn_ = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        redoBtn_.setBackgroundImage(UIImage(named: "undo")?.withHorizontallyFlippedOrientation(), for: .normal)
        redoBtn_.addTarget(self, action: #selector(redoPressed), for: .touchUpInside)
        redoBtn_.tintColor = UIColor(r: 85, g: 85, b: 85) //gray
        
        
        let redoBtn = UIBarButtonItem(customView: redoBtn_)
        
        
        
        toolBar.setItems([cameraBtn,highLightBtn,space,undoBtn,fixedSpaceBetweenBtns,redoBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        guard let item = toolBar.items?[0] else { return }
        print(item.accessibilityFrame)
//        pop.show(text: "책 속의 글을 텍스트로 변환합니다.", direction: .up, to: self.view, from: item.accessibilityFrame)
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        
        updateUndoBtns()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoBtns()
    }
    
    
    
    func updateUndoBtns() {
        let undo = toolBar.items![3]
        undo.isEnabled = contentTextView.undoManager?.canUndo ?? false;
        let redo = toolBar.items![5]
        redo.isEnabled = contentTextView.undoManager?.canRedo ?? false;
//        if (contentTextView.undoManager?.canUndo == true) {
//            undo.customView?.tintColor = UIColor(r: 85, g: 85, b: 85)
//            //dark
//        } else {
//            undo.customView?.tintColor = UIColor(r: 188, g: 188, b: 188)
//            //gray
//        }
//
//        if (contentTextView.undoManager?.canRedo == true) {
//            redo.customView?.tintColor = UIColor(r: 85, g: 85, b: 85)
//            //dark
//        } else {
//            redo.customView?.tintColor = UIColor(r: 188, g: 188, b: 188)
//            //gray
//        }
        
//        print("changed")
    }
    
    @objc func highlightPressed() {
        view.endEditing(true)
    }
    
    @objc func undoPressed(){
        contentTextView.undoManager?.undo()
        updateUndoBtns()
    }
    @objc func redoPressed(){
        contentTextView.undoManager?.redo()
        updateUndoBtns()
    }
    
}

//IMAGE TO TEXT
extension WriteVC: UIImagePickerControllerDelegate, CropViewControllerDelegate, UINavigationControllerDelegate {
    @objc func cameraBtnPressed() {
        self.contentTextView.resignFirstResponder()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.contentTextView.becomeFirstResponder()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.contentTextView.becomeFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("picked")
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("failed while loading image")
            return
        }
        
        //present(cropViewController, animated: true, completion: nil)
        picker.dismiss(animated: true) {
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            
            self.topMostController().present(cropViewController, animated: true, completion: nil)
        }
        
        
        
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("image~Start")
        imageToText(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
        self.contentTextView.becomeFirstResponder()

    }
    
    func imageToText(image: UIImage) {
        indicator?.start()
        contentTextView.resignFirstResponder()
        API.imageToText.run(image: image, completion: { (json) in
            let text = json["text"].stringValue
            if (text.contains("\n")) {
                self.pop.tapHandler = { _ in
                    self.contentTextView.text = String(self.contentTextView.text.filter { !"\n".contains($0) })
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.pop.shouldDismissOnTap = true
                    self.pop.bubbleColor = UIColor.mainColor
                    self.pop.padding = 10
                    self.pop.offset = 10
                    self.pop.shouldDismissOnTapOutside = true
                    
                    guard let camera = self.keyboard else {return}
                    self.pop.show(text: "줄바꿈을 모두 사라지게 만들까요?", direction: .up, maxWidth: 200, in: self.view, from: camera)
                }
                
            }
            self.contentTextView.insertText(text)
            self.toolBar.items![5].tintColor = UIColor.mainColor
            self.indicator?.stop()
        }) { (progress) in
            self.percent = progress
            
            //self.indicator?.updateTextView(text: String(describing: floor(progress*100)/100) + " %")
        }
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboard = keyboardRect
        }
        
    }
}
