//
//  ViewController.swift
//  Quinbay
//
//  Created by Himan Dhawan on 10/01/22.
//

import UIKit

class ViewController: UIViewController, AlertController {
    
    /// ViewModel
    var viewModel : SearchControllerViewModel = SearchControllerViewModel(searchHandler: SearchAPIHandler())

    /// IBOutlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
// MARK: - UIView Controller Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDataSource()
    }
    
    func setUpDataSource() {
        self.searchTextField.placeholder = "Search"
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.viewModel.delegate = self
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell :  SearchedProductTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SearchedProductTableViewCell", for: indexPath) as? SearchedProductTableViewCell
        
        guard let cell = tableCell else {
            fatalError("SearchedProductTableViewCell not found")
        }
        cell.loadCellWithData(data: self.viewModel.products[indexPath.row])
        cell.delegate = self
        return cell
    }
}
// MARK: - SearchedProductTableViewCellDelegate

extension ViewController : SearchedProductTableViewCellDelegate {
    func addToCartTapped() {
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: "Added to cart." , message: "Checkout for purchasing.", actions: [action])
    }
    
}

// MARK: - UITableViewDataSourcePrefetching

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
        
        guard let text = self.searchTextField.text else {return}
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        viewModel.searchNextPage(text: text)
    }
  }
}

// MARK: - UITextFieldDelegate

extension ViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            self.viewModel.search(text: updatedText)
            
        }
        return true
    }
}

// MARK: - SearchControllerViewModelDelegate

extension ViewController : SearchControllerViewModelDelegate {
    
    func productDataFetched() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            self?.productTableView.reloadData()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - Util

extension ViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
      return indexPath.row + 1 >= viewModel.currentCount
    }
    
}
