//
//  IssueDetailCollectionReusableView.swift
//  IssueTracker
//
//  Created by ParkJaeHyun on 2020/11/10.
//
import UIKit
import SwiftyMarkdown

class IssueDetailCollectionReusableView: UICollectionReusableView {
    static let identifier = "IssueDetailCollectionReusableView"

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var issueNumberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(item: IssueListViewModel) {
        authorLabel.text = item.title
        issueNumberLabel.text = "#\(item.id ?? 0)"
        bodyLabel.attributedText = convertMarkdownText(of: item.description)
        if item.isOpen {
            stateButton.setTitle("Open", for: .normal)
            stateButton.setTitleColor(.systemYellow, for: .normal)
            stateButton.backgroundColor = .systemGreen
        } else {
            stateButton.setTitle("Close", for: .normal)
            stateButton.setTitleColor(.systemYellow, for: .normal)
            stateButton.backgroundColor = .systemRed
        }
    }
    
    private func convertMarkdownText(of text: String) -> NSAttributedString {
        let markdown = SwiftyMarkdown(string: text)
        return markdown.attributedString()
    }
}
