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

    }

    @IBOutlet private weak var contactsTableView: UITableView!
    @IBOutlet private weak var filterButton: UIBarButtonItem!
    @IBOutlet private weak var importButton: UIButton!
    @IBOutlet private weak var exportButton: UIButton!

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
    }

    private func bindDataSource() {
        viewModel.dataSource
            .observeOn(MainScheduler.instance)
            .bind(to: contactsTableView.rx
                .items(cellIdentifier: Constants.cellIdentifier)) { index, model, cell in
                    cell.textLabel?.text = model.name
            }
            .disposed(by: disposeBag)
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



}
