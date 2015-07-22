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
component displayname="Gift Card" entityname="SlatwallGiftCard" table="SwGiftCard" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="giftCardService" {

	// Persistent Properties
	property name="giftCardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="giftCardCode" ormtype="string";
	property name="giftCardPin" ormtype="string";
	property name="expirationDate" ormtype="timestamp";
	property name="ownerFirstName" ormtype="string";
	property name="ownerLastName" ormtype="string";
	property name="ownerEmailAddress" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="originalOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="originalOrderItemID";
	property name="giftCardExpirationTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="giftCardExpirationTermID";
	property name="ownerAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="ownerAccountID";

	// Related Object Properties (one-to-many)
	property name="giftCardTransactions" singularname="giftCardTransaction" cfc="GiftCardTransaction" fieldtype="one-to-many" fkcolumn="giftCardID" inverse="true" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties




	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order Item (many-to-one)
	public void function setOriginalOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasGiftCard( this )) {
			arrayAppend(arguments.orderItem.getGiftCards(), this);
		}
	}
	public void function removeOriginalOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getGiftCards(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getGiftCards(), index);
		}
		structDelete(variables, "orderItem");
	}

	// Gift Card Expiration Term (many-to-one)
	public void function setGiftCardExpirationTerm(required any giftCardExpirationTerm) {
		variables.giftCardExpirationTerm = arguments.giftCardExpirationTerm;
		if(isNew() or !arguments.giftCardExpirationTerm.hasGiftCard( this )) {
			arrayAppend(arguments.giftCardExpirationTerm.getGiftCards(), this);
		}
	}
	public void function removeGiftCardExpirationTerm(any giftCardExpirationTerm) {
		if(!structKeyExists(arguments, "giftCardExpirationTerm")) {
			arguments.giftCardExpirationTerm = variables.giftCardExpirationTerm;
		}
		var index = arrayFind(arguments.giftCardExpirationTerm.getGiftCards(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.giftCardExpirationTerm.getGiftCards(), index);
		}
		structDelete(variables, "giftCardExpirationTerm");
	}

	// Gift Card Transactions (one-to-many)
	public void function addGiftCardTransaction(required any giftCardTransaction){
		arguments.giftCardTransaction.setGiftCard( this );
	}

	public void function removeGiftCardTransaction(required any giftCardTransaction){
		arguments.giftCardTransaction.removeGiftCard( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
