// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import Magellan













class DashboardMapCoordinatorProtocolMock: DashboardMapCoordinatorProtocol {
    var presenter: DashboardMapPresenterProtocol?

    //MARK: - showDetails

    var showDetailsForCallsCount = 0
    var showDetailsForCalled: Bool {
        return showDetailsForCallsCount > 0
    }
    var showDetailsForReceivedPlaceInfo: PlaceInfo?
    var showDetailsForClosure: ((PlaceInfo) -> Void)?

    func showDetails(for placeInfo: PlaceInfo) {
        showDetailsForCallsCount += 1
        showDetailsForReceivedPlaceInfo = placeInfo
        showDetailsForClosure?(placeInfo)
    }

}
// MARK: -
// MARK: -
class DashboardMapViewProtocolMock: DashboardMapViewProtocol {
    var presenter: DashboardMapPresenterProtocol {
        get { return underlyingPresenter }
        set(value) { underlyingPresenter = value }
    }
    var underlyingPresenter: DashboardMapPresenterProtocol!
    var isSetup: Bool {
        get { return underlyingIsSetup }
        set(value) { underlyingIsSetup = value }
    }
    var underlyingIsSetup: Bool!
    var controller: UIViewController {
        get { return underlyingController }
        set(value) { underlyingController = value }
    }
    var underlyingController: UIViewController!
    var loadingPresenter: UIViewController?

    //MARK: - showLoading

    var showLoadingCallsCount = 0
    var showLoadingCalled: Bool {
        return showLoadingCallsCount > 0
    }
    var showLoadingClosure: (() -> Void)?

    func showLoading() {
        showLoadingCallsCount += 1
        showLoadingClosure?()
    }

    //MARK: - hideLoading

    var hideLoadingCallsCount = 0
    var hideLoadingCalled: Bool {
        return hideLoadingCallsCount > 0
    }
    var hideLoadingClosure: (() -> Void)?

    func hideLoading() {
        hideLoadingCallsCount += 1
        hideLoadingClosure?()
    }

}
// MARK: -
// MARK: -
class LocationDetailsPresenterDelegateMock: LocationDetailsPresenterDelegate {

    //MARK: - dismiss

    var dismissCallsCount = 0
    var dismissCalled: Bool {
        return dismissCallsCount > 0
    }
    var dismissClosure: (() -> Void)?

    func dismiss() {
        dismissCallsCount += 1
        dismissClosure?()
    }

}
// MARK: -
// MARK: -
class MagellanServicePrototcolMock: MagellanServicePrototcol {

    //MARK: - getCategories

    var getCategoriesRunCompletionInCompletionCallsCount = 0
    var getCategoriesRunCompletionInCompletionCalled: Bool {
        return getCategoriesRunCompletionInCompletionCallsCount > 0
    }
    var getCategoriesRunCompletionInCompletionReceivedArguments: (queue: DispatchQueue, completion: CategoriesCompletionBlock)?
    var getCategoriesRunCompletionInCompletionReturnValue: Operation!
    var getCategoriesRunCompletionInCompletionClosure: ((DispatchQueue, @escaping CategoriesCompletionBlock) -> Operation)?

    func getCategories(runCompletionIn queue: DispatchQueue, completion: @escaping CategoriesCompletionBlock) -> Operation {
        getCategoriesRunCompletionInCompletionCallsCount += 1
        getCategoriesRunCompletionInCompletionReceivedArguments = (queue: queue, completion: completion)
        return getCategoriesRunCompletionInCompletionClosure.map({ $0(queue, completion) }) ?? getCategoriesRunCompletionInCompletionReturnValue
    }

    //MARK: - getPlace

    var getPlaceWithRunCompletionInCompletionCallsCount = 0
    var getPlaceWithRunCompletionInCompletionCalled: Bool {
        return getPlaceWithRunCompletionInCompletionCallsCount > 0
    }
    var getPlaceWithRunCompletionInCompletionReceivedArguments: (placeId: Int, queue: DispatchQueue, completion: PlaceInfoCompletionBlock)?
    var getPlaceWithRunCompletionInCompletionReturnValue: Operation!
    var getPlaceWithRunCompletionInCompletionClosure: ((Int, DispatchQueue, @escaping PlaceInfoCompletionBlock) -> Operation)?

    func getPlace(with placeId: Int, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation {
        getPlaceWithRunCompletionInCompletionCallsCount += 1
        getPlaceWithRunCompletionInCompletionReceivedArguments = (placeId: placeId, queue: queue, completion: completion)
        return getPlaceWithRunCompletionInCompletionClosure.map({ $0(placeId, queue, completion) }) ?? getPlaceWithRunCompletionInCompletionReturnValue
    }

    //MARK: - getPlaces

    var getPlacesWithRunCompletionInCompletionCallsCount = 0
    var getPlacesWithRunCompletionInCompletionCalled: Bool {
        return getPlacesWithRunCompletionInCompletionCallsCount > 0
    }
    var getPlacesWithRunCompletionInCompletionReceivedArguments: (request: PlacesRequest, queue: DispatchQueue, completion: PlacesCompletionBlock)?
    var getPlacesWithRunCompletionInCompletionReturnValue: Operation!
    var getPlacesWithRunCompletionInCompletionClosure: ((PlacesRequest, DispatchQueue, @escaping PlacesCompletionBlock) -> Operation)?

    func getPlaces(with request: PlacesRequest, runCompletionIn queue: DispatchQueue, completion: @escaping PlacesCompletionBlock) -> Operation {
        getPlacesWithRunCompletionInCompletionCallsCount += 1
        getPlacesWithRunCompletionInCompletionReceivedArguments = (request: request, queue: queue, completion: completion)
        return getPlacesWithRunCompletionInCompletionClosure.map({ $0(request, queue, completion) }) ?? getPlacesWithRunCompletionInCompletionReturnValue
    }

}
// MARK: -
// MARK: -
class MapDetailTableHelperDelegateMock: MapDetailTableHelperDelegate {

