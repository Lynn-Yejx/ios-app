//
//  ViewController.swift
//  gift
//
//  Created by 敬轩 on 2019/4/25.
//  Copyright © 2019 敬轩. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    let userDefault = UserDefaults.standard

    let TopBoxView:UIView = UIView()
    let TopBoxViewBG:UIView = UIView()
    let TopBoxViewLeftImageView:UIImageView = UIImageView()
    let TopBoxViewLeftLabel:UILabel = UILabel()
    let TopBoxViewRightBoxVIew:UIView = UIView()
    let TopBoxViewRightBoxVIewFirstLabel:UILabel = UILabel()
    let TopBoxViewRightBoxViewSecondLabel:UILabel = UILabel()
    var photoList:[UIImage] = [UIImage]()
    let boxView:UIView = UIView()
    let imageView:UIImageView = UIImageView()
    let scrollView:UIScrollView = UIScrollView()
    let scrollBGView:UIView = UIView()
    let locationlabelBgView:UIImageView = UIImageView()
    let locationLabel1:UILabel = UILabel()
    let locationLabel2:UILabel = UILabel()
    var addButton:UIButton = UIButton()
    var localPhtots:[UIImage] = []
    var photosTableView:UITableView = UITableView()
    var isGoingToChangeHead = 0
    var photosName = [String]()
    let fileManager = FileManager.default
    var timer = Timer()
    var gender:String = ""
    var targetGender:String = ""
    var id = ""
    
    let screenWidth = UIScreen.main.bounds.size.width
    let locatoinManager = CLLocationManager()
    
    let queue = DispatchQueue(label: "yjx", qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: nil)

    var myLocation:CLLocation = CLLocation()
    var targetLocation:CLLocation?
    //两部手机的距离
    var distance:CLLocationDistance = CLLocationDistance(floatLiteral: 0.0)
    //经纬度计算角度
    var ang:Double = Double()
    var lastAng:Double = Double()

    let imagePicker = UIImagePickerController()
    
    
    let testLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.lastAng = 0.0

        
        
        //获取本地图片
        getLocalPhotos()
        
        //设置imagePicker
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

    
        //设置locationManager
        locatoinManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locatoinManager.delegate = self
            locatoinManager.desiredAccuracy = kCLLocationAccuracyBest
            locatoinManager.startUpdatingLocation()
            locatoinManager.startUpdatingHeading()
        }
        
        //添加最上方topBoxView用作容器
        self.view.addSubview(TopBoxView)
        TopBoxView.backgroundColor = UIColor.clear
        TopBoxView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height + 22)
            make.height.equalTo(120)
        }
        
        //资料版？背景
        TopBoxView.addSubview(TopBoxViewBG)
        TopBoxViewBG.backgroundColor = UIColor.init(red: 240/255, green: 101/255, blue: 100/255, alpha: 1)
        TopBoxViewBG.layer.cornerRadius = 20
        TopBoxViewBG.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1/0.98)
            make.height.equalToSuperview().dividedBy(1/1)
        }
        
        //添加最上方topBoxView内的左边的图片View
        TopBoxView.addSubview(TopBoxViewLeftImageView)
        TopBoxViewLeftImageView.backgroundColor = UIColor.blue
        TopBoxViewLeftImageView.isUserInteractionEnabled = true
        TopBoxViewLeftImageView.layer.cornerRadius = 17.0
        TopBoxViewLeftImageView.image = UIImage(named:"添加.jpeg")
        TopBoxViewLeftImageView.contentMode = .scaleAspectFill
        TopBoxViewLeftImageView.clipsToBounds = true
        TopBoxViewLeftImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(95)
            make.width.equalTo(95)
        }
        
        //更换头像Button
        let changeHeadButton = UIButton(type: .custom)
        changeHeadButton.backgroundColor = UIColor.clear
        TopBoxViewLeftImageView.addSubview(changeHeadButton)
        changeHeadButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        changeHeadButton.tag = 1
        changeHeadButton.addTarget(self, action: #selector(showPhotoLibrary), for: .touchUpInside)
        
        
        
        //添加最上方topBoxView内的右边的BoxView
        TopBoxView.addSubview(TopBoxViewRightBoxVIew)
        TopBoxViewRightBoxVIew.backgroundColor = UIColor.clear
        TopBoxViewRightBoxVIew.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(1/0.5)
            make.width.equalTo(260)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
//            make.top.equalToSuperview()
        }
        

        
        //添加最上方topBoxView内的右边的BoxView内的第二个Label
        TopBoxViewRightBoxVIew.addSubview(TopBoxViewRightBoxViewSecondLabel)
        TopBoxViewRightBoxViewSecondLabel.backgroundColor = UIColor.clear
        TopBoxViewRightBoxViewSecondLabel.text = "10000 米"
        TopBoxViewRightBoxViewSecondLabel.textColor = .white
        TopBoxViewRightBoxViewSecondLabel.textAlignment = .center
