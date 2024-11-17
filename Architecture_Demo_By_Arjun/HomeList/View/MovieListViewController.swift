//
//  MovieListViewController.swift
//  Architecture_Demo_By_Arjun
//
//  Created by Arjun Thakur on 15/11/24.
//

import UIKit

class MovieListViewController: UIViewController {

    lazy var headerView: UIView = {[weak self] in
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var headerTitleLabel: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "Movies"
        return label
    }()
    
    lazy var tblView: UITableView = {[weak self] in
        var tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.backgroundColor = .clear
        tblView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        return tblView
    }()
    
    lazy var spinner: UIActivityIndicatorView = {[weak self] in
        var spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var viewModel: MovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .black
        
        viewModel = MovieViewModelImplementation(popularService: MoviePopularServiceImplmentation())
        loadData()
    }
    
    private func configureUI() {
        self.view.addSubview(headerView)
        headerView.addSubview(headerTitleLabel)
        self.view.addSubview(tblView)
        self.view.addSubview(spinner)
        
        tblView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            headerTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tblView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            spinner.heightAnchor.constraint(equalToConstant: 60),
            spinner.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        spinner.startAnimating()
    }
    
    private func loadData() {
        
        viewModel.fetchPopularMovies(pageNumber: viewModel.pageNumber) { [weak self] array in
            print("arrrya", array)
            self?.showSpinnerLoadingView(isShow: false)
            self?.tblView.reloadData()
        }
    }
    
    private func showSpinnerLoadingView(isShow: Bool) {
        if isShow {
            self.spinner.isHidden = false
            spinner.startAnimating()
        } else if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    private func loadMorePopularMovies() {
        //Increase page number
        let pageNumber = viewModel.pageNumber
        viewModel.pageNumber = pageNumber + 1
        //Start Spinner Loading View
        showSpinnerLoadingView(isShow: true)
        viewModel.fetchPopularMovies(pageNumber: viewModel.pageNumber) { [weak self] populary in
            //Stop Spinner Loading View
            print("populary", populary.count)
            self?.showSpinnerLoadingView(isShow: false)
            //Reload table view
//            self?.tblView.reloadSections(IndexSet(integer: 1), with: .none)
            self?.tblView.reloadData()
        }
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviePopularArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier,
                                                       for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
         let posterImageKey : String = "poster_path"
         let movieIdKey : String = "id"
            //configure data
            let movieDict = viewModel.moviePopularArray[indexPath.row] as! [String: Any]
            cell.configureCellElements(movieDictionary: movieDict)
            
            //Load image with caching
            let itemNumber = NSNumber(value: indexPath.item)
            if let cachedImage = self.viewModel.cache.object(forKey: itemNumber) {
                //print("Popular Movie using a cached image for item: \(itemNumber)")
                cell.configureImage(cachedImage)
            } else {
                let urlImageString = movieDict[posterImageKey] as? String ?? ""
                self.viewModel.loadImage(with: urlImageString) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    
                    cell.configureImage(image)
                    self.viewModel.upsertCache(with: image, for: itemNumber)
                }
            }
            return cell
    }
}

//MARK: - UIScrollViewDelegate
extension MovieListViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 15.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 15.0 {
            self.loadMorePopularMovies()
        }
    }

}
