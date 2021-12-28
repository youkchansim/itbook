//
//  SearchBooksResultViewController.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import UIKit
import Combine
import Storyboards

public final class SearchBooksResultViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    @Published private var query: String?
    
    public var viewModel: SearchBooksResultViewModelType!
    
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
}

private extension SearchBooksResultViewController {
    
    func setupViews() {
        setupTableVew()
    }
    
    func setupTableVew() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bind() {
        $query
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] in
                guard let query = $0 else { return }
                if query.isEmpty {
                    self?.viewModel.action.cancel()
                } else {
                    self?.viewModel.action.search(query: query)
                }
            })
            .store(in: &cancellables)
        
        viewModel.state.searchedBooks
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] _ in self?.tableView.reloadData() })
            .store(in: &cancellables)
    }
}

extension SearchBooksResultViewController: SearchDelegate {
    
    public func search(query: String?) {
        self.query = query
    }
}

extension SearchBooksResultViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let book = viewModel.state.searchedBooks.value[indexPath.row]
        viewModel.action.select(book: book)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.state.searchedBooks.value.count - 2 {
            viewModel.action.loadNextPage()
        }
    }
}

extension SearchBooksResultViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.searchedBooks.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as? SearchBookCell else {
            return UITableViewCell()
        }
        
        let newBook = viewModel.state.searchedBooks.value[indexPath.row]
        
        cell.titleLabel.text = newBook.title
        cell.subtitleLabel.text = newBook.subtitle
        cell.isbn13Label.text = newBook.isbn13
        cell.urlLabel.text = newBook.url
        cell.priceLabel.text = newBook.price
        cell.bookImageView.cs.setImage(newBook.imageURL, placeHolderImage: UIImage(systemName: "book"), animated: false)
        
        return cell
    }
}

extension SearchBooksResultViewController: StoryboardInstantiable {
    
    public static var storyboardName: String { "SearchBooks" }
}
