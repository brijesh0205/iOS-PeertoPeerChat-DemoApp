//
//  PeersListViewController.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import UIKit

class PeersListViewController: UITableViewController {

    var peerList = [PeerUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MultipeerConnectionManager.shared.startBrowsing()
        MultipeerConnectionManager.shared.peerConnectDelegate = self
    }
    
    //MARK:- Private methods
    private func moveToChatScreen(peerObject: PeerUser) {
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
            chatVC.opponentPeer = peerObject
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}

extension PeersListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.peerList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyVisibilityTableCell") as! MyVisibilityTableCell
            cell.indexPath = indexPath
            cell.deledate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PeerNameTableViewCell") as! PeerNameTableViewCell
            cell.indexPath = indexPath
            cell.deledate = self
            
            cell.btnConnect.layer.masksToBounds = true
            cell.btnConnect.layer.cornerRadius = 5
            
            let displayName = peerList[indexPath.row].dispalyName
            cell.lblName.text = displayName
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else {
            return "PEER LIST"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension PeersListViewController: MyVisibilityTableCellDelegate {
    
    func didTapVisibilitySwitch(_ switchVisibility: UISwitch, indexPath: IndexPath?) {
        if switchVisibility.isOn {
            MultipeerConnectionManager.shared.startAdvertising()
            MultipeerConnectionManager.shared.startBrowsing()
        }
        else {
            MultipeerConnectionManager.shared.stopAdvertising()
            MultipeerConnectionManager.shared.stopBrowsing()
            self.peerList.removeAll()
            self.tableView.reloadData()
        }
    }
}

extension PeersListViewController: PeerNameTableViewCellDelegate {
    
    func didTapConnectButton(_ button: UIButton, indexPath: IndexPath?) {
        
        if let indexPath = indexPath {
             let id = peerList[indexPath.row].id
            MultipeerConnectionManager.shared.sendInvite(to: id) { (accepted, peerObject) in
                if accepted == true {
                    self.moveToChatScreen(peerObject: peerObject)
                }
            }
        }
    }
    
}

extension PeersListViewController: PeerConnectionDelegate {
    func didReceiveInvite(peerObject:PeerUser, accept: ((Bool)->Void)?) {
        UIAlertController.showAlertMessage("Connection Request", "You've received a connection request", ["Accept","Decline"], self) { (action) in
            if (action.title ?? "") == "Accept" {
                accept?(true)
                self.moveToChatScreen(peerObject: peerObject)
            }
            else {
                accept?(false)
            }
        }
    }
    
    func didUpdatePeerList(peerList: [PeerUser]) {
        self.peerList = peerList
        self.tableView.reloadData()
    }
}
