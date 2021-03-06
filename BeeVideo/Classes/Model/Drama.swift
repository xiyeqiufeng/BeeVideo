//
//  Drama.swift
//  SwiftTest
//
//  Created by JinZhang on 16/4/13.
//  Copyright © 2016年 skyworth. All rights reserved.
//


class Drama {
    var id : String = ""
    var title : String = ""//剧集名称  对应name
    var playedDuration : Int = 0//已播放时长
    var downloadStatus : Int = 0//下载状态
    var lastWatched : Bool = false //是否为最后一次观看，针对有多集的情况
    var sources : [VideoSourceInfo] = [VideoSourceInfo]() //每一集的源信息
    var currentUsedSourcePosition : Int = 0 //当前使用源的位置
    var currentUsedSourceInfo : VideoSourceInfo? //正在使用的源
    
    func hasSource() -> Bool{
        if sources.isEmpty {
            return false
        }
        return true
    }
    
    func getCurrentUsedSourceInfo() -> VideoSourceInfo?{
        if sources.isEmpty {
            return nil
        }
        if currentUsedSourcePosition < 0 || currentUsedSourcePosition >= sources.count {
            return nil
        }
        currentUsedSourceInfo = sources[currentUsedSourcePosition]
        currentUsedSourceInfo?.played = true
        return currentUsedSourceInfo
    }
    
    func setCurrentUsedSourcePosition(_ position: Int){
        if sources.isEmpty {
            return
        }
        if position >= sources.count - 1 {
            currentUsedSourcePosition = sources.count - 1
        }else if position <= 0 {
            currentUsedSourcePosition = 0
        }else{
            currentUsedSourcePosition = position
        }
        self.currentUsedSourceInfo = sources[currentUsedSourcePosition]
    }
}

