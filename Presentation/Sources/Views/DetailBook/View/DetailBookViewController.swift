//
//  DetailBookViewController.swift
//  
//
//  Created by 육찬심 on 2021/12/27.
//

import UIKit
import Image
import Combine
import Storyboards

public final class DetailBookViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var isbn10Label: UILabel!
    @IBOutlet private weak var isbn13Label: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var pagesLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var purchaseButton: UIButton!
    @IBOutlet private weak var chaptersContainerView: UIView!
    @IBOutlet private weak var chaptersStackView: UIStackView!
    
    public var viewModel: DetailBookViewModelType!
    
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.action.load()
    }
    
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        purchaseButton.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
    }
    
    private func bind() {
        viewModel.state.book
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] book in
                guard let self = self else { return }
                self.imageView.cs.setImage(book.imageURL, placeHolderImage: nil)
                self.titleLabel.text = book.title
                self.subtitleLabel.text = book.subtitle
                self.yearLabel.text = book.year
                self.authorsLabel.text = book.authors
                self.descriptionLabel.text = book.desc
                self.isbn10Label.text = "Isbn10 \(book.isbn10)"
                self.isbn13Label.text = "Isbn13 \(book.isbn13)"
                self.ratingLabel.text = book.rating
                self.priceLabel.text = book.price
                self.pagesLabel.text = book.pages
                self.publisherLabel.text = "\(book.publisher)"
                self.setupChaptersView(pdfs: book.pdf)
            }).store(in: &cancellables)
    }
    
    private func setupChaptersView(pdfs: [String: String]) {
        guard !pdfs.isEmpty else {
            chaptersContainerView.isHidden = true
            return
        }
        
        chaptersContainerView.isHidden = false
        chaptersStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        pdfs.forEach { pdf in
            let button = ChapterButton()
            button.pdf = (pdf.key, pdf.value)
            button.addTarget(self, action: #selector(chapterButtonTapped), for: .touchUpInside)
            chaptersStackView.addArrangedSubview(button)
        }
    }
    
    @objc
    func purchaseButtonTapped(_ button: UIButton) {
        viewModel.action.purchase()
    }
    
    @objc
    func chapterButtonTapped(_ button: ChapterButton) {
        if let pdf = button.pdf {
            viewModel.action.select(pdf: (pdf.title, pdf.urlString))
        }
    }
}

class ChapterButton: UIControl {
    
    var pdf: (title: String, urlString: String)? {
        didSet {
            label.text = pdf?.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private func setupViews() {
        backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(label)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
        ])
    }
}

extension DetailBookViewController: StoryboardInstantiable {
    
    public static var storyboardName: String { "DetailBook" }
}
