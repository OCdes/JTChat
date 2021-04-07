//
//  JTSysMessageDetailVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/3/12.
//

import UIKit
import WebKit
class JTSysMessageDetailVC: BaseViewController, WKNavigationDelegate {
    var webView: WKWebView?
    var url: String = "" {
        didSet {
            self.webView?.load(URLRequest(url: URL(string: url)!))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration.init()
        self.webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        self.webView?.navigationDelegate = self
        self.view.addSubview(self.webView!)
        self.webView?.snp_makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.webView?.load(URLRequest(url: URL(string: url)!))
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title;
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
