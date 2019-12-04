//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by Synergistic Financial Networks on 02/12/2019.
//  Copyright © 2019 Synergistic Financial Networks. All rights reserved.
//

import UIKit
import ImageSlideshow


let reuseIdentifier = "cell";

let imageCache = NSCache<AnyObject, AnyObject>()

class ViewController: UIViewController{
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet var collectionView: UICollectionView!
    
    let sdWebImageSource = [ AlamofireSource(urlString: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"),
                             AlamofireSource(urlString: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"),
                             AlamofireSource(urlString: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")]
    
    private let spacing:CGFloat = 5.0
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        
        
        checkConnectivity()
        
        
        
        setupUi()
        
        getApiData()
    }
    
    
    func checkConnectivity(){
        if (Reachability.isConnectedToNetwork()){
            print("Internet Connection Available!")
        }else{
            //For Stop Activity Indicator
            print("Internet Connection not Available!")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    struct resObj:Codable {
        let completed:Bool
        let id:Int
        let title:String
        let userId:Int
    }
    
    
    
    func getApiData(){
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Array<resObj>.self, from: dataResponse)
                print("================")
                print(gitData[0].title)
                
            } catch let err {
                print("Err", err)
                
            }
            
            //            {
            //                   completed = 0;
            //                   id = 1;
            //                   title = "delectus aut autem";
            //                   userId = 1;
            //            }
            
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            
            
        }
        task.resume()
    }
    
    
    func setupUi(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self
        imageSlideShow.setImageInputs(sdWebImageSource as! [InputSource])
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let recognizer = UITapGestureRecognizer(target: self, action:nil)
        imageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.myImageView.image = UIImage(named: "placeholder")
        
        
        cell.myImageView.loadImageWithUrl(URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 2
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    
}
extension ViewController:ImageSlideshowDelegate{
    
}


