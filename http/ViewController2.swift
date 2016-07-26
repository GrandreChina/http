//
//  ViewController2.swift
//  http
//
//  Created by Grandre on 16/2/28.
//  Copyright © 2016年 革码者. All rights reserved.
//
//http 基本网络请求（get方式），并将数据保存到文件
import UIKit

class ViewController2: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    var session:NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let config = NSURLSessionConfiguration.backgroundSessionConfiguration("back")//不赞成使用
        //let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("back")//委托中不能使用,使用系统处理下载,就算APP没有运行了,也可以实现
        //let config = NSURLSessionConfiguration.ephemeralSessionConfiguration();//这个是临时数据下载,适用于小数据下载
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()//默认配置
        config.timeoutIntervalForRequest = 15 //连接超时时间
        
        session = NSURLSession(configuration: config, delegate: self, delegateQueue:nil)//队列中,如果想要程序在主线程中执行,可以使用NSOperationQueue.mainQueue()
        
        let url = NSURL(string: "http://www.jianshu.com/p/e89f4b40bd85")
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            if (error == nil){
                
                let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Done!")
               
                self.session.finishTasksAndInvalidate() //确保执行完成后,释放session
                
                
                let manager = NSFileManager.defaultManager()
                
                do{
                    var destinationPath = try manager.URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: url, create: true)
                    
//                    获取//符号后面的string
                    let componenetsOfUrl = url?.absoluteString.componentsSeparatedByString("/")
                    let index = componenetsOfUrl!.count - 1
                    let fileNameFromUrl = componenetsOfUrl![index]+".text"
                    
                    destinationPath = destinationPath.URLByAppendingPathComponent(fileNameFromUrl)
                  print(destinationPath)
                    
                  try str?.writeToURL(destinationPath, atomically: true, encoding: NSUTF8StringEncoding)

                    let message = "保存下载数据到 = \(destinationPath)"
                    
                    self.displayAlertWithTitle("Success", message: message)
                    print(message)
                }catch{
                   print("error")
                }

                
            }else{
                self.displayAlertWithTitle("Error", message: "不能下载这数据,一个错误抛出")
            }
        }
        task.resume()

        
    }
    
    
    func displayAlertWithTitle(title:String,message:String){
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    ///
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
