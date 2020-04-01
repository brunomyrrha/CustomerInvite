//
//  ContactsViewModelUnitTests.swift
//  CustomerInviteUnitTests
//
//  Created by Bruno Diniz on 01/04/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Customer_Invite

final class ContactsViewModelUnitTests: XCTestCase {

    private var disposeBag: DisposeBag!
    private var viewModel: ContactsViewModel!
    private var scheduler: TestScheduler!
    private var dataSourceObserver: TestableObserver<[Contact]>!
    private var isDataLoadingObserver: TestableObserver<Bool>!
    private var isDataFilteredObserver: TestableObserver<Bool>!
    private var alertObserver: TestableObserver<AlertDetails>!
    private var shareObserver: TestableObserver<[Any]>!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        viewModel = ContactsViewModelBase()
        scheduler = TestScheduler(initialClock: 0)
        dataSourceObserver = scheduler.createObserver([Contact].self)
        isDataLoadingObserver = scheduler.createObserver(Bool.self)
        isDataFilteredObserver = scheduler.createObserver(Bool.self)
        alertObserver = scheduler.createObserver(AlertDetails.self)
        shareObserver = scheduler.createObserver([Any].self)
        bindScheduler(with: viewModel)
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        dataSourceObserver = nil
        isDataLoadingObserver = nil
        isDataFilteredObserver = nil
        alertObserver = nil
        shareObserver = nil

        super.tearDown()
    }

    // MARK: - Test methods

    func testViewDidLoadSuccessApiResponse() {
        viewModel.api = ContactsApiManagerSuccessMock()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 0)
        XCTAssertEqual(alertObserver.events.count, 0)
        viewModel.viewDidLoad()
        XCTAssertEqual(isDataFilteredObserver.events.count, 1)
        XCTAssertEqual(dataSourceObserver.events.count, 1)
        XCTAssertEqual(isDataLoadingObserver.events.count, 2)
        XCTAssertEqual(alertObserver.events.count, 0)
    }

    func testViewDidLoadFailureApiResponse() {
        viewModel.api = ContactsApiManagerFailureMock()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 0)
        XCTAssertEqual(alertObserver.events.count, 0)
        viewModel.viewDidLoad()
        XCTAssertEqual(isDataFilteredObserver.events.count, 1)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 2)
        XCTAssertEqual(alertObserver.events.count, 1)
    }

    func testImportDataSuccessApiResponse() {
        viewModel.api = ContactsApiManagerSuccessMock()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 0)
        XCTAssertEqual(alertObserver.events.count, 0)
        viewModel.importData()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 1)
        XCTAssertEqual(isDataLoadingObserver.events.count, 2)
        XCTAssertEqual(alertObserver.events.count, 0)
    }

    func testImportDataFailureApiResponse() {
        viewModel.api = ContactsApiManagerFailureMock()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 0)
        XCTAssertEqual(alertObserver.events.count, 0)
        viewModel.importData()
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataLoadingObserver.events.count, 2)
        XCTAssertEqual(alertObserver.events.count, 1)
    }

    func testExportData() {
        XCTAssertEqual(shareObserver.events.count, 0)
        viewModel.exportData()
        XCTAssertEqual(shareObserver.events.count, 1)
    }

    func testFilterData() {
        XCTAssertEqual(dataSourceObserver.events.count, 0)
        XCTAssertEqual(isDataFilteredObserver.events.count, 0)
        viewModel.filterData()
        XCTAssertEqual(dataSourceObserver.events.count, 1)
        XCTAssertEqual(isDataFilteredObserver.events.count, 1)
    }

    func bindScheduler(with viewModel: ContactsViewModel) {
        viewModel.dataSource.bind(to: dataSourceObserver).disposed(by: disposeBag)
        viewModel.isDataLoading.skip(1).bind(to: isDataLoadingObserver).disposed(by: disposeBag)
        viewModel.isDataFiltered.skip(1).bind(to: isDataFilteredObserver).disposed(by: disposeBag)
        viewModel.alert.bind(to: alertObserver).disposed(by: disposeBag)
        viewModel.share.bind(to: shareObserver).disposed(by: disposeBag)
    }

}

// MARK: - Mocked data

private class ContactsApiManagerSuccessMock: ContactsApiManager {

    func downloadTxtAsString(completion: @escaping (String?, Error?) -> Void) {
        completion(String("Done"), nil)
    }

}

private class ContactsApiManagerFailureMock: ContactsApiManager {

    private struct ErrorMock: Swift.Error {}

    func downloadTxtAsString(completion: @escaping (String?, Error?) -> Void) {
        completion(nil, ErrorMock())
    }

}
