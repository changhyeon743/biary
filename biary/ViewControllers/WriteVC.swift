//
//  WriteVC.swift
//  biary
//
//  Created by 이창현 on 15/11/2018.
//  Copyright © 2018 이창현. All rights reserved.
//

import UIKit

class WriteVC: UIViewController {
    
    @IBOutlet weak var titleLbl:UILabel!
    let line = UIView()
    @IBOutlet weak var contentTextView:UITextView!
    
    let toolBar = UIToolbar()
    
    let backBtn = UIButton()
    let doneBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        setConstraints()
        
        contentTextView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        //TextView
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        addToolBar(textView: contentTextView)
    }
    
    func createViews() {
        backBtn.setImage(UIImage(named:"arrow_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        backBtn.tintColor = UIColor.mainColor
        
        doneBtn.setTitle("완료", for: .normal)
        doneBtn.setTitleColor(UIColor.mainColor, for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        doneBtn.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        
        line.backgroundColor = UIColor(r: 112, g: 112, b: 112)
        
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
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            doneBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            doneBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            titleLbl.topAnchor.constraint(equalTo: doneBtn.bottomAnchor, constant: 25),
            titleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            titleLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 26),
            titleLbl.heightAnchor.constraint(equalToConstant: 28),
            
            line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26),
            line.heightAnchor.constraint(equalToConstant: 2),
            line.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2.5),
            
            contentTextView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 13.5),
            contentTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            contentTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -26),
            contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 26)

        ])
    }
    
    @objc func back(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done(_ button: UIButton) {
        view.endEditing(true)
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
    func addToolBar(textView: UITextView){
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let highLightBtn = UIBarButtonItem(image: UIImage(named:"highlight"), style: .plain, target: self, action: #selector(highlightPressed))
        
        
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
        redoBtn_.tintColor = UIColor(r: 85, g: 85, b: 85)
        
        
        let redoBtn = UIBarButtonItem(customView: redoBtn_)
        
        
        
        toolBar.setItems([highLightBtn,space,undoBtn,fixedSpaceBetweenBtns,redoBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        
        updateUndoBtns()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateUndoBtns()
    }
    
    func updateUndoBtns() {
        let undo = toolBar.items![2]
        undo.isEnabled = contentTextView.undoManager?.canUndo ?? false;
        let redo = toolBar.items![4]
        redo.isEnabled = contentTextView.undoManager?.canRedo ?? false;
//        if ( == true) {
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
        
        print("changed")
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
