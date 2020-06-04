// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
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













class CategoriesFilterCoordinatorProtocolMock: CategoriesFilterCoordinatorProtocol {

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
class CategoriesFilterOutputProtocolMock: CategoriesFilterOutputProtocol {

    //MARK: - categoriesFilter

    var categoriesFilterCallsCount = 0
    var categoriesFilterCalled: Bool {
        return categoriesFilterCallsCount > 0
    }
    var categoriesFilterReceivedFilter: Set<PlaceCategory>?
    var categoriesFilterClosure: ((Set<PlaceCategory>) -> Void)?

    func categoriesFilter(_ filter: Set<PlaceCategory>) {
        categoriesFilterCallsCount += 1
        categoriesFilterReceivedFilter = filter
        categoriesFilterClosure?(filter)
    }

}
// MARK: -
// MARK: -
class CategoriesFilterViewProtocolMock: CategoriesFilterViewProtocol {
    var presenter: CategoriesFilterPresenterProtocol {
        get { return underlyingPresenter }
        set(value) { underlyingPresenter = value }
    }
    var underlyingPresenter: CategoriesFilterPresenterProtocol!
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

    //MARK: - reload

    var reloadCallsCount = 0
    var reloadCalled: Bool {
        return reloadCallsCount > 0
    }
    var reloadClosure: (() -> Void)?

    func reload() {
        reloadCallsCount += 1
        reloadClosure?()
    }

}
// MARK: -
// MARK: -
class DashboardMapCoordinatorProtocolMock: DashboardMapCoordinatorProtocol {
    var presenter: DashboardMapPresenterProtocol?

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
    var getPlaceWithRunCompletionInCompletionReceivedArguments: (placeId: String, queue: DispatchQueue, completion: PlaceInfoCompletionBlock)?
    var getPlaceWithRunCompletionInCompletionReturnValue: Operation!
    var getPlaceWithRunCompletionInCompletionClosure: ((String, DispatchQueue, @escaping PlaceInfoCompletionBlock) -> Operation)?

