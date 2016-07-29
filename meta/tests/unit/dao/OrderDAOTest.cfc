/*
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:
*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();

		variables.dao = request.slatwallScope.getDAO("orderDAO");
		variables.orderMockService = new Slatwall.meta.tests.unit.OrderMockService();
	}

	public void function inst_ok() {
//		assert(verifyOneToManyAssoc(order,orderitems),'failed to associate');
//		assert(isObject(variables.dao));
	}

	//getPeerOrderPaymentNullAmountExistsFlag()
	public void function getPeerOrderPaymentNullAmountExistsFlagTest(){
		var orderTrueData = {
			orderID = '',
			orderPayments=[
				{
					orderPaymentID='',
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf57dcf5bb3eb71614febe83a31d'
					}
				},
				{
					orderPaymentID='',
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf57dcf5bb3eb71614febe83a31d'
					}
				}
			]
		};

		var orderFalseData = {
			orderID = '',
			orderPayments=[
				{
					orderPaymentID='',
					orderPaymentStatusType={
						orderPaymentStatusTypeID = '5accbf58a94b61fe031f854ffb220f4b'
					}
				}
			]
		};

		var order1 = createPersistedTestEntity('order', orderTrueData);
		var order2 = createPersistedTestEntity('order', orderFalseData);

		assertTrue(variables.dao.getPeerOrderPaymentNullAmountExistsFlag(order1.getOrderId(), order1.getOrderPayments()[2].getOrderPaymentID()));
		assertFalse(variables.dao.getPeerOrderPaymentNullAmountExistsFlag(order1.getOrderId(), order1.getOrderPayments()[1].getOrderPaymentID()));
		assertTrue(variables.dao.getPeerOrderPaymentNullAmountExistsFlag(order1.getOrderId()));
		assertFalse(variables.dao.getPeerOrderPaymentNullAmountExistsFlag(order2.getOrderId(), order2.getOrderPayments()[1].getOrderPaymentID()));
	}
	
	
	public void function getPreviouslyReturnedFulfillmentTotalTest() {
		var mockOrderReturn1 = variables.orderMockService.createOrderReturn(100);
		var mockOrderReturn2 = variables.orderMockService.createOrderReturn(10);
		var mockOrderReturn3 = variables.orderMockService.createOrderReturn();
		
		var mockParentOrder = variables.orderMockService.createOrder();
		
		var orderData = {
			orderID = '',
			referencedOrder = {
				orderID = mockParentOrder.getOrderID()
			},
			orderReturns = [
				{
					orderReturnID = mockOrderReturn1.getOrderReturnID()
				},
				{
					orderReturnID = mockOrderReturn2.getOrderReturnID()
				},
				{
					orderReturnID = mockOrderReturn3.getOrderReturnID()
				}
			]
		};
		var mockOrder = createPersistedTestEntity('Order', orderData);
		
		//Testing the orderReturn without fulfillmentReturnAmount
		var result = variables.dao.getPreviouslyReturnedFulfillmentTotal(mockParentOrder.getOrderID());
		assertEquals(110, result);
		
		//Testing the argument
		var resultInvalidArgu = variables.dao.getPreviouslyReturnedFulfillmentTotal('SomeFakeParentORdrID');
		assertEquals(0, resultInvalidArgu);
		
		
	}
	
	public void function test() {
		var siteData = {
			siteID=''
		};
		var mockSite = createPersistedTestEntity('Site', siteData);
		mockOrderReturn1 = variables.orderMockService.createOrder(	
			{
				orderTypeID = '444df2df9f923d6c6fd0942a466e84cc',//otSaleOrder
				orderCreatedSiteID = mockSite.getSiteID()
			}																);
	}


}

