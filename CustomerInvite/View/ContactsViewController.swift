//
//  ContactsViewController.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 30/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ContactsViewController: UIViewController {

    private struct Constants {

        static let cellIdentifier = "ContactCell"
        static let filterTitle = "Filter"
        static let removeFilterTitle = "Remove Filter"

    }

    @IBOutlet private weak var contactsTableView: UITableView!
    @IBOutlet private weak var filterButton: UIBarButtonItem!
    @IBOutlet private weak var importButton: UIButton!
    @IBOutlet private weak var exportButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let viewModel: ContactsViewModel = ContactsViewModelBase()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        observe()
        viewModel.viewDidLoad()
    }

    // MARK: - Rx binding

    private func bind() {
        bindDataSource()
        bindIsDataLoading()
        bindIsDataFiltered()
        bindAlert()
        bindShare()
    }

    private func bindDataSource() {
        viewModel.dataSource
            .observeOn(MainScheduler.instance)
            .bind(to: contactsTableView.rx
                .items(cellIdentifier: Constants.cellIdentifier,cellType: ContactTableViewCell.self)) { index, model, cell in
                    cell.idLabel.text = String(model.id)
                    cell.nameLabel.text = model.name
            }
            .disposed(by: disposeBag)
    }

    private func bindIsDataLoading() {
        viewModel.isDataLoading
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .map { !$0 }
            .subscribe(onNext: setUpButtonsBehaviour)
            .disposed(by: disposeBag)
    }

    private func bindIsDataFiltered() {
        viewModel.isDataFiltered
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: toggleFilter)
            .disposed(by: disposeBag)
    }

    
    private func bindAlert() {
        viewModel.alert
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] details in
                guard let self = self else { return }
                let alertController = UIAlertController(title: details.alertTitle,
                                                        message: details.alertMessage,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: details.buttonTitle, style: .default, handler: nil))
                self.present(alertController, animated: true)
            }).disposed(by: disposeBag)
    }

    private func bindShare() {
        let activityController = UIActivityViewController(activityItems: ["NO IDEA"], applicationActivities: nil)
        present(activityController, animated: true)
    }

    // MARK: - Rx observing

    private func observe() {
        observeFilterTap()
        observeImportTap()
        observeExportTap()
    }

    private func observeFilterTap() {
        filterButton.rx.tap.subscribe(onNext: viewModel.filterData).disposed(by: disposeBag)
    }

    private func observeImportTap() {
        importButton.rx.tap.subscribe(onNext: viewModel.importData).disposed(by: disposeBag)
    }

    private func observeExportTap() {
        exportButton.rx.tap.subscribe(onNext: viewModel.exportData).disposed(by: disposeBag)
    }

    // MARK: - Private methods

    private func setUpButtonsBehaviour(isEnabled: Bool) {
        isEnabled ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        filterButton.isEnabled = isEnabled
        importButton.isEnabled = isEnabled
        exportButton.isEnabled = isEnabled
        contactsTableView.isHidden = !isEnabled
    }

    private func toggleFilter(hasFilter: Bool) {
        filterButton.title = hasFilter ? Constants.removeFilterTitle : Constants.filterTitle
    }

}
