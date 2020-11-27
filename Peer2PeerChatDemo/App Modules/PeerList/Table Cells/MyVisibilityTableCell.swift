//
//  MyVisibilityTableCell.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import UIKit

protocol MyVisibilityTableCellDelegate: class {
    func didTapVisibilitySwitch(_ switchVisibility: UISwitch, indexPath: IndexPath?)
}

class MyVisibilityTableCell: UITableViewCell {

    var indexPath: IndexPath?
    weak var deledate: MyVisibilityTableCellDelegate?
    
    @IBOutlet weak var switchVisibility: UISwitch!
    @IBAction func tapVisibilitySwitch(_ sender: UISwitch) {
        self.deledate?.didTapVisibilitySwitch(self.switchVisibility, indexPath: self.indexPath)
    }
}
