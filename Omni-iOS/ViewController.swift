//
//  ViewController.swift
//  Omni-iOS
//
//  Created by Matic on 18/06/2019.
//  Copyright © 2019 Matic. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    let cellId = "cellId"
    var searchController: UISearchController!
    var decodedData = CryptoData()
    var activityIndicator: UIActivityIndicatorView!
    var filtered: [CryptoModel] = []
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupSearchController()
        setupActivityIndicator()
        
        apiCall { data in
            //self.decodedData = CryptoData()
            self.decodedData = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive  {
            return filtered.count
        } else {
            return decodedData.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        if (searchActive) {
            cell.cardTitle = filtered[indexPath.row].name
            cell.cardTitle = filtered[indexPath.row].name
            cell.cardItemTitle = filtered[indexPath.row].symbol.uppercased()
            cell.cardItemSubtitle = String((filtered[indexPath.row].current_price))
            cell.cardImageUrl = filtered[indexPath.row].image
        } else {
            cell.cardTitle = decodedData[indexPath.row].name
            cell.cardItemTitle = decodedData[indexPath.row].symbol.uppercased()
            cell.cardItemSubtitle = String((decodedData[indexPath.row].current_price))
            cell.cardImageUrl = decodedData[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 8, bottom: 8, right: 8)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // the top anchor is pinned to view.topAnchor otherwise, the weird "boost" effect on scroll appears.
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.becomeFirstResponder()
    }
    
    func apiCall(completion: @escaping (CryptoData) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // ensure there is data returned from this HTTP response
            guard let data = data else {
                print("No data")
                return
            }
            // decode the data using JSONDecoder()
            guard let cryptoData = try? JSONDecoder().decode(CryptoData.self, from: data) else {
                print("Error decoding data.")
                return
            }
            completion(cryptoData)
        }.resume()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    // MARK: UISearchController Logic
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        //print(searchString!)
        filtered = decodedData.filter({ (CryptoModel) -> Bool in
            return CryptoModel.name.lowercased().contains(find: searchString!)
        })
        filtered.forEach { (CryptoModel) in
            print(CryptoModel.name)
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        searchActive = false
        collectionView.reloadData()
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find.lowercased()) != nil
    }
}
