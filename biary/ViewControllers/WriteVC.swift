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
    @IBOutlet weak var contentTextView:UITextView!
    
    let toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        addToolBar(textView: contentTextView)
    }
    
    @objc func updateTextView(notification:Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        if notification.name == UIWindow.keyboardWillHideNotification {
            contentTextView.contentInset = UIEdgeInsets.zero
        } else {
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
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
        let undoBtn = UIBarButtonItem(customView: undoBtn_)
        
        let fixedSpaceBetweenBtns = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpaceBetweenBtns.width = 10
        
        let redoBtn_ = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        redoBtn_.setBackgroundImage(UIImage(named: "undo")?.withHorizontallyFlippedOrientation(), for: .normal)
        redoBtn_.addTarget(self, action: #selector(redoPressed), for: .touchUpInside)
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
        let redo = toolBar.items![4]
        if (contentTextView.undoManager?.canUndo == true) {
            undo.tintColor = UIColor(r: 85, g: 85, b: 85)
            //dark
        } else {
            undo.tintColor = UIColor(r: 188, g: 188, b: 188)
            //gray
        }
        
        if (contentTextView.undoManager?.canRedo == true) {
            redo.tintColor = UIColor(r: 85, g: 85, b: 85)
            //dark
        } else {
            redo.tintColor = UIColor(r: 188, g: 188, b: 188)
            //gray
        }
    }
    
    @objc func highlightPressed() {
        view.endEditing(true)
    }
    
    @objc func undoPressed(){
        contentTextView.undoManager?.undo()
    }
    @objc func redoPressed(){
        contentTextView.undoManager?.redo()
    }
    
}
