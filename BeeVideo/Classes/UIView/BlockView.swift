//
//  BlockView.swift
//  BeeVideo
//
//  Created by DanBin on 16/3/19.
//  Copyright © 2016年 skyworth. All rights reserved.
//

import UIKit


class BlockView: UIView {

    private var blockImage:CornerImageView!
    private var blockName:UILabel!
    private var x:CGFloat!
    private var y:CGFloat!
    private var width:CGFloat!
    private var height:CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //初始化Frame
    func initFrame(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat){
        self.x = x
        self.y = y
        self.width = width
        self.height = height

    }
    
    //初始化view
    func initView(homeSpace:HomeSpace){
        setFrame()
        initImage(homeSpace.items[0].icon)
        initLabel(homeSpace.items[0].name)
    }
    
    func setFrame(){
        frame = CGRectMake(x, y, width, height)
    }
    
    func initImage(url:String){
        blockImage = CornerImageView(frame: CGRectMake(0, 0, width, height))
        blockImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "cycle1.jpg"));
        addSubview(blockImage)
    }
    
    func initLabel(text:String){
        blockName = UILabel()
        blockName.frame = CGRectMake(0, height - 20, width, 20)
        blockName.text = text
        blockName.textAlignment = NSTextAlignment.Center
        blockName.textColor = UIColor.whiteColor()
        blockName.font = UIFont(name: "Helvetica", size: 12.0)

        addSubview(blockName)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan.......")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEnded.......")
    }

}
