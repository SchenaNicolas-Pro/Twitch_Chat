//
//  TwitchChatViewController.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 03/03/2025.
//

import UIKit

final class TwitchChatViewController: UIViewController {
    private let chatMessageStore: ChatMessageStore
    private let chatView = TwitchChatView()
    
    init(chatMessageStore: ChatMessageStore, channelName: String) {
        self.chatMessageStore = chatMessageStore
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = channelName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindStore()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarStyleForChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
        chatMessageStore.clearMessage()
        chatView.tableview.reloadData()
    }
    
    // MARK: - Binding
    private func bindStore() {
        chatMessageStore.onMessagesAppended = { [weak self] _ in
            guard let self = self else { return }
            self.chatView.tableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    
    // MARK: - UI Setup
    private func setUpUI() {
        view = chatView
        chatView.messageTextField.delegate = self
        chatView.tableview.delegate = self
        chatView.tableview.dataSource = self
        chatView.tableview.register(TwitchChatTableViewCell.self, forCellReuseIdentifier: TwitchChatTableViewCell.identifier)
        chatView.catchUpChatButton.addTarget(self, action: #selector(catchUpChatButtonTapIn), for: .touchUpInside)
        chatView.dimissKeyboardTapGesture.addTarget(self, action: #selector(dismissKeyboard))
    }
    
    private func setupNavBarStyleForChat() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.left.fill"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapIn))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .darkGray
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Actions
    @objc
    private func backButtonTapIn() {
        chatMessageStore.disconnectFromChat()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func catchUpChatButtonTapIn() {
        let firstRow = IndexPath(row: 0, section: 0)
        chatView.tableview.scrollToRow(at: firstRow, at: .top, animated: true)
        chatView.catchUpChatButton.isHidden = true
    }
    
    @objc
    private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? TwitchChatTableViewCell,
              let indexPath = chatView.tableview.indexPath(for: cell) else { return }
        
        let message = chatMessageStore.chatUserMessages[indexPath.row]
        chatMessageStore.highlightUserMessages(user: message.user)
        
        let indexPathsToReload = chatMessageStore.chatUserMessages.enumerated()
            .filter { $0.element.user == message.user }
            .map { IndexPath(row: $0.offset, section: 0) }
        
        chatView.tableview.reloadRows(at: indexPathsToReload, with: .none)
    }
    
    // MARK: - Keyboard Notifications
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.chatView.messageTextFieldBottomConstraint.constant = -keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.chatView.messageTextFieldBottomConstraint.constant = -16
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ScrollView Delegate
extension TwitchChatViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let threshold: CGFloat = 50.0
        
        chatView.catchUpChatButton.isHidden = offsetY <= threshold
    }
}

// MARK: - TableView Delegate
extension TwitchChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let user = chatMessageStore.chatUserMessages[indexPath.row].user
        let respondTo = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self else { return completion(false) }
            self.chatView.messageTextField.text = "@\(user) "
            self.chatView.messageTextField.becomeFirstResponder()
            
            completion(true)
        }
        
        respondTo.backgroundColor = .systemBlue
        let image = UIImage().rotatedImageForContextualActions(systemName: "arrowshape.turn.up.left.circle")
        respondTo.image = image!.withRenderingMode(.alwaysTemplate)
        
        return UISwipeActionsConfiguration(actions: [respondTo])
    }
}

// MARK: - TableView DataSource
extension TwitchChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageStore.chatUserMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TwitchChatTableViewCell.identifier, for: indexPath) as? TwitchChatTableViewCell else {
            return UITableViewCell()
        }
        
        let message = chatMessageStore.chatUserMessages[indexPath.row]
        let isUserHightlighted = chatMessageStore.isUserHighlighted(message.user)
        
        cell.doubleTapGesture.addTarget(self, action: #selector(self.handleDoubleTap))
        cell.configure(message: message)
        cell.backgroundColor = isUserHightlighted ? .systemPurple : .clear
        cell.chatUserName.textColor = isUserHightlighted ? .white : UIColor(hex: message.tags["color"] ?? "FFFFFF")
        cell.tag = message.id.hashValue
        
        return cell
    }
}

// MARK: - TextField Delegate
extension TwitchChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.hasText, let message = textField.text else { return false }
        chatMessageStore.sendMessage(with: message)
        
        textField.text = ""
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc
    func dismissKeyboard() {
        chatView.messageTextField.resignFirstResponder()
    }
}
