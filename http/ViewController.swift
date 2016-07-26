//
//  ViewController.swift
//  http
//
//  Created by Grandre on 16/2/27.
//  Copyright © 2016年 革码者. All rights reserved.
//

//http get post方式介绍
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dataLabel: UILabel!

//带header的HTTP get 请求
    @IBAction func getRequestWithHeader(sender: AnyObject) {
        
        let url:NSURL = NSURL(string: "http://apis.baidu.com/heweather/pro/weather?city=beijing")!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        request.HTTPMethod = "GET"
        // 请求的Header
        request.addValue("a566eb03378211f7dc9ff15ca78c2d93", forHTTPHeaderField: "apikey")
        
        let configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configuration)

        let task:NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data:NSData?,response:NSURLResponse?,error:NSError?)->Void in
            if error == nil{
                do{
                    let responseData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print("普通带头与参数的GET请求 --- > \(responseData)")
                    
                }catch{
                    
                }
            }
        })
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        postRequest()
      
    }
//普通的HTTP get请求
    func getRequest(){
        // 获取Url --- 这个是我获取的天气预报接口
        let url:NSURL = NSURL(string: "http://aqicn.org/publishingdata/json")!
        // 转换为requset
        let requets:NSURLRequest = NSURLRequest(URL: url)
        //NSURLSession 对象都由一个 NSURLSessionConfiguration 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项
        let configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configuration)
        
        //NSURLSessionTask负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载，NSURLSessionTask 与 NSURLConnection 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 NSURLSession 这一公共委托者（common delegate）
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(requets, completionHandler: {
            (data:NSData?,response:NSURLResponse?,error:NSError?)->Void in
            if error == nil{
                do{
                    
                    let responseData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSArray
       
                    print(responseData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dataLabel.text = responseData.firstObject!["cityName"]! as? String
                    })
                    
                }catch{
                    
                }
            }
        })
        // 启动任务
        task.resume()
    }

    func postRequest(){
        let request = NSMutableURLRequest(URL: NSURL(string: "http://120.25.226.186:32812/login")!)
        // 这块就是区别啦，其实也差不多
        request.HTTPMethod = "POST"
        let postString = "username=520it&pwd=520it&type=JSON"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data:NSData?,response:NSURLResponse?,error:NSError?)->Void in
            if error == nil{
                do{
//解析方式1
                    let responseString = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                 
                     print("Post --- > \(responseString)")
                    let result = responseString["success"]?.dataUsingEncoding(NSUTF8StringEncoding)
                    let result1 = NSString(data: result!, encoding:NSUTF8StringEncoding )
                    print(result1)
// 解析方式2
                    let responseString2 = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Post --- > \(responseString2)")
                    

                }catch{
                    print("have catch")
                }
            }
    
        })
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

