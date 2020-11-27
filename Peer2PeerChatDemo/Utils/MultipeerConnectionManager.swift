//
//  MultipeerConnectionManager.swift
//  Peer2PeerChatDemo
//
//  Created by Brijesh Singh on 26/11/20.
//  Copyright © 2020 Brijesh Singh. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerConnectionDelegate: class {
    func didUpdatePeerList(peerList: [PeerUser])
    func didReceiveInvite(peerObject:PeerUser, accept: ((Bool)->Void)?)
}

protocol PeerMessageDelegate: class {
    func didReceiveMessage(message: Message)
}

class MultipeerConnectionManager: NSObject {
    static let shared = MultipeerConnectionManager()
    private override init(){}
    
    private var myPeerId: MCPeerID!
    private var session: MCSession!
    
    private var browser: MCNearbyServiceBrowser!
    private var advertiser: MCNearbyServiceAdvertiser!
    
    private var foundPeers = [PeerUser]()
    
    private let ServiceName = "peer-chat"
    
    private var didAcceptRequest:((Bool, PeerUser)->Void)?
    
    weak var peerConnectDelegate: PeerConnectionDelegate?
    weak var peerMessageDelegate: PeerMessageDelegate?

    func createSession(withName name:String) {
        
        self.myPeerId = MCPeerID(displayName: name)
        self.session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        self.session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: self.myPeerId, discoveryInfo: ["id":UUID().uuidString], serviceType: ServiceName)
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: self.myPeerId, serviceType: ServiceName)
        browser.delegate = self
    }
    
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    private func getPeerID(_ id: String) -> MCPeerID? {
        if let peerID = self.foundPeers.filter({$0.id == id}).first?.peerID {
            return peerID
        }
        return nil
    }
    
    private func getPeerObject(_ peer: MCPeerID) -> PeerUser? {
        if let peerObject = self.foundPeers.filter({$0.peerID == peer}).first {
            return peerObject
        }
        return nil
    }
    
    func sendInvite(to id: String, didAcceptRequest:((Bool, PeerUser)->Void)?) {
        self.didAcceptRequest = didAcceptRequest
        if let peerID = getPeerID(id) {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        }
    }
    
    func sendMessage(messgae: String, peer:PeerUser) {
        if let peerID = getPeerID(peer.id) {
            do {
                try self.session.send(messgae.data(using: .utf8)!, toPeers: [peerID], with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}

extension MultipeerConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        DispatchQueue.main.async {
            if let peerObject = self.getPeerObject(peerID) {
                if state == .connected {
                    self.didAcceptRequest?(true, peerObject)
                }
                else if state == .notConnected {
                    self.didAcceptRequest?(false, peerObject)
                }
                else {
                    //Connecting
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        DispatchQueue.main.async {
            if let message = String.init(data: data, encoding: .utf8) {
                let msgObj = Message.init(message: message, isSender: false)
                self.peerMessageDelegate?.didReceiveMessage(message: msgObj)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}


extension MultipeerConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "Found Peer: \(peerID) \nInfo: \(info ?? [:])")
        
        
        func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
                NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
            }
                
        if let id = info?["id"] as String?, self.foundPeers.contains(where: {$0.id == id}) == false {
            
            let peerObject = PeerUser.init(id: id, dispalyName: peerID.displayName, peerID: peerID)
            self.foundPeers.append(peerObject)
        }
        peerConnectDelegate?.didUpdatePeerList(peerList: self.foundPeers)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "Lost Peer: \(peerID)")

        self.foundPeers.removeAll { (peer) -> Bool in
            if peer.peerID == peerID {
                return true
            }
            return false
        }
        peerConnectDelegate?.didUpdatePeerList(peerList: self.foundPeers)
    }
}

extension MultipeerConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer: \(peerID)")
        if let peerObject = getPeerObject(peerID) {
            peerConnectDelegate?.didReceiveInvite(peerObject: peerObject, accept: { (accept) in
                invitationHandler(accept, self.session)
            })
        }
    }
}