    func getPlace(with placeId: String, runCompletionIn queue: DispatchQueue, completion: @escaping PlaceInfoCompletionBlock) -> Operation {
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
class MapCoordinatorProtocolMock: MapCoordinatorProtocol {

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

    //MARK: - showCategoriesFilter

    var showCategoriesFilterCategoriesFilterOutputCallsCount = 0
    var showCategoriesFilterCategoriesFilterOutputCalled: Bool {
        return showCategoriesFilterCategoriesFilterOutputCallsCount > 0
    }
    var showCategoriesFilterCategoriesFilterOutputReceivedArguments: (categories: [PlaceCategory], filter: Set<PlaceCategory>, output: CategoriesFilterOutputProtocol?)?
    var showCategoriesFilterCategoriesFilterOutputClosure: (([PlaceCategory], Set<PlaceCategory>, CategoriesFilterOutputProtocol?) -> Void)?

    func showCategoriesFilter(categories: [PlaceCategory], filter: Set<PlaceCategory>, output: CategoriesFilterOutputProtocol?) {
        showCategoriesFilterCategoriesFilterOutputCallsCount += 1
        showCategoriesFilterCategoriesFilterOutputReceivedArguments = (categories: categories, filter: filter, output: output)
        showCategoriesFilterCategoriesFilterOutputClosure?(categories, filter, output)
    }

}
// MARK: -
// MARK: -
class MapListPresenterProtocolMock: MapListPresenterProtocol {
    var places: [PlaceViewModel] = []
    var view: MapListViewProtocol?
    var output: MapListOutputProtocol?
    var delegate: MapListPresenterDelegate?

    //MARK: - showDetails

    var showDetailsPlaceCallsCount = 0
    var showDetailsPlaceCalled: Bool {
        return showDetailsPlaceCallsCount > 0
    }
    var showDetailsPlaceReceivedPlace: PlaceViewModel?
    var showDetailsPlaceClosure: ((PlaceViewModel) -> Void)?

    func showDetails(place: PlaceViewModel) {
        showDetailsPlaceCallsCount += 1
        showDetailsPlaceReceivedPlace = place
        showDetailsPlaceClosure?(place)
    }

    //MARK: - search

    var searchWithCallsCount = 0
    var searchWithCalled: Bool {
        return searchWithCallsCount > 0
    }
    var searchWithReceivedText: String?
    var searchWithClosure: ((String) -> Void)?

    func search(with text: String) {
        searchWithCallsCount += 1
        searchWithReceivedText = text
        searchWithClosure?(text)
    }

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

    //MARK: - expand

    var expandCallsCount = 0
    var expandCalled: Bool {
        return expandCallsCount > 0
    }
    var expandClosure: (() -> Void)?

    func expand() {
        expandCallsCount += 1
        expandClosure?()
    }

    //MARK: - didUpdate

    var didUpdatePlacesCallsCount = 0
    var didUpdatePlacesCalled: Bool {
        return didUpdatePlacesCallsCount > 0
    }
    var didUpdatePlacesReceivedPlaces: [PlaceViewModel]?
    var didUpdatePlacesClosure: (([PlaceViewModel]) -> Void)?

    func didUpdate(places: [PlaceViewModel]) {
        didUpdatePlacesCallsCount += 1
        didUpdatePlacesReceivedPlaces = places
        didUpdatePlacesClosure?(places)
    }

    //MARK: - loadingComplete

    var loadingCompleteWithRetryClosureCallsCount = 0
    var loadingCompleteWithRetryClosureCalled: Bool {
        return loadingCompleteWithRetryClosureCallsCount > 0
    }
    var loadingCompleteWithRetryClosureReceivedArguments: (error: Error?, retryClosure: () -> Void)?
    var loadingCompleteWithRetryClosureClosure: ((Error?, @escaping () -> Void) -> Void)?

    func loadingComplete(with error: Error?, retryClosure: @escaping () -> Void) {
        loadingCompleteWithRetryClosureCallsCount += 1
        loadingCompleteWithRetryClosureReceivedArguments = (error: error, retryClosure: retryClosure)
        loadingCompleteWithRetryClosureClosure?(error, retryClosure)
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

    //MARK: - reloadPlaces

    var reloadPlacesCallsCount = 0
    var reloadPlacesCalled: Bool {
        return reloadPlacesCallsCount > 0
    }
    var reloadPlacesClosure: (() -> Void)?

    func reloadPlaces() {
        reloadPlacesCallsCount += 1
        reloadPlacesClosure?()
    }

    //MARK: - showErrorState

    var showErrorStateCallsCount = 0
    var showErrorStateCalled: Bool {
        return showErrorStateCallsCount > 0
    }
    var showErrorStateReceivedRetryClosure: (() -> Void)?
    var showErrorStateClosure: ((@escaping () -> Void) -> Void)?

    func showErrorState(_ retryClosure: @escaping () -> Void) {
        showErrorStateCallsCount += 1
        showErrorStateReceivedRetryClosure = retryClosure
        showErrorStateClosure?(retryClosure)
    }

}
// MARK: -
// MARK: -
class MapPresenterProtocolMock: MapPresenterProtocol {
    var view: MapViewProtocol?
    var coordinator: MapCoordinatorProtocol?
    var output: MapOutputProtocol?
    var categories: [PlaceCategory] = []
    var places: [PlaceViewModel] = []
    var clusters: [ClusterViewModel] = []
    var position: Coordinates {
        get { return underlyingPosition }
        set(value) { underlyingPosition = value }
    }
    var underlyingPosition: Coordinates!
    var myLocation: Coordinates?

    //MARK: - showDetails

    var showDetailsPlaceShowOnMapCallsCount = 0
    var showDetailsPlaceShowOnMapCalled: Bool {
        return showDetailsPlaceShowOnMapCallsCount > 0
    }
    var showDetailsPlaceShowOnMapReceivedArguments: (place: PlaceViewModel, showOnMap: Bool)?
    var showDetailsPlaceShowOnMapClosure: ((PlaceViewModel, Bool) -> Void)?

    func showDetails(place: PlaceViewModel, showOnMap: Bool) {
        showDetailsPlaceShowOnMapCallsCount += 1
        showDetailsPlaceShowOnMapReceivedArguments = (place: place, showOnMap: showOnMap)
        showDetailsPlaceShowOnMapClosure?(place, showOnMap)
    }

    //MARK: - loadCategories

    var loadCategoriesCallsCount = 0
    var loadCategoriesCalled: Bool {
        return loadCategoriesCallsCount > 0
    }
    var loadCategoriesClosure: (() -> Void)?

    func loadCategories() {
        loadCategoriesCallsCount += 1
        loadCategoriesClosure?()
    }

    //MARK: - loadPlaces

    var loadPlacesTopLeftBottomRightZoomCallsCount = 0
    var loadPlacesTopLeftBottomRightZoomCalled: Bool {
        return loadPlacesTopLeftBottomRightZoomCallsCount > 0
    }
    var loadPlacesTopLeftBottomRightZoomReceivedArguments: (topLeft: Coordinates, bottomRight: Coordinates, zoom: Int)?
    var loadPlacesTopLeftBottomRightZoomClosure: ((Coordinates, Coordinates, Int) -> Void)?

    func loadPlaces(topLeft:Coordinates, bottomRight: Coordinates, zoom: Int) {
        loadPlacesTopLeftBottomRightZoomCallsCount += 1
        loadPlacesTopLeftBottomRightZoomReceivedArguments = (topLeft: topLeft, bottomRight: bottomRight, zoom: zoom)
        loadPlacesTopLeftBottomRightZoomClosure?(topLeft, bottomRight, zoom)
    }

    //MARK: - showFilter

    var showFilterCallsCount = 0
    var showFilterCalled: Bool {
        return showFilterCallsCount > 0
    }
    var showFilterClosure: (() -> Void)?

    func showFilter() {
        showFilterCallsCount += 1
        showFilterClosure?()
    }

    //MARK: - select

    var selectPlaceCallsCount = 0
    var selectPlaceCalled: Bool {
        return selectPlaceCallsCount > 0
    }
    var selectPlaceReceivedPlace: PlaceViewModel?
    var selectPlaceClosure: ((PlaceViewModel) -> Void)?

    func select(place: PlaceViewModel) {
        selectPlaceCallsCount += 1
        selectPlaceReceivedPlace = place
        selectPlaceClosure?(place)
    }

    //MARK: - search

    var searchWithCallsCount = 0
    var searchWithCalled: Bool {
        return searchWithCallsCount > 0
    }
    var searchWithReceivedText: String?
    var searchWithClosure: ((String) -> Void)?

    func search(with text: String) {
        searchWithCallsCount += 1
        searchWithReceivedText = text
        searchWithClosure?(text)
    }

    //MARK: - reset

    var resetCallsCount = 0
    var resetCalled: Bool {
        return resetCallsCount > 0
    }
    var resetClosure: (() -> Void)?

    func reset() {
        resetCallsCount += 1
        resetClosure?()
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
    var loadingPresenter: UIViewController?

    //MARK: - setFilterButton

    var setFilterButtonHiddenCallsCount = 0
    var setFilterButtonHiddenCalled: Bool {
        return setFilterButtonHiddenCallsCount > 0
    }
    var setFilterButtonHiddenReceivedHidden: Bool?
    var setFilterButtonHiddenClosure: ((Bool) -> Void)?

    func setFilterButton(hidden: Bool) {
        setFilterButtonHiddenCallsCount += 1
        setFilterButtonHiddenReceivedHidden = hidden
        setFilterButtonHiddenClosure?(hidden)
    }

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

    //MARK: - removeSelection

    var removeSelectionCallsCount = 0
    var removeSelectionCalled: Bool {
        return removeSelectionCallsCount > 0
    }
    var removeSelectionClosure: (() -> Void)?

    func removeSelection() {
        removeSelectionCallsCount += 1
        removeSelectionClosure?()
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
class UserLocationServiceProtocolMock: UserLocationServiceProtocol {
    var currentLocation: Coordinates?
    var delegaet: UserLocationServiceDelegate?

}
// MARK: -
// MARK: -
