//
//  AuthLoader.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 17/09/2024.
//

import Foundation
import AuthenticationServices

final class AuthLoader: NSObject {
    private var authSession: ASWebAuthenticationSession?
    
    // MARK: - authLoader
    func authLoader(completion: @escaping (String?) -> Void) {
        
        let authURL = TwitchAuthEndpoint.authenticationURL()
        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: APIConfigKey.callbackURLScheme) { callback, error in
            
            guard error == nil else { return }
            
            guard let successURL = callback else { return }
            
            let urlComponents = URLComponents(string: successURL.absoluteString)
            let queryItems = urlComponents?.queryItems
            let code = queryItems?.first(where: {$0.name == "code"})?.value ?? ""
            
            completion(code)
        }
        
        DispatchQueue.main.async {
            self.authSession?.presentationContextProvider = self
            self.authSession?.prefersEphemeralWebBrowserSession = true
            self.authSession?.start()
        }
    }
}

extension AuthLoader: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