//        TopBoxViewRightBoxViewSecondLabel.adjustsFontSizeToFitWidth =
        TopBoxViewRightBoxViewSecondLabel.font = UIFont.boldSystemFont(ofSize: 40)
        TopBoxViewRightBoxViewSecondLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(80)
            make.width.equalToSuperview().dividedBy(1/0.85)
            make.bottom.equalToSuperview()
        }

        
        //scorllView下的一个图层
        self.view.addSubview(scrollBGView)
        scrollBGView.backgroundColor = UIColor(displayP3Red: 118/255, green: 195/255, blue: 250/255, alpha: 1)
        scrollBGView.snp.makeConstraints { (make) in
            make.top.equalTo(TopBoxView.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(1/0.98)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        scrollBGView.layer.cornerRadius = 10
        
        //scrollView
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(TopBoxView.snp.bottom).offset(25)
            make.width.equalToSuperview().dividedBy(1/0.89)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        //添加底部View容器
        scrollView.addSubview(boxView)
        boxView.backgroundColor = UIColor.clear
        boxView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(440)
            make.width.equalTo(380)
            make.top.equalToSuperview()
        }
        
        //添加容器内图片
        boxView.addSubview(imageView)
        imageView.image = UIImage(named: "znz.png")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(360)
            make.width.equalTo(360)
        }
        
        //经纬度label背景View
        boxView.addSubview(locationlabelBgView)
        locationlabelBgView.backgroundColor = UIColor(displayP3Red: 52/255, green: 50/255, blue: 52/255, alpha: 0.78)
        locationlabelBgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(-5)
            make.width.equalToSuperview().dividedBy(1/0.9)
            make.height.equalTo(2)
        }
        locationlabelBgView.layer.cornerRadius = 13
        
        //添加容器里内的两个label显示经纬度
        boxView.addSubview(locationLabel1)
        boxView.addSubview(locationLabel2)
        locationLabel2.textAlignment = .center
        locationLabel1.textAlignment = .center
        locationLabel1.font = UIFont.boldSystemFont(ofSize: 21)
        locationLabel2.font = UIFont.boldSystemFont(ofSize: 21)
        locationLabel1.textColor = UIColor.black
        locationLabel2.textColor = UIColor.black
        locationLabel1.backgroundColor = UIColor.clear
        locationLabel2.backgroundColor = UIColor.clear
        locationLabel1.text = "please wait"
        locationLabel2.text = "please wait"
        locationLabel1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.width.equalTo(screenWidth/2 - 10)
            make.height.equalTo(48)
        }
        locationLabel2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-28)
            make.width.equalTo(screenWidth/2 - 10)
            make.height.equalTo(48)
            make.top.equalTo(imageView.snp.bottom).offset(2)
        }
        
      
        loadImageData()
