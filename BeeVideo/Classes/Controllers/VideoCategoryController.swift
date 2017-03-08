//
//  VideoCategoryController.swift
//  BeeVideo
//
//  Created by JinZhang on 16/5/16.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit
import Alamofire

class VideoCategoryController: BaseViewController,ZXOptionBarDelegate,ZXOptionBarDataSource {
    
    fileprivate var backBtn : UIButton!
    fileprivate var mOptionBar : ZXOptionBar!
    
    fileprivate var mBackgroundUrl : String = ""
    fileprivate var mDataList : Array<VideoBriefItem>!
    fileprivate var mVideoBriefItem : VideoBriefItem!
    
    fileprivate var currentElement : String = ""
    
    var extras : [ExtraData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryId = extras[0].value
        mDataList = Array<VideoBriefItem>()

        initView()
        
//        Alamofire.request(.GET, "http://www.beevideo.tv/api/video2.0/subject_videos.action", parameters: ["subjectId":categoryId]).response{ _,_,data,error in
//            if (error != nil) {
//                self.loadingView.stopAnimat()
//                self.errorView.isHidden = false
//                return
//            }
//            let parser = XMLParser(data: data!)
//            parser.delegate = self
//            parser.parse()
//        }
        
        Alamofire.request("http://www.beevideo.tv/api/video2.0/subject_videos.action",parameters: ["subjectId":categoryId!]).responseData { (response) in
            switch response.result{
            case .failure(_):
                self.loadingView.stopAnimat()
                self.errorView.isHidden = false
            case .success(let data):
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    fileprivate func initView(){
        backBtn = UIButton()
        backBtn.setImage(UIImage(named: "play_back_full"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(30)
            make.height.width.equalTo(30)
        }
        
        mOptionBar = ZXOptionBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 1/3), barDelegate: self, barDataSource: self)
        mOptionBar.backgroundColor = UIColor.clear
        mOptionBar.setDividerWidth(dividerWidth: 20)
        self.view.addSubview(mOptionBar)
        mOptionBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom).inset(30)
            make.height.equalTo(self.view.frame.height * 1/3)
        }
        
        loadingView = LoadingView()
        loadingView.startAnimat()
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(40)
        }
        
        errorView = ErrorView()
        errorView.errorInfoLable.text = Constants.NET_ERROR_MESSAGE_VOD
        errorView.isHidden = true
        self.view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(backBtn.snp.bottom)
            make.bottom.equalTo(self.view)
        }
    }
    
    func numberOfColumnsInOptionBar(_ optionBar: ZXOptionBar) -> Int {
        return mDataList.count
    }
    
    func optionBar(_ optionBar: ZXOptionBar, cellForColumnAtIndex index: Int) -> ZXOptionBarCell {
        let cellId = "optionCell"
        
        var cell : VideoCategoryCell? = optionBar.dequeueReusableCellWithIdentifier(cellId) as? VideoCategoryCell
        if cell == nil {
            cell = VideoCategoryCell(style: .zxOptionBarCellStyleDefault, reuseIdentifier: cellId)
        }
        
        cell?.itemView.setData(mDataList[index])
        
        return cell!
    }
    
    func optionBar(_ optionBar: ZXOptionBar, widthForColumnsAtIndex index: Int) -> Float {
        return Float(self.view.frame.height) * 1/3 * 5/7
    }
    
    func optionBar(_ optionBar: ZXOptionBar, didSelectColumnAtIndex index: Int) {
        let videoId = mDataList[index].id
        var extras = [ExtraData]()
        let data = ExtraData()
        data.value = videoId
        extras.append(data)
        let detailViewController = VideoDetailViewController()
        detailViewController.extras = extras
        self.present(detailViewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

/*
 xml解析
 */
extension VideoCategoryController:XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if currentElement == "video" {
            mVideoBriefItem = VideoBriefItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let content = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if content.isEmpty {
            return
        }
        if currentElement == "picBackgroundUrl" {
            mBackgroundUrl = content
        }else if currentElement == "id" {
            mVideoBriefItem.id = content
        }else if currentElement == "name"{
            mVideoBriefItem.name = content
        }else if currentElement == "channel"{
            mVideoBriefItem.channelId = content
        }else if currentElement == "channelName"{
            mVideoBriefItem.channel = content
        }else if currentElement == "duration"{
            mVideoBriefItem.duration += content
        }else if currentElement == "picUrl"{
            mVideoBriefItem.posterImg = content
        }else if currentElement == "most"{
            mVideoBriefItem.resolutionType = Int(content)
        }else if currentElement == "doubanId"{
            mVideoBriefItem.doubanId = content
        }else if currentElement == "doubanAverage"{
            mVideoBriefItem.score = content
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "video" {
            mDataList.append(mVideoBriefItem)
            mVideoBriefItem = nil
        }
        currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        loadingView.stopAnimat()
        self.setBackgroundImg(mBackgroundUrl)
        mOptionBar.reloadData()
    }
}


