//
//  ViewController4.swift
//  http
//
//  Created by Grandre on 16/2/28.
//  Copyright © 2016年 革码者. All rights reserved.
//

import UIKit

class ViewController4:UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate{
    
    
    var session:NSURLSession!
    
    func displayAlertWithTitle(title:String,message:String){
        
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    

    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
    }
    

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest  = 15
        
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let datatoup = "Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let url = NSURL(string: "http://www.jianshu.com/p/e89f4b40bd85")
        
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        let task = session.uploadTaskWithRequest(request, fromData: datatoup!)
        
        task.start()
        
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        session.finishTasksAndInvalidate()
        
        NSLog("错误 = \(error)")
        
        
        dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
            
            var message = "完成上传数据"
            
            if error != nil {
                message = "上传内容失败"
            }
            
            self?.displayAlertWithTitle("信息", message: message)
            
            })
        
    }
    
}
