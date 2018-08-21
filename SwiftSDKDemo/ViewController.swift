//
//  ViewController.swift
//  SwiftSDKDemo
//
//  Created by jiaruh on 2018/8/20.
//  Copyright © 2018 jiaruh. All rights reserved.
//

import UIKit
import SwiftSDK

class ViewController: UIViewController {

    private lazy var tipLb : UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.black
        lb.textAlignment = .center
        lb.textColor = UIColor.white
        lb.frame = CGRect(x: 0, y: 100, width: 200, height: 30)
        lb.layer.cornerRadius = 6
        lb.clipsToBounds = true
        return lb
        }()
    
    private lazy var loginBtn : UIButton = {
        var btn = UIButton()
        btn = createButton("登录")
        btn.frame = CGRect(x: 0, y: 150, width: 100,height: 30)
        btn.isHidden = false
        btn.addTarget(self, action: #selector(sdkLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var payBtn : UIButton = {
        var btn = UIButton()
        btn = createButton("支付")
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sdkPay), for: .touchUpInside)
        return btn
    }()
    
    private lazy var switchBtn : UIButton = {
        var btn = UIButton()
        btn = createButton("切换账号")
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sdkSwitch), for: .touchUpInside)
        return btn
    }()
    
    override func loadView() {
        view = UIView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //监听通知
        let nc = NotificationCenter.default
        nc.addObserver(self, selector:#selector(onInit),
                       name: .initSDK, object: nil)
        nc.addObserver(self, selector:#selector(onLogin),
                       name:.login, object: nil)
        nc.addObserver(self, selector:#selector(onRegister),
                       name: .register, object: nil)
        nc.addObserver(self, selector:#selector(onLogout),
                       name:.logout, object: nil)
    }

    func setupUI() {
        //do some setup UI work
        view.addSubview(self.tipLb)
        view.addSubview(self.loginBtn)
        view.addSubview(self.payBtn)
        view.addSubview(self.switchBtn)
    }
    
    // MARK: - 点击事件
    @objc func sdkLogin() {
        SwiftSDKPortal.login()
    }
    
    @objc func sdkPay() {
        SwiftSDKPortal.pay()
    }
    
    @objc func sdkSwitch() {
        SwiftSDKPortal.logout()
    }
    
    // MARK: - SDK回调的处理
    
    /// 初始化回调
    ///
    /// - Parameter noti: 初始化通知
    @objc func onInit(_ noti: Notification) {
        print("监听到了初始化通知，开始执行回调")
        guard let info  = noti.object , let message = (info as! [String:String])["message"] else {
            tipLb.text = "初始化提示信息为空"
            return
        }
        tipLb.text = "初始化：\(message)"

    }
    
    /// 登陆回调
    ///
    /// - Parameter noti: 登陆通知
    @objc func onLogin(_ noti: Notification) {
       print("监听到了登陆通知，开始执行回调")
        guard let info  = noti.object, let message = (info as! [String:String])["message"] else {
            tipLb.text = "登陆提示信息为空"
            return
        }
        tipLb.text = "初始化：\(message)"
        if message == "成功" {
            updateUI("login")
            SwiftSDKPortal.set(serverNumber: "开天辟地", severName: "2", roleName: "liwei", roleId: "3115", grade: "22", roleMoney: "100", ext: [:])
        }

    }
    
    /// 注册回调
    ///
    /// - Parameter noti: 注册通知
    @objc func onRegister(_ noti: Notification) {
//        self.tipLb.text = "注册：\(noti.object?["message"])"
//        if (noti.object?["message"] == "成功") {
//            loginFuc()
//        }
    }
    
    /// 注销回调
    ///
    /// - Parameter noti: 注销通知
    @objc func onLogout(_ noti: Notification) {
//        self.tipLb.text = "注销：\(noti.object?["message"])"
//        if (noti.object?["message"] == "成功") {
//            logoutFuc()
//        }
    }
    
}


extension ViewController {
    
    
    /// 切换UI模式
    ///
    /// - Parameter mode: 传 "login" 或 "logout"
    func updateUI(_ mode:String) {
        switch mode {
        case "login":
            self.loginBtn.isHidden = true
            self.payBtn.isHidden = false
            self.switchBtn.isHidden = false
        default:
            self.loginBtn.isHidden = false
            self.payBtn.isHidden = true
            self.switchBtn.isHidden = true
        }
    }
}


//MARK: - 通知扩展

extension Notification.Name {
    static let initSDK = Notification.Name("SYSDK_InitInfo_Notification")
    static let login = Notification.Name("SYSDK_LoginInfo_Notification")
    static let register = Notification.Name("SYSDK_RegisterInfo_Notification")
    static let screenClose = Notification.Name("SYSDK_CloseScreen_Notification")
    static let screenOpen = Notification.Name("SYSDK_OpenScreen_Notification")
    static let payBack = Notification.Name("SYSDK_PayCallBack_Notification")
    static let switchAccount = Notification.Name("SYSDK_SwitchAccount_Notification")
    static let logout = Notification.Name("SYSDK_LogOutPlat_Notification")
}

//MARK: - 全局函数
fileprivate func createButton(_ title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor.blue
    button.setTitleColor(UIColor.black, for: .normal)
    button.setTitle(title, for: .normal)
    button.layer.masksToBounds = true
    button.layer.cornerRadius = 6.0
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    return button
}


