//
//  TimeUtils.swift
//  BeeVideo
//
//  Created by DanBin on 16/4/20.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class TimeUtils {

    static func formatTime(time:Int) -> String {
        if time <= 0 {
            return String.init(format: "%02zd:%02zd", 0, 0)
        } else if time < 60 {
            return String.init(format: "%02zd:%02zd", 0, time)
        } else if time < 3600 {
            let minute:Int = time / 60
            let second :Int = time % 60
            return String.init(format: "%02zd:%02zd", minute, second)
        } else {
            let hour:Int = time / 3600
            let minute:Int = time % 60
            let second :Int = time % 3600
            print("time : \(time) hour :\(hour) minute:\(minute) second : \(second)")
            return String.init(format: "%02zd:%02zd:%02zd", hour, minute, second)
        }
    }
   

}