//        setUpScrollView()
        
        
        photosTableView = UITableView(frame: CGRect(x: 0, y:440, width: screenWidth * 0.89, height: 430), style: .plain)
        scrollView.addSubview(photosTableView)
        photosTableView.separatorStyle = .none
        let cellNib = UINib(nibName: "yyTableViewCell", bundle: nil)
        photosTableView.register(cellNib, forCellReuseIdentifier: "cell")
        photosTableView.delegate = self
        photosTableView.dataSource = self
        photosTableView.backgroundColor = UIColor.clear
        photosTableView.showsVerticalScrollIndicator = false
        photosTableView.isEditing = false
        
        
        
        self.scrollView.isMultipleTouchEnabled = true
        self.scrollView.contentSize = CGSize(width: 300, height: 900)

        
        //添加照片Button
        addButton = UIButton(type: .custom)
        addButton.tag = 2
        addButton.addTarget(self, action: #selector(showPhotoLibrary), for: .touchUpInside)
        self.view.addSubview(addButton)
        addButton.setImage(UIImage(named: "添加.jpeg"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        getHeadPhoto()
//        测试数据上传与下载
//        let locationInfo:BmobObject = BmobObject(className: "locationInfoboy")
//        locationInfo.setObject(104.07 , forKey: "longitude")
//        locationInfo.setObject(30.67, forKey: "latitude")
//        locationInfo.setObject("boy", forKey: "userName")
//        locationInfo.saveInBackground()
        
        
        if let gender = userDefault.string(forKey: "gender") {
            self.gender = gender
            if gender == "boy"{
                targetGender = "girl"
            }
            if gender == "girl"{
                targetGender = "boy"
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (Timer) in
            self.getTargetLocationInfo(with: self.targetGender)
        }
        
        
        //测试角度
        
        
//        self.view.addSubview(testLabel)
//        self.testLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.height.equalTo(200)
//            make.width.equalTo(200)
//            make.centerX.equalToSuperview().offset(70)
//        }
//        self.testLabel.text = "heeee"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.targetGender != ""{
            timer.fire()
        }
        locatoinManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.string(forKey: "gender") == nil{
            let alert = UIAlertController(title: "⭐️ 2019.5.20", message: "你是？", preferredStyle: .alert)
            let girlAction = UIAlertAction(title: "女朋友", style: .default) {
                (UIAlertAction) in
                self.userDefault.set("girl", forKey: "gender")
                self.gender = "girl"
                self.targetGender = "boy"
                self.timer.fire()
                
            }
            let boyAction = UIAlertAction(title: "男朋友", style: .default) {
                (UIAlertAction) in
                self.userDefault.set("boy", forKey: "gender")
                self.gender = "boy"
                self.targetGender = "girl"
                self.timer.fire()
            }
            alert.addAction(girlAction)
            alert.addAction(boyAction)
            self.present(alert, animated: true) {
            }
        }
    }
    
    //更新我的地理位置信息
    func updateMyLocationInfo(with myName:String){
        if self.gender != ""{
            queue.async {
                let bquery:BmobQuery = BmobQuery(className: "locationInfo"+self.gender)
                bquery.whereKey("userName", equalTo: self.gender)
                bquery.findObjectsInBackground { (array, error) in
                    let obj:BmobObject = array?[0] as! BmobObject
                    self.id = obj.value(forKey: "objectId") as! String
                    bquery.getObjectInBackground(withId: self.id, block: { (BmoObject, error) in
                        let update = BmobObject(outDataWithClassName: BmoObject?.className, objectId: BmoObject?.objectId)
                        update?.setObject(self.myLocation.coordinate.longitude, forKey: "longitude")
                        update?.setObject(self.myLocation.coordinate.latitude, forKey: "latitude")
                        update?.updateInBackground(resultBlock: { (Bool, error) in
                        })
                    })
                }
                sleep(4)
            }
        }
    }
    
    //得到对象的地理位置信息
    func getTargetLocationInfo(with TargetName:String){
        if self.gender != "" {
            queue.async {
                let bquery:BmobQuery = BmobQuery(className: "locationInfo"+self.targetGender)
                bquery.whereKey("userName", equalTo: self.targetGender)
                bquery.findObjectsInBackground { (array, error) in
                        let obj:BmobObject = array![0] as! BmobObject
                        let targetLongitude = obj.object(forKey: "longitude")
                        let targetLatitude = obj.object(forKey: "latitude")
                        self.targetLocation = CLLocation.init(latitude: targetLatitude as! CLLocationDegrees, longitude: targetLongitude as! CLLocationDegrees)
                }
            }
            //更新经纬度
            if self.targetLocation != nil{
                self.locationLabel1.text = "经度:  " + String(self.targetLocation!.coordinate.longitude).prefix(6)
                self.locationLabel2.text = "纬度:  " + String(self.targetLocation!.coordinate.latitude).prefix(6)
                //更新距离
                if self.distance > 10000 {
                    self.TopBoxViewRightBoxViewSecondLabel.text = String(Int(self.distance/1000)) + "  公里"
                }else{
                    self.TopBoxViewRightBoxViewSecondLabel.text = String(Int(self.distance)) + "  米"
                }
            }
        }
    }
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first,self.targetLocation != nil{
            self.myLocation = location
            self.distance = location.distance(from: self.targetLocation!)
            updateMyLocationInfo(with: gender)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /*
         0.0 ：前进方向为北
         90.0 ：前进方向为东
         180.0 ：前进方向为南
         270.0 ：前进方向为西
         */
        
        //计算经纬角度？
        if (targetLocation != nil) {
            let longitudeSubtract = myLocation.coordinate.longitude - (targetLocation?.coordinate.longitude)!
            let latitudeSubtract = myLocation.coordinate.latitude - (targetLocation?.coordinate.longitude)!
            let tan = abs(latitudeSubtract/longitudeSubtract)
            let ang = atan(tan)*180/Double.pi
            self.ang = ang
//            if longitudeSubtract < 0, latitudeSubtract < 0{
//                //第一象限
//                self.ang = -(90 - ang)
//            }else if longitudeSubtract > 0, latitudeSubtract < 0{
//                //第二象限
//                self.ang = 90 - ang
//            }else if longitudeSubtract < 0, latitudeSubtract > 0{
//                //第三象限
//                self.ang = -(90 + ang)
//            }else if longitudeSubtract > 0 ,latitudeSubtract > 0{
//                //第四象限
//                self.ang = 90 + ang
//            }else{
//                if longitudeSubtract == 0, latitudeSubtract > 0{
//                    //正北
//                }else if longitudeSubtract == 0, latitudeSubtract < 0{
//                    //正南
//                }else if longitudeSubtract > 0, latitudeSubtract == 0{
//                    //正东
//
//                }else if longitudeSubtract < 0, latitudeSubtract == 0 {
//                    //正西
//                }
//            }
        }
        
        let jiaodu1 = CGFloat((360 - newHeading.trueHeading) + self.ang)
        let heading = newHeading.trueHeading
        // 旋转
        let angle = CGFloat(-heading + self.ang)
        let trueRotationAngle = CGFloat(Double(jiaodu1 - CGFloat(self.lastAng)) * Double.pi / 180 )
//        self.labelTest3.text = "朝向: \(newHeading.trueHeading) " + "\n" + "经纬度角度: + \(self.ang) " + "\n" + "上一次角度:+ \(self.lastAng)" + "\n" + "需要转过的角度: \(trueRotationAngle)"
//        self.testLabel.text = String(Double(angle - CGFloat(self.lastAng)))
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform(rotationAngle: trueRotationAngle).concatenating(self.imageView.transform)
        };
        self.lastAng = Double(jiaodu1)
    }
    

    //相机部分
    @objc func showPhotoLibrary(_ button:UIButton){
        self.present(imagePicker, animated: true) {
            if button.tag == 1{
                self.isGoingToChangeHead = 1
            }
            if button.tag == 2{
                self.isGoingToChangeHead = 0
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获得照片
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let date = Date()
        let timeFormatter = DateFormatter()
        //日期显示格式，可按自己需求显示
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        
        if isGoingToChangeHead == 0{
            //保存图片
            saveImage(currentImage: image, imageName: strNowTime)
            photoList.append(image)
            self.photosName.append(strNowTime + ".png")
            self.photosTableView.reloadData()
        }else if isGoingToChangeHead == 1{
            self.TopBoxViewLeftImageView.image = image
            saveImage(currentImage: image, imageName: "head")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //保存图片至沙盒
    func saveImage(currentImage: UIImage,imageName: String){
        let imageData = currentImage.jpegData(compressionQuality: 1)
        var filename = URL(fileURLWithPath: "")
        if isGoingToChangeHead == 1 {
            let data:Data = currentImage.jpegData(compressionQuality: 1)!
            userDefault.set(data, forKey: "headJpg")
//            filename = URL(fileURLWithPath: NSHomeDirectory() + "/head.png")
//            print(filename)
        }else if isGoingToChangeHead == 0{
            filename = getDocumentsDirectory().appendingPathComponent(imageName + ".png")
        }
        try? imageData!.write(to: filename)
        isGoingToChangeHead = 0
        
        
    }
    
    //得到沙盒路径
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //获得头像图片
    func getHeadPhoto(){
//        let path = NSHomeDirectory()
//        if let image = UIImage(contentsOfFile: path + "/head.png"){
//            self.TopBoxViewLeftImageView.image = image
//        }
        if let data = userDefault.data(forKey: "headJpg") {
            let image = UIImage(data: data)
            self.TopBoxViewLeftImageView.image = image
        }
    }
    
    //获取沙盒图片
    func getLocalPhotos(){
        let path = NSHomeDirectory() + "/Documents/"
        if var list = try? self.fileManager.contentsOfDirectory(atPath: path){
                list.sort { (s1, s2) -> Bool in
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    return df.date(from:String(s1.prefix(19)))! < df.date(from:String(s2.prefix(19)))!
                }
                //            print(list)
                for imageName in list{
                    if imageName != "头像.png"{
                        self.photosName.append(imageName)
                        self.localPhtots.append(UIImage(contentsOfFile: path + imageName)!)
                    }
                }
            }
    }

    
    //删除沙盒图片
    func deleteLocalPhoto(withName:String){
        if self.fileManager.fileExists(atPath: NSHomeDirectory() + "/Documents/" + withName){
            do {
                try? fileManager.removeItem(atPath: NSHomeDirectory() + "/Documents/" + withName)
            }
        }
    }
    
    //scrollView布局 + 刷新
    func loadImageData(){
        for (_, image) in localPhtots.enumerated() {
            photoList.append(image)
        }
    }
    
    //scrollView监听
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView.contentOffset.y >= 420.0 {
            self.scrollView.isScrollEnabled = false
        }else {
            self.scrollView.isScrollEnabled = true
            self.photosTableView.isScrollEnabled = true
        }
        if self.photosTableView.contentOffset.y < 0 {
            self.scrollView.isScrollEnabled = true
            self.photosTableView.isScrollEnabled = false
            self.scrollView.contentOffset.y = 418.0
        }
    }
    
    
    
    //uitableViewDataSource and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! yyTableViewCell
            cell.yyImageView.image = photoList[photoList.count - 1 - indexPath.row]
            cell.selectionStyle = .none
            //长按删除
            let longPressDeleteGesture = UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto(_:)))
            longPressDeleteGesture.minimumPressDuration =  1.0
            cell.addGestureRecognizer(longPressDeleteGesture)
//        print(photoList.count)
//        let cell = yyTableViewCell()
//        print(photoList.count - 1 - indexPath.row)
//        print(indexPath.row)
//        print(photoList[0])
//        print(photoList[photoList.count - 1 - indexPath.row])
//        cell.yyImageView.image = photoList[photoList.count - 1 - indexPath.row]
//        cell.selectionStyle = .none
        //长按删除
//        let longPressDeleteGesture = UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto(_:)))
//        longPressDeleteGesture.minimumPressDuration =  1.0
//        cell.addGestureRecognizer(longPressDeleteGesture)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func deletePhoto(_ gesture:UILongPressGestureRecognizer){
        var point:CGPoint = CGPoint()
        var index:IndexPath = IndexPath()
        var indexs:[IndexPath] = [IndexPath]()
        let alertView = UIAlertController(title: "删除照片", message: nil, preferredStyle: .alert)
        let alertActionCancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            
        }
        let alertActionConfirm = UIAlertAction(title: "确定", style: .destructive) { (UIAlertAction) in
            
            let imageName = self.photosName[self.photoList.count - 1 - (index.row)]
            self.deleteLocalPhoto(withName: imageName)
            self.photoList.remove(at: self.photoList.count - 1 - (index.row))
            self.photosTableView.deleteRows(at: indexs, with: .left)
            self.photosTableView.reloadData()
        }
        alertView.addAction(alertActionCancel)
        alertView.addAction(alertActionConfirm)
        if gesture.state == UIGestureRecognizer.State.began{
            point = gesture.location(in: self.photosTableView)
            index = self.photosTableView.indexPathForRow(at: point)!
            indexs.append(index)
            present(alertView, animated: true) {
                
            }
            
        }
        if gesture.state == UIGestureRecognizer.State.ended{
            
        }
    }
}


extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
