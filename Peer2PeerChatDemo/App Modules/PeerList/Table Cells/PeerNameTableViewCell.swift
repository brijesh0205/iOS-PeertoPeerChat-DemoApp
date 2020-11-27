//
//  PeerNameTableViewCell.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import UIKit

protocol PeerNameTableViewCellDelegate: class {
    func didTapConnectButton(_ button: UIButton, indexPath: IndexPath?)
}

class PeerNameTableViewCell: UITableViewCell {
    var indexPath: IndexPath?
    weak var deledate: PeerNameTableViewCellDelegate?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    
    @IBAction func tapConnect(_ sender: UIButton) {
        deledate?.didTapConnectButton(sender, indexPath: self.indexPath)
    }
}
