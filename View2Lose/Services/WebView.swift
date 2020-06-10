//
//  WebView.swift
//  InstaLogin
//
//  Created by purich purisinsits on 17/4/20.
//  Copyright © 2020 purich purisinsits. All rights reserved.
//

import SwiftUI
import WebKit
import Combine



//class WebViewManager: ObservableObject {
//    static let shared:WebViewManager = WebViewManager(presentAuth: self.presentAuth)
//    private init() {}
//    @Binding var presentAuth = false
//
//    let view = WebViewManager.WebView()
//    let coordinator = WebViewManager.Coordinator()
//
//    let willChange = PassthroughSubject<InstagramTestUser?, Never>()
//    @Published var instagramUser:InstagramTestUser? = nil {
//        didSet {
//            if instagramUser != nil {
//                willChange.send(instagramUser)
//            }
//        }
//    }
//
//    let willChangeAuth = PassthroughSubject<Bool, Never>()
//    @Published var presentAuth: Bool = true {
//        didSet {
//            if presentAuth != true {
//                willChangeAuth.send(presentAuth)
//            }
//        }
//    }
//
//}
//
//extension WebViewManager {
//    class Coordinator: NSObject, WKNavigationDelegate {
//        @Environment(\.presentationMode) var presentationMode
//
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction:
//            WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy) -> Void) {
//            // get instagram test user token and id
//            if let url = navigationAction.request.url?.absoluteString, let range = url.range(of: "code=") {
//                let request = navigationAction.request
//
//                //WebViewManager.shared.presentAuth = false
//                WebViewManager.presentAuth = false
//                self.presentationMode.wrappedValue.dismiss()
//
//                InstagramApi.shared.getTestUserIDAndToken(request: request) { (instagramTestUser) in
//                    //self.parent.testUserData = instagramTestUser
//                    //self.parent.presentAuth = false
//                    //WebViewManager.shared.instagramUser = instagramTestUser
//                    //WebViewManager.shared.presentAuth = false
//                }
//            }
//            decisionHandler(WKNavigationActionPolicy.allow)
//        }
//    }
//
//}
//
//extension WebViewManager {
//    struct WebView: UIViewRepresentable {
//
//        //@Binding  var presentAuth: Bool
//
//        func makeCoordinator() -> Coordinator {
//            return WebViewManager.shared.coordinator
//        }
//
//        func makeUIView(context: Context) -> WKWebView {
//
//            let webView = WKWebView()
//            webView.navigationDelegate = context.coordinator
//
//            return webView
//        }
//
//        func updateUIView(_ webView: WKWebView, context: Context) {
//            InstagramApi.shared.authorizeApp { (url) in DispatchQueue.main.async { webView.load(URLRequest(url: url!))
//
//
//            }
//            }
//        }
//
//    }
//
//
//}



 protocol InstagramLoginDelegate: class {
    func instagramLoginDidFinish(instagramUser: InstagramUser, error: NSError)
}

class WebViewController: UIViewController, WKNavigationDelegate,  InstagramLoginDelegate, ObservableObject {

    @Published var isUserAuthenticated: AuthState = .undefined
    
    @EnvironmentObject var facebookManager: FacebookManager


    let willChange = PassthroughSubject<InstagramUser?, Never>()
    @Published var instagramUser:InstagramUser? = nil {
        didSet {
            if instagramUser != nil {
                willChange.send(instagramUser)
            }
        }
    }

    public weak var delegate: InstagramLoginDelegate?

    var webView: WKWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    let instagram: InstagramApi = InstagramApi.shared



    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        instagram.authorizeApp { (url) in DispatchQueue.main.async { self.webView.load(URLRequest(url: url!)) }}

    }

    func setupWebView() {


        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)

        view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func instagramLoginDidFinish(instagramUser: InstagramUser, error: NSError) {
        print("Instagram User")
            facebookManager.isUserAuthenticated = .userOnBoard
       
    }

    func goToWebView() {
        let controller = UIViewController()
        controller.view.addSubview(self.webView)
        self.present(controller, animated: true)
    }


}


struct WebView: UIViewControllerRepresentable {

    @Binding  var presentAuth: Bool
          @Binding  var testUserData: InstagramTestUser
          @Binding  var instagramApi: InstagramApi
    @Environment(\.presentationMode) var presentationMode




    class Coordinator: NSObject, WKNavigationDelegate {

        var parent: WebView
        //@EnvironmentObject var facebookManager: FacebookManager


        init(parent: WebView) {
            self.parent = parent
        }
        

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction:
            WKNavigationAction, decisionHandler: @escaping(WKNavigationActionPolicy) -> Void) {
            let request = navigationAction.request
            self.parent.instagramApi.getTestUserIDAndToken(request: request) { (instagramTestUser) in
                self.parent.testUserData = instagramTestUser
                self.parent.presentAuth = false
                self.parent.presentationMode.wrappedValue.dismiss()
                print("Test")
            }

//            if let url = navigationAction.request.url?.absoluteString, let range = url.range(of: "code=") {
//               // self.parent.presentAuth = false
//                print("Parent Dismiss")
////                parent.presentationMode.wrappedValue.dismiss()
//                // get instagram test user token and id
//                let request = navigationAction.request
//                //facebookManager.isUserAuthenticated = .userOnBoard
//                let instagramManager = InstagramManager()
//                instagramManager.userSignIn(presentAuth: false)
//                //print(request.url?.absoluteString)
//
//            }
            decisionHandler(WKNavigationActionPolicy.allow)
       }

        func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
            return checkRequestForCallbackURL(request: request)
        }

        func checkRequestForCallbackURL(request: URLRequest) -> Bool {
            if let url = request.url?.absoluteString, let range = url.range(of: "code=") {
                self.parent.presentAuth = false
            }
            return true
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {

        let webVC = WebViewController()
        webVC.webView.navigationDelegate = context.coordinator

        return webVC
    }

    func updateUIView(_ webView: UIViewController, context: Context) {
        //let webVC = WebViewController()

       // self.instagramApi!.authorizeApp { (url) in DispatchQueue.main.async { webVC.load(URLRequest(url: url!)) }}
    }

    func goToWebView() {
        let webVC = WebViewController()
        webVC.goToWebView()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }

}


class InstagramManager: ObservableObject {
    @Published var isUserAuthenticated: AuthState = .undefined

    func userSignIn(presentAuth: Bool) {
        if !presentAuth {
            self.isUserAuthenticated = .userOnBoard
        } else {
            self.isUserAuthenticated = .undefined

        }


    }
}