    //MARK: - hanlde

    var hanldePathCallsCount = 0
    var hanldePathCalled: Bool {
        return hanldePathCallsCount > 0
    }
    var hanldePathReceivedPath: String?
    var hanldePathClosure: ((String) -> Void)?

    func hanlde(path: String) {
        hanldePathCallsCount += 1
        hanldePathReceivedPath = path
        hanldePathClosure?(path)
    }

}
// MARK: -
// MARK: -
class MapListViewProtocolMock: MapListViewProtocol {
    var presenter: MapListPresenterProtocol {
        get { return underlyingPresenter }
        set(value) { underlyingPresenter = value }
    }
    var underlyingPresenter: MapListPresenterProtocol!
    var isSetup: Bool {
        get { return underlyingIsSetup }
        set(value) { underlyingIsSetup = value }
    }
    var underlyingIsSetup: Bool!
    var controller: UIViewController {
        get { return underlyingController }
        set(value) { underlyingController = value }
    }
    var underlyingController: UIViewController!

    //MARK: - reloadData

    var reloadDataCallsCount = 0
    var reloadDataCalled: Bool {
        return reloadDataCallsCount > 0
    }
    var reloadDataClosure: (() -> Void)?

    func reloadData() {
        reloadDataCallsCount += 1
        reloadDataClosure?()
    }

}
// MARK: -
// MARK: -
class MapViewProtocolMock: MapViewProtocol {
    var presenter: MapPresenterProtocol {
        get { return underlyingPresenter }
        set(value) { underlyingPresenter = value }
    }
    var underlyingPresenter: MapPresenterProtocol!
    var zoom: Int {
        get { return underlyingZoom }
        set(value) { underlyingZoom = value }
    }
    var underlyingZoom: Int!
    var coordinatesHash: String {
        get { return underlyingCoordinatesHash }
        set(value) { underlyingCoordinatesHash = value }
    }
    var underlyingCoordinatesHash: String!
    var contentView: UIView {
        get { return underlyingContentView }
        set(value) { underlyingContentView = value }
    }
    var underlyingContentView: UIView!
    var contentInsets: UIEdgeInsets {
        get { return underlyingContentInsets }
        set(value) { underlyingContentInsets = value }
    }
    var underlyingContentInsets: UIEdgeInsets!
    var preferredContentHeight: CGFloat {
        get { return underlyingPreferredContentHeight }
        set(value) { underlyingPreferredContentHeight = value }
    }
    var underlyingPreferredContentHeight: CGFloat!
    var observable: ViewModelObserverContainer<ContainableObserver> {
        get { return underlyingObservable }
        set(value) { underlyingObservable = value }
    }
    var underlyingObservable: ViewModelObserverContainer<ContainableObserver>!
    var isSetup: Bool {
        get { return underlyingIsSetup }
        set(value) { underlyingIsSetup = value }
    }
    var underlyingIsSetup: Bool!
    var controller: UIViewController {
        get { return underlyingController }
        set(value) { underlyingController = value }
    }
    var underlyingController: UIViewController!

    //MARK: - show

    var showPlaceCallsCount = 0
    var showPlaceCalled: Bool {
        return showPlaceCallsCount > 0
    }
    var showPlaceReceivedPlace: PlaceViewModel?
    var showPlaceClosure: ((PlaceViewModel) -> Void)?

    func show(place: PlaceViewModel) {
        showPlaceCallsCount += 1
        showPlaceReceivedPlace = place
        showPlaceClosure?(place)
    }

    //MARK: - reloadData

    var reloadDataCallsCount = 0
    var reloadDataCalled: Bool {
        return reloadDataCallsCount > 0
    }
    var reloadDataClosure: (() -> Void)?

    func reloadData() {
        reloadDataCallsCount += 1
        reloadDataClosure?()
    }

    //MARK: - setContentInsets

    var setContentInsetsAnimatedCallsCount = 0
    var setContentInsetsAnimatedCalled: Bool {
        return setContentInsetsAnimatedCallsCount > 0
    }
    var setContentInsetsAnimatedReceivedArguments: (contentInsets: UIEdgeInsets, animated: Bool)?
    var setContentInsetsAnimatedClosure: ((UIEdgeInsets, Bool) -> Void)?

    func setContentInsets(_ contentInsets: UIEdgeInsets, animated: Bool) {
        setContentInsetsAnimatedCallsCount += 1
        setContentInsetsAnimatedReceivedArguments = (contentInsets: contentInsets, animated: animated)
        setContentInsetsAnimatedClosure?(contentInsets, animated)
    }

}
// MARK: -
// MARK: -
