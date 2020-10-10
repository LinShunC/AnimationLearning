//
//  ViewController.swift
//  Animation
//
//  Created by anyRTC on 2020/9/23.
//  Copyright © 2020 linshun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    var shapeLayer : CAShapeLayer!
    var pulsatingLayer : CAShapeLayer!
    var selectedCell: UIView?
    var isDownloding: Bool = false
    let numViewPerRow = 10
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    let urlString = "https://teameeting.oss-cn-shanghai.aliyuncs.com/play/man/head1.jpeg"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let countingLabel1 = CountingLabel(startValue: 100, endValue: 1500, animationDuration: 2.5)
        countingLabel1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.view.addSubview(countingLabel1)
        setupCircleProgressBar()
        setupShimmer()
        setupCell()
        setupNotificationObserve()
        setupPercentageLabel()
        view.backgroundColor  = UIColor.backgroundColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    
    func setupCircleProgressBar () {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
    }
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut )
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "puslating")
    }
    private func createCircleShapeLayer(strokeColor:UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.position = view.center
        layer.lineCap = CAShapeLayerLineCap.round
        layer.fillColor =  fillColor.cgColor
        return layer
    }
    @objc private func handleTap() {
        // image animation
        (0...10).forEach { (_) in
            generateAnimationViews()
        }
        //观察曲线变化
        //        let test = CurvedView(frame: view.frame)
        //               test.backgroundColor = .white
        //               view.addSubview(test)
        // progress bar
      //  addAnimationToShapeLayer(shapeLayer)
        if (!isDownloding) {
            beginDownloadingFile()
        }
    }
    
    private func beginDownloadingFile () {
        self.shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        isDownloding = true
    }
    func generateAnimationViews() {
        let image = drand48() > 0.5 ? UIImage(named: "thumbs_up") : UIImage(named: "heart")
        let imageView = UIImageView(image:image)
        let dimension = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        addAnimationToImageView(imageView)
        view.addSubview(imageView)
    }
    func setupShimmer() {
        let darkTextLabel = UILabel()
        darkTextLabel.text = "Shimmer"
        darkTextLabel.textColor = .init(white: 1, alpha: 2)
        darkTextLabel.font = UIFont.systemFont(ofSize: 80)
        darkTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        darkTextLabel.textAlignment = .center
        
        
        let shinyTextLabel = UILabel()
        shinyTextLabel.text = "Lin Shun"
        shinyTextLabel.textColor = .white
        shinyTextLabel.font = UIFont.systemFont(ofSize: 80)
        shinyTextLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        shinyTextLabel.textAlignment = .center
        view.addSubview(shinyTextLabel)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shinyTextLabel.frame
        
        let angle = 45 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        shinyTextLabel.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "doesn'tmatterJustSomeKey")
    }
    func setupCell() {
        let width = view.frame.width / CGFloat(numViewPerRow)
        let height = view.frame.height / 1.2
        SetupCell(width,height,numViewPerRow)
        for j in 0...10  {
            for i in 0...numViewPerRow {
                let key = "\(i)|\(j)"
                guard let cellView = cell[key] else { return }
                view.addSubview(cellView)
            }
        }
    }
    private func setupNotificationObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    fileprivate func setupPercentageLabel() {
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        view.addSubview(percentageLabel)
    }
    @objc func handlePan(gesture: UIPanGestureRecognizer)  {
        let location = gesture.location(in: view)
        print(location)
        
        // var loopCount = 0
        let width = view.frame.width / CGFloat(numViewPerRow)
        
        let i = Int(location.x / width)
        let j = Int((location.y - view.frame.height / 1.2) / width)
        
        let key = "\(i)|\(j)"
        guard let cellView = cell[key] else { return }
        
        view.bringSubviewToFront(cellView)
        
        if selectedCell != cellView
        {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
            
        }
        selectedCell = cellView
        //        for subview in view.subviews
        //        {
        //            if subview.frame.contains(location)
        //            {
        //                subview.backgroundColor = .black
        //                print(loopCount)
        //            }
        //            loopCount += 1
        //        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }) { (_) in
                
            }
            
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloading")
        isDownloding = false
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
            self.percentageLabel.text = "\(Int(percentage * 100))%"
        }
    }
}

