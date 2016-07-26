//
//  ViewController3.swift
//  http
//
//  Created by Grandre on 16/2/28.
//  Copyright © 2016年 革码者. All rights reserved.
//

//http 后台下载处理
import UIKit


extension NSURLSessionTask{
    func start(){
        self.resume()
    }
}

class ViewController3:UIViewController,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate {
    
    var session:NSURLSession!
    
    var configidentifier:String{
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let key  = "time"
        
        let times = userDefaults.stringForKey(key)
        
        if let thetime = times {
            return thetime
        }else{
            let newtime = NSDate().description
            userDefaults.setObject(newtime, forKey: key)
            userDefaults.synchronize()
            return newtime
        }
    }
    
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
   
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(self.configidentifier)
        config.timeoutIntervalForRequest = 15
        
        session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let url = NSURL(string: "http://www.jianshu.com/p/e89f4b40bd85")
        
        let task = session.downloadTaskWithURL(url!)
        
        task.start()
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(downloadTask.response)
        let progress = totalBytesWritten / totalBytesExpectedToWrite
        print(bytesWritten)
        print(totalBytesWritten)
        print(totalBytesExpectedToWrite)//如果服务器未返回总长度，这里就显示-1
        print(progress)
        NSLog("接收数据")
       
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
           
            // 将临时文件剪切或者复制其他文件夹才能看到
           let fileManager = NSFileManager.defaultManager()
           let cachePath = try fileManager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
           let saveFileName = (cachePath.path)! + "/" + (downloadTask.response?.suggestedFilename)!
           try fileManager.moveItemAtPath(location.path!, toPath: saveFileName)
           NSLog("下载完成")
        }catch{
            
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        NSLog("任务完成")
        
        session.finishTasksAndInvalidate()
    }
    
    //
    func displayAlertWithTitle(title:String,message:String){
        
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
}