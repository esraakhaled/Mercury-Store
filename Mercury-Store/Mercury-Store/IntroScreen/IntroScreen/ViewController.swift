//
//  ViewController.swift
//  Mercury-Store
//
//  Created by Esraa Khaled   on 17/06/2022.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var getStartedBtn: UIButton!

    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    //data for the slides
        var titles = ["Explore many products","Choose and checkout","Get it delivered"]
        var descs = ["Best Prices on your favourite brands","search latest products for the desired","Just Choose it!"]
        var imgs = ["shop1","shop2","shop3"]
    private weak var pageNavigationFlow: LaunchScreenNavigationFlow?
    
    init(_ pageNavigationFlow: LaunchScreenNavigationFlow?) {
        super.init(nibName: nil, bundle: nil)
        self.pageNavigationFlow = pageNavigationFlow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //get dynamic width and height of scrollview and save it
        override func viewDidLayoutSubviews() {
            scrollWidth = scrollView.frame.size.width
            scrollHeight = scrollView.frame.size.height
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.layoutIfNeeded()
            //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview
            UserDefaults.standard.set(true, forKey: "hasSeenOnBoard")
            self.scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false

            //crete the slides and add them
            var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

            for index in 0..<titles.count {
                frame.origin.x = scrollWidth * CGFloat(index)
                frame.size = CGSize(width: scrollWidth, height: scrollHeight)

                let slide = UIView(frame: frame)

                //subviews
                let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
                imageView.frame = CGRect(x:0,y:0,width:300,height:300)
                imageView.contentMode = .scaleAspectFit
                imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
              
                let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
                txt1.textAlignment = .center
                txt1.font = UIFont.boldSystemFont(ofSize: 20.0)
                txt1.text = titles[index]
               
                
                let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY+10,width:scrollWidth-64,height:50))
                txt2.textAlignment = .center
                txt2.numberOfLines = 3
                txt2.font = UIFont.systemFont(ofSize: 18.0)
                txt2.text = descs[index]
                
                slide.addSubview(imageView)
                slide.addSubview(txt1)
                slide.addSubview(txt2)
                scrollView.addSubview(slide)
               

            }

            //set width of scrollview to accomodate all the slides
            scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)

            //disable vertical scroll/bounce
            self.scrollView.contentSize.height = 1.0

            //initial state
            pagecontrol.numberOfPages = titles.count
            pagecontrol.currentPage = 0

        }

        //indicator
        @IBAction func pageChanged(_ sender: Any) {
            scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pagecontrol?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            setIndiactorForCurrentPage()
        }

        func setIndiactorForCurrentPage()  {
            let page = (scrollView?.contentOffset.x)!/scrollWidth
            pagecontrol?.currentPage = Int(page)
        }
    
    @IBAction func getStartedAction(_ sender: Any) {
        
        self.pageNavigationFlow?.goToHomeTabbar()
    }
    
    }
