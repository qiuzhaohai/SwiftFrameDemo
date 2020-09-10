//
//  NetWorkRequestManager.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/25.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class NetWorkRequestManager: NSObject {
    private var sessionManager: SessionManager?
    static let singleton = NetWorkRequestManager()
    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        sessionManager = SessionManager.init(configuration: config, delegate: SessionDelegate.init(), serverTrustPolicyManager: nil)
    }
}

extension NetWorkRequestManager {
    func requestByTargetType<T: Mappable>(targetType: NetWorkAPITargetType, model: T.Type, success: @escaping NetSuccessBlock<T>, failed: @escaping NetFailedBlock) -> Void {
        let url = targetType.baseUrl + targetType.path
        switch targetType.method {
            case .get:
                self.GET(url: url, param: targetType.pararms, headers: targetType.headers, success: success, failed: failed)
                break
            case .post:
                self.POST(url: url, param: targetType.pararms, headers: targetType.headers, success: success, failed: failed)
                break
            default:
                break
        }
    }
    func uploadByTargetType<T: Mappable>(targetType: NetWorkAPITargetType, model: T.Type,progess:@escaping AFSProgressBlock, success: @escaping NetSuccessBlock<T>, failed: @escaping NetFailedBlock) -> Void {
        let url = targetType.baseUrl + targetType.path
        switch targetType.method {
            case .uploadImage:
                self.postImage(image: targetType.pararms["image"] as! UIImage, url: url, param: nil, headers: targetType.headers, progressBlock: progess, successBlock: success, faliedBlock: failed)
                break
            case .uploadMp4:
                self.postVideo(video: targetType.pararms["video"] as! Data, url: url, param: nil, headers: targetType.headers, progressBlock: progess, successBlock: success, faliedBlock: failed)
                break
            default:
                break
        }
    }
}

extension NetWorkRequestManager {
    
    fileprivate func GET<T: Mappable>(url: String, param: Parameters?, headers: HTTPHeaders, success: @escaping NetSuccessBlock<T>, failed: @escaping NetFailedBlock) -> Void {
        self.sessionManager?.request(url, method: .get, parameters: param, encoding: URLEncoding.httpBody , headers: headers).validate().responseJSON(completionHandler: { (response) in
            self.handleResponse(response: response, successBlock: success, faliedBlock: failed)
        })
    }
    
    fileprivate func POST<T: Mappable>(url: String, param: Parameters?, headers: HTTPHeaders, success: @escaping NetSuccessBlock<T>, failed: @escaping NetFailedBlock) -> Void {
        self.sessionManager!.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseJSON(completionHandler: { (response) in
                self.handleResponse(response: response, successBlock: success, faliedBlock: failed)
            })
    }
    //    上传图片
    func postImage<T: Mappable>(image: UIImage, url: String, param: Parameters?, headers: HTTPHeaders, progressBlock: @escaping AFSProgressBlock, successBlock:@escaping NetSuccessBlock<T>,faliedBlock:@escaping NetFailedBlock) {
        
        let imageData = image.jpegData(compressionQuality: 0.0001)
        let headers = ["content-type":"multipart/form-data"]
        self.sessionManager?.upload(multipartFormData: { (multipartFormData) in
            //采用post表单上传
            // 参数解释
            let dataStr = DateFormatter.init()
            dataStr.dateFormat = "yyyyMMddHHmmss"
            let fileName = "\(dataStr.string(from: Date.init())).png"
            multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpg/png/jpeg")
        }, to: url, headers: headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    self.handleResponse(response: response, successBlock: successBlock, faliedBlock: faliedBlock)
//                    print("json:\(result)")
                }
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    progressBlock(progress.fractionCompleted)
                    print("图片上传进度: \(progress.fractionCompleted)")
                }
                break
            case .failure(let encodingError):
                self.handleRequestError(error: encodingError as NSError, faliedBlock: faliedBlock)
                break
            }
        })
    }
    
    func postVideo<T: Mappable>(video: Data, url: String, param: Parameters?, headers: HTTPHeaders, progressBlock: @escaping AFSProgressBlock, successBlock:@escaping NetSuccessBlock<T>, faliedBlock:@escaping NetFailedBlock) {
        self.sessionManager?.upload(multipartFormData: { (multipartFormData) in
            //采用post表单上传
            let dataStr = DateFormatter.init()
            dataStr.dateFormat = "yyyyMMddHHmmss"
            let fileName = "\(dataStr.string(from: Date.init())).mp4"
            multipartFormData.append(video, withName: "file", fileName: fileName, mimeType: "video/mp4")
        }, to: url, headers: headers, encodingCompletion: { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    self.handleResponse(response: response, successBlock: successBlock, faliedBlock: faliedBlock)
                    //                    print("json:\(result)")
                }
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    progressBlock(progress.fractionCompleted)
                    print("图片上传进度: \(progress.fractionCompleted)")
                }
                break
            case .failure(let encodingError):
                self.handleRequestError(error: encodingError as NSError, faliedBlock: faliedBlock)
                break
            }
        })
    }
}

extension NetWorkRequestManager {
    /** 处理服务器响应数据*/
    private func handleResponse<T: Mappable>(response:DataResponse<Any>, successBlock: NetSuccessBlock<T> ,faliedBlock: NetFailedBlock) {
        if let error = response.result.error {
            // 服务器未返回数据
            self.handleRequestError(error: error as NSError , faliedBlock: faliedBlock)
        }else if let value = response.result.value {
            // 服务器又返回数h数据
            if (value as? NSDictionary) == nil {
                // 返回格式不对
                self.handleRequestSuccessWithFaliedBlcok(faliedBlock: faliedBlock)
            }else{
                self.handleRequestSuccess(value: value, successBlock: successBlock, faliedBlock: faliedBlock)
            }
        }
    }
    
    /** 处理请求失败数据*/
    private func handleRequestError(error: NSError, faliedBlock: NetFailedBlock){
        var errorInfo = AFSErrorInfo()
        errorInfo.code = error.code
        errorInfo.error = error
        if ( errorInfo.code == -1009 ) {
            errorInfo.message = "无网络连接"
        }else if ( errorInfo.code == -1001 ){
            errorInfo.message = "请求超时"
        }else if ( errorInfo.code == -1005 ){
            errorInfo.message = "网络连接丢失(服务器忙)"
        }else if ( errorInfo.code == -1004 ){
            errorInfo.message = "服务器没有启动"
        }else if ( errorInfo.code == 404 || errorInfo.code == 3) {
        }
        faliedBlock(errorInfo)
    }
    
    /** 处理请求成功数据*/
    private func handleRequestSuccess<T: Mappable>(value:Any, successBlock: NetSuccessBlock<T>,faliedBlock: NetFailedBlock) {
        let json: JSON = JSON(value)
        let baseModel = NetWorkBaseModel<T>.init(JSONString: json.description)
        if baseModel?.status == 1 {
            successBlock(baseModel!, json)
        } else if baseModel?.status == 0 { // 获取服务器返回失败原因
            var errorInfo = AFSErrorInfo()
            errorInfo.code = baseModel!.status
            errorInfo.message = (baseModel?.msg)!
            faliedBlock(errorInfo)
        }
    }
    
    /** 服务器返回数据解析出错*/
    private func handleRequestSuccessWithFaliedBlcok(faliedBlock:NetFailedBlock)  {
        var errorInfo = AFSErrorInfo()
        errorInfo.code = -1
        errorInfo.message = "数据解析出错"
    }
}

