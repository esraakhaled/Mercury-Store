//
//  OrdersClient.swift
//  Mercury-Store
//
//  Created by Rain Moustfa on 10/06/2022.
//

import Foundation
import RxSwift

protocol OrdersProvider: AnyObject {
    func getOrderList(with customerId: Int) -> Observable<CustomerOrdersList>
    func postDraftOrder(order: DraftOrdersRequest) -> Observable<DraftOrderResponseTest>
    func modifyExistingOrder(with orderId: Int, and putOrderRequest: PutOrderRequest) -> Observable<DraftOrderResponseTest>
    func deleteExistingOrder(with orderId: Int) -> Observable<EmptyObject>
    func postOrder(order: PostOrderRequest)-> Observable<PostOrderResponseTest>
}

class OrdersClient: OrdersProvider {
    func getOrderList(with customerId: Int) -> Observable<CustomerOrdersList> {
        NetworkService().execute(OrdersAPI.getCustomerOrders(customerId))
    }
    
    func postOrder(order: PostOrderRequest)-> Observable<PostOrderResponseTest> {
        NetworkService().execute(OrdersAPI.postOrder(order))
    }
    
    func deleteExistingOrder(with orderId: Int) -> Observable<EmptyObject> {
        NetworkService().execute(OrdersAPI.deleteDraftOrder(orderId))
    }
    
    func modifyExistingOrder(with orderId: Int, and putOrderRequest: PutOrderRequest) -> Observable<DraftOrderResponseTest> {
        NetworkService().execute(OrdersAPI.modifyExistingOrder(orderId, putOrderRequest))
    }
    
    func postDraftOrder(order: DraftOrdersRequest)  -> Observable<DraftOrderResponseTest>{
        NetworkService().execute(OrdersAPI.postDraftOrder(order))
    }
    
}
