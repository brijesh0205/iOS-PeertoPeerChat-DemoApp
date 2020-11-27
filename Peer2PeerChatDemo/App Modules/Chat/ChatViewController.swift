//
//  ChatViewController.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var bottomConstraintToolbar: NSLayoutConstraint!
    
    var arrayMessage = [Message]()
    
    var opponentPeer:PeerUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        MultipeerConnectionManager.shared.peerMessageDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    //MARK:- Private Methods
    private func setUpView() {

        txtViewMessage.layer.masksToBounds = true
        txtViewMessage.layer.cornerRadius = 20
        txtViewMessage.layer.borderWidth = 0.5
        txtViewMessage.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        self.title = opponentPeer?.dispalyName
        
        self.navigationItem.hidesBackButton = true
        
        let rightBarButton = UIBarButtonItem.init(title: "Exit", style: .plain, target: self, action: #selector(tapExit))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func moveToTop() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            if self.tblChat.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath.init(row: self.tblChat.numberOfRows(inSection: 0)-1, section: 0)
                self.tblChat.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func tapSend(_ sender: Any) {
        
        guard let message = txtViewMessage.text, message.isEmpty == false, let opponentPeer = self.opponentPeer else {
            UIAlertController.showAlertMessage("Alert", "Please type a message", self)
            return
        }
        
        if !txtViewMessage.text.isEmpty {
            
            MultipeerConnectionManager.shared.sendMessage(messgae: message, peer: opponentPeer)
            let msgObj = Message.init(message: message, isSender: true)

            arrayMessage.append(msgObj)
            tblChat.reloadData()
            txtViewMessage.text = ""
            self.moveToTop()
        }
    }
    
    @objc func tapExit() {
        
        UIAlertController.showAlertMessage("Exit?", "Are you sure you want to exit?", ["OK", "Cancel"], self) { (action) in
            if (action.title ?? "") == "OK" {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    //MARK:- Observers Actions
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraintToolbar.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraintToolbar.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraintToolbar.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msgObj = arrayMessage[indexPath.row]
        if msgObj.isSender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatTableCell") as! RightChatTableCell
            let chatBuubleImage = cell.imgChatBubble?.image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), resizingMode: UIImage.ResizingMode.stretch)
            cell.imgChatBubble?.image = chatBuubleImage
            
            cell.lblMessage.text = msgObj.message

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatTableCell") as! LeftChatTableCell
            let chatBuubleImage = cell.imgChatBubble?.image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20), resizingMode: UIImage.ResizingMode.stretch)
            cell.imgChatBubble?.image = chatBuubleImage
            
            cell.lblMessage.text = msgObj.message
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension ChatViewController: PeerMessageDelegate {
    func didReceiveMessage(message: Message) {
        arrayMessage.append(message)
        tblChat.reloadData()
        self.moveToTop()
    }
}
