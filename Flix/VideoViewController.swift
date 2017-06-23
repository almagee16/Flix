//
//  VideoViewController.swift
//  Flix
//
//  Created by Alvin Magee on 6/23/17.
//  Copyright © 2017 Alvin Magee. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var videoView: UIWebView!
    var videoURL = ""
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        // Convert the url String to a NSURL object.
        let requestURL = URL(string:videoURL)!
        // Place the URL in a URL Request.
        let request = URLRequest(url: requestURL)
        // Load Request into WebView.
        videoView.loadRequest(request)
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
