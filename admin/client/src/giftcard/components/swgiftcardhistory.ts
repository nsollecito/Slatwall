<div class="col-xs-12">
	<div class="s-detail-body">
		<h2>History & Orders</h2>
		<div class="row">
			<div class="col-xs-3 s-detail-info">
				<p>This timeline provides details on all actions that have taken place on this gift card.</p>
			</div>
			<div class="col-xs-9 s-detail-header-table">

				<div class="responsive-table">
					<table ng-class="{'s-more-results': swGiftCardHistory.transactions.length > 10}" class="table">
						<thead>
							<tr>
								<th></th>
								<th>Type <i class="fa fa-sort"></i></th>
								<th>Date <i class="fa fa-sort"></i></th>
								<th>Info</th>
								<th>Transaction</th>
								<th>Balance</th>
							</tr>
						</thead>
						<tbody class="s-status-table">
							<tr ng-class="{'s-purchase':transaction.debit, 's-success':transaction.activated, 's-error':transaction.bouncedEmail}" ng-repeat="transaction in swGiftCardHistory.transactions">
								<!-- Initial Transactions -->
								<td ng-if-start="$index==swGiftCardHistory.transactions.length-1" class="s-status"><i class="fa fa-plus"></i></td>
								<td>Card Purchased </td>
								<td ng-bind="swGiftCardHistory.order.orderOpenDateTime"></td>
								<td>Customer: <a href="?slatAction=admin:entity.detailAccount&accountID={{swGiftCardHistory.order.account_accountID}}"><span ng-bind="swGiftCardHistory.order.account_firstName"></span> <span ng-bind="swGiftCardHistory.order.account_lastName"></span> (<span ng-bind="swGiftCardHistory.order.account_primaryEmailAddress_emailAddress"></span>)</a></td>
								<td>
									+ <span class="s-bold" ng-bind-html="transaction.creditAmount | swcurrency:swGiftCardHistory.giftCard.currencyCode"></span>
								</td>
								<td ng-if-end>
									<span class="s-bold" ng-bind-html="transaction.creditAmount | swcurrency:swGiftCardHistory.giftCard.currencyCode"></span>
								</td>
								
								<!-- Notification Email -->
								<td ng-if-start="transaction.bouncedEmail" class="s-status"><i class="fa fa-envelope"></i></td>
								<td>Recipient Email Failure </td>
								<td ng-bind="transaction.rejectedEmailSendTime"></td>
								<td>Recipient: 
									<span ng-bind="swGiftCardHistory.giftCard.orderItemGiftRecipient_firstName"></span> <span ng-bind="swGiftCardHistory.giftCard.orderItemGiftRecipient_lastName"></span> ( <span ng-bind="swGiftCardHistory.giftCard.orderItemGiftRecipient_emailAddress"></span> )
								</td>
								<td>--</td>
								<td class="s-bold" ng-if-end ng-bind-html="transaction.balance | swcurrency:swGiftCardHistory.giftCard.currencyCode"></td>
								
								<!-- Notification Email -->
								<td ng-if-start="transaction.emailSent" class="s-status"><i class="fa fa-envelope"></i></td>
								<td>Recipient notification sent </td>
								<td ng-bind="transaction.sentAt"></td>
								<td>Recipient: 
									<span ng-bind="swGiftCardHistory.giftCard.orderItemGiftRecipient_firstName"></span> ( <span ng-bind="transaction.emailTo"></span> )
								</td>
								<td>--</td>
								<td class="s-bold" ng-if-end ng-bind-html="transaction.balance | swcurrency:swGiftCardHistory.giftCard.currencyCode"></td>
								
								<!-- Activated -->
								<td ng-if-start="transaction.activated" class="s-status"><i class="fa fa-check"></i></td>
								<td>Card Activated</td>
								<td ng-bind="transaction.activeAt"></td>
								<td></td>
								<td>--</td>
								<td class="s-bold" ng-if-end ng-bind-html="transaction.balance | swcurrency:swGiftCardHistory.giftCard.currencyCode"></td>
							
								<!-- All Other Transactions -->
								<td ng-if-start="$index!=swGiftCardHistory.transactions.length-1 && !transaction.emailSent && !transaction.activated && !transaction.bouncedEmail" class="s-status"><i class="fa fa-shopping-cart"></i></td>
								<td ng-if-end>
									<span ng-if="transaction.debit">Purchase Applied</span>
									<span ng-if="!transaction.debit">Return Applied</span> 
								</td>
								<td ng-if-start="$index!=swGiftCardHistory.transactions.length-1 && !transaction.emailSent && !transaction.activated  && !transaction.bouncedEmail" ng-bind="transaction.orderPayment_order_orderOpenDateTime"></td>
								<td>Order: 
									<a href="{{transaction.detailOrderLink}}">
										<span ng-bind="transaction.orderPayment_order_orderNumber"></span>
									</a>
								</td>
								<td>
									<span class="s-bold" ng-if-start="!transaction.debit && !transaction.emailSent && !transaction.activated  && !transaction.bouncedEmail">+</span>
									<span class="s-bold" ng-if-end ng-bind-html="transaction.creditAmount | swcurrency:swGiftCardHistory.giftCard.currencyCode"></span>
									<span class="s-bold" ng-if-start="transaction.debit && !transaction.emailSent && !transaction.activated  && !transaction.bouncedEmail">-</span>
									<span class="s-bold" ng-if-end ng-bind-html="transaction.debitAmount | swcurrency:swGiftCardHistory.giftCard.currencyCode"></span>
								</td>
								<td class="s-bold" ng-if-end ng-bind-html="transaction.balance | swcurrency:swGiftCardHistory.giftCard.currencyCode"></td>
							</tr>
							<!--
							<tr class="s-purchase">
								<td><i class="fa fa-shopping-cart"></i></td>
								<td>Purchase Applied </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Order: <a href="##">263546</a></td>
								<td>-$51.03</td>
								<td>$248.97</td>
							</tr>
							<tr class="s-success">
								<td><i class="fa fa-check"></i></td>
								<td>Card Activated</td>
								<td>July 8, 2015 - 11:43 am</td>
								<td></td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr class="s-notify">
								<td><i class="fa fa-times"></i></td>
								<td>Card Deactivated </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td></td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr>
								<td><i class="fa fa-user-plus"></i></td>
								<td>Card Assigned</td>
								<td>July 8, 2015 - 11:43 am</td>
								<td></td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr>
								<td><i class="fa fa-envelope"></i></td>
								<td>Recipient Email Opened</td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Recipient: Bob Smith (bobsmith@gmail.com)</td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr class="s-error">
								<td><i class="fa fa-envelope"></i></td>
								<td>Recipient Email Failure </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Recipient: John Smith (johnsmith@gmail.com)</td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr>
								<td><i class="fa fa-envelope"></i></td>
								<td>Recipient email updated </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Recipient: John Smith (johnsmith@gmail.com)</td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr>
								<td><i class="fa fa-envelope"></i></td>
								<td>Recipient notification resent </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Recipient: John Smith (johnsmith@gmail.com)</td>
								<td>--</td>
								<td>$300.00</td>
							</tr>
							<tr>
								<td><i class="fa fa-plus"></i></td>
								<td>Card Purchased </td>
								<td>July 8, 2015 - 11:43 am</td>
								<td>Customer: <a href="##">John Smith (johnsmith@gmail.com)</a></td>
								<td>+$300.00</td>
								<td>$300.00</td>
							</tr>
							-->
						</tbody>
					</table>
					<div class="s-load-more-wrapper" ng-hide="swGiftCardHistory.transactions.length < 10">
						<button type="button" name="button" class="btn btn-default btn-sm s-load-more">Load More <span>(showing 10 of <span ng-bind="swGiftCardHistory.transactions.length"></span>)</span></button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
