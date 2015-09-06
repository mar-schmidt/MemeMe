//
//  AppDelegate.swift
//  mme1
//
//  Created by Marcus Ronélius on 2015-08-25.
//  Copyright (c) 2015 Ronelium Applications. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
/*
        var tempView1 = UIView(frame: CGRectMake(0, 0, 300, 600))
        var tempView2 = UIView(frame: CGRectMake(0, 0, 300, 600))
        var tempView3 = UIView(frame: CGRectMake(0, 0, 300, 600))
        
        var tempImgView1 = UIImageView(frame: CGRectMake(0, 0, 300, 600))
        var tempImg1 = UIImage(named: "meme.jpg")
        tempImgView1.image = tempImg1
        
        var tempImgView2 = UIImageView(frame: CGRectMake(0, 0, 300, 600))
        var tempImg2 = UIImage(named: "meme2.jpg")
        tempImgView2.image = tempImg2
        
        var tempImgView3 = UIImageView(frame: CGRectMake(0, 0, 300, 600))
        var tempImg3 = UIImage(named: "meme.jpg")
        tempImgView3.image = tempImg3
        
        tempView1.addSubview(tempImgView1)
        tempView2.addSubview(tempImgView2)
        tempView3.addSubview(tempImgView3)

        let meme = Meme(topText: "test", bottomText: "test", image: tempImg1!, imageView: tempImgView1, view: tempView1)
        let meme2 = Meme(topText: "asdasd", bottomText: "asdas", image: tempImg2!, imageView: tempImgView2, view: tempView2)
        let meme3 = Meme(topText: "123123", bottomText: "21323", image: tempImg3!, imageView: tempImgView3, view: tempView3)
        memes.append(meme)
        memes.append(meme2)
        memes.append(meme3)
*/
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

