//
//  HomeViewController.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnGetStarted: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    //MARK:- Button Actions
    private func setUpView() {
        self.btnGetStarted.layer.masksToBounds = true
        self.btnGetStarted.layer.cornerRadius = 8
    }
    
    private func moveToPeerListScreen() {
        if let peerList = self.storyboard?.instantiateViewController(withIdentifier: "PeersListViewController") as? PeersListViewController {
            self.navigationController?.pushViewController(peerList, animated: true)
        }
    }
    
    //MARK:- Button Actions
    @IBAction func tapGetStarted(_ sender: Any) {
        guard let name = txtName.text, name.isEmpty == false else {
            UIAlertController.showAlertMessage("Alert", "Please enter a name/phone number", self)
            return
        }
        MultipeerConnectionManager.shared.createSession(withName: name)
        MultipeerConnectionManager.shared.startAdvertising()
        moveToPeerListScreen()
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

