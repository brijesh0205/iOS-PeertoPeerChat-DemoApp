Peer to Peer chat demo using MultipeerConnectivity framework of iOS
============

This is an open-source app to demonstrate a peer to peer chat using MultipeerConnectivity framework of iOS. This framework is available from iOS 7.0


## Key features of the app

1. User enters his name to make him visible in the network with the choosen name
2. User navigates to peer list screen after entering name.
3. Two or more users see each other in the peer list screen
4. User can turn off his visibilty in the network
5. One user can send an invite request to another user listed in the peer list by clicking "Connect" button.
6. Opponent receives an invite request which he may accept or decline.
7. If invite is accepted, both user navigate to chat screen where they can send text messgaes to each other


## Future scopes in the app

1. To retrict user to send one invite at a time, "Connect" button can be disabled for other users until sent request is declined by opponent.
2. An small activity indicator can be shown to show that peers are being seached in the network.
3. After clicking exit button by any user, both user can be sent to home screen.
4. Time stamp of chat received or sent can be shown.
5. Chat textfield can be grown when text is 2 line or more.
6. Chat can have multimedia sharing features like image, video, audio etc
7. Chat session can be stored locally in database and user might see those later. Althogh old chat session can only be read but can not be reinitiated.


## Screens

![alt text](https://github.com/brijesh0205/iOS-PeertoPeerChat-DemoApp/blob/main/Screen%20Recording%202020-11-27%20at%201.59.03%20PM.gif)


## Dependencies

- MultipeerConnectivity.framework
- [KMPlaceholderTextView](https://github.com/MoZhouqi/KMPlaceholderTextViewe)

## Requirements

- iOS 13.0+
- Xcode 11.0+

## Credits

[KMPlaceholderTextView](https://github.com/MoZhouqi/KMPlaceholderTextView) file has been used to show a placeholder in chat textfield. Thanks to [Zhouqi Mo](https://github.com/MoZhouqi)


## Author

[Brijesh Singh](https://github.com/brijesh0205)
