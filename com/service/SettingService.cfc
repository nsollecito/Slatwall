/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" output="false" accessors="true"  {
	
	// Mura Service Injection on Init
	property name="configBean" type="any";
	property name="contentManager" type="any";
	property name="categoryManager" type="any";
	property name="feedManager" type="any";
	
	// Global Properties Set in Application Scope
	
	property name="settings" type="struct";
	property name="permissions" type="struct";
	property name="shippingMethods" type="struct";
	property name="shippingServices" type="struct";
	property name="paymentMethods" type="struct";
	property name="paymentServices" type="struct";
	property name="permissionActions" type="struct";
	
	public any function init() {
		setConfigBean( getCMSBean("configBean") );
		setContentManager( getCMSBean("contentManager") );
		setCategoryManager( getCMSBean("categoryManager") );
		setFeedManager( getCMSBean("feedManager") );
		
		return super.init();
	}
		
	public void function reloadConfiguration() {
		var settingsList = this.listSetting();
		
		variables.permissions = {};
		variables.settings = {};
		variables.shippingServices = {};
		variables.paymentServices = {};
		
		getPermissionActions();
		getShippingServices();
		getPaymentServices();
		
		// Load Settings & Permissions
		for(var i = 1; i <= arrayLen(settingsList); i++) {
			
			if( listFirst( settingsList[i].getSettingName(), "_") == "permission") {
				// Set the permission value in the permissions scop 
				variables.permissions[ settingsList[i].getSettingName() ] = settingsList[i];
			} else {
				// Set the global setting value in the settings scope
				variables.settings[ settingsList[i].getSettingName() ] = settingsList[i];	
			}
		}
		
	}
	
	public struct function getSettings(boolean reload=false) {
		if(!structKeyExists(variables, "settings") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.settings;
	}
	
	public struct function getPermissions(boolean reload=false) {
		if(!structKeyExists(variables, "permissions") || arguments.reload == true) {
			reloadConfiguration();
		}
		return variables.permissions;
	}
	
	public any function getSettingValue(required string settingName) {
		if( structKeyExists(variables.settings,arguments.settingName) ) {
			return variables.settings[ arguments.settingName ].getSettingValue();
		} else {
			return "";
		}	
	}
	
	public any function getPermissionValue(required string permissionName) {
		if(structKeyExists(variables.permissions, arguments.permissionName)) {
			return variables.permissions[ arguments.permissionName ].getSettingValue();
		} else {
			return "";
		}
	}
	
	public any function getBySettingName(required string settingName) {
		if(structKeyExists(variables.settings, arguments.settingName)) {
			return variables.settings[ arguments.settingName ];
		} else {
			var setting = this.newSetting();
			setting.setSettingName(arguments.settingName);
			return	setting;
		}
	}
	
	public any function getByPermissionName(required string permissionName) {
		if(structKeyExists(variables.permissions, arguments.permissionName)) {
			return variables.permissions[ arguments.permissionName ];
		} else {
			return this.newSetting();	
		}
	}
	
	public struct function getPermissionActions(boolean reload=false) {
		if(!structKeyExists(variables, "permissionActions") || !structCount(variables.permissionActions) || arguments.reload) {
			variables.permissionActions = structNew();
			var dirLocation = expandPath("/plugins/Slatwall/admin/controllers");
			var dirList = directoryList(dirLocation,"false","name","*.cfc");
			for(var i=1; i<= arrayLen(dirList); i++) {
				var controllerName = Replace(listGetAt(dirList[i],listLen(dirList[i],"\/"),"\/"),".cfc","");
				var controller = createObject("component", "Slatwall.admin.controllers.#controllerName#");
				var controllerMetaData = getMetaData(controller);
				if(controllerName != "BaseController") {
					variables.permissionActions[ "#controllerName#" ] = arrayNew(1);
					for(var ii=1; ii <= arrayLen(controllerMetaData.functions); ii++) {
						if(FindNoCase("before", controllerMetaData.functions[ii].name) == 0 && FindNoCase("service", controllerMetaData.functions[ii].name) == 0 && FindNoCase("get", controllerMetaData.functions[ii].name) == 0 && FindNoCase("set", controllerMetaData.functions[ii].name) == 0 && FindNoCase("init", controllerMetaData.functions[ii].name) == 0 && FindNoCase("dashboard", controllerMetaData.functions[ii].name) == 0) {
							arrayAppend(variables.permissionActions[ "#controllerName#" ], controllerMetaData.functions[ii].name);
						}
					}
					arraySort(variables.permissionActions[ "#controllerName#" ], "textnocase", "asc" );
				}
			}
		}
		return variables.permissionActions;
	}

	public any function saveAddressZone(required any entity, struct data) {
		if( structKeyExists(arguments, "data") && structKeyExists(arguments.data,"addressZoneLocations") ) {
			for(var i in arguments.data.addressZoneLocations) {
				if(left(i,3) == "new" && len(i) >= 4) {
					var addressZoneLocation = newAddressZoneLocation();
					addressZoneLocation.populate(arguments.data.addressZoneLocations[i]);
					addressZoneLocation.setAddressZone(arguments.entity);
					arguments.entity.addAddressZoneLocation(addressZoneLocation);
				} else {
					var addressZoneLocation = this.getAddressZoneLocation(i);
					if(!isNull(addressZoneLocation)) {
						addressZoneLocation.populate(arguments.data.addressZoneLocations[i]);
						addressZoneLocation.setAddressZone(arguments.entity);
						arguments.entity.addAddressZoneLocation(addressZoneLocation);	
					}
				}
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public struct function getMailServerSettings() {
		var config = getConfigBean();
		var settings = {};
		if(!config.getUseDefaultSMTPServer()) {
			settings = {
				server = config.getMailServerIP(),
				username = config.getMailServerUsername(),
				password = config.getMailServerPassword(),
				port = config.getMailServerSMTPPort(),
				useSSL = config.getMailServerSSL(),
				useTLS = config.getMailServerTLS()
			};
		}
		return settings;
	}
	
	public array function getMeaurementUnitOptions(required string measurementType) {
		var smartList = this.getMeasurementUnitSmartList();
		smartList.addFilter("measurementType", arguments.measurementType);
		
		smartList.addSelect("unitCode", "value");
		smartList.addSelect("unitName", "name");
		
		
		return smartList.getRecords();
	}
	
	// -------------- Start Mura Setup Functions
	public any function verifyMuraRequirements() {
		logSlatwall("Setting Service - verifyMuraRequirements - Started", true);
		verifyMuraRequiredPages();
		verifyMuraFrontendViews();
		pullMuraCategory();
		logSlatwall("Setting Service - verifyMuraRequirements - Finished", true);
	}
	
	private void function verifyMuraFrontendViews() {
		logSlatwall("Setting Service - verifyMuraFrontendViews - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Verify Mura Frontend Views For Site ID: #assignedSites["siteID"][i]#");
			
			var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
			var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#assignedSites["siteID"][i]#/includes/display_objects/custom/slatwall/"));
			
			getService("utilityFileService").duplicateDirectory(baseSlatwallPath,baseSitePath,false,true,".svn");
		}
		logSlatwall("Setting Service - verifyMuraFrontendViews - Finished", true);
	}

	private void function verifyMuraRequiredPages() {
		logSlatwall("Setting Service - verifyMuraRequiredPages - Started", true);
		
		var requiredMuraPages = [
			{settingName="page_shoppingCart",title="Shopping Cart",fileName="shopping-cart",isNav="1",isLocked="1"},
			{settingName="page_orderStatus",title="Order Status",fileName="order-status",isNav="1",isLocked="1"},
			{settingName="page_orderConfirmation",title="Order Confirmation",fileName="order-confirmation",isNav="0",isLocked="1"},
			{settingName="page_myAccount",title="My Account",fileName="my-account",isNav="1",isLocked="1"},
			{settingName="page_editAccount",title="Edit Account",fileName="edit-account",isNav="1",isLocked="1"},
			{settingName="page_createAccount",title="Create Account",fileName="create-account",isNav="1",isLocked="1"},
			{settingName="page_checkout",title="Checkout",fileName="checkout",isNav="1",isLocked="1"},
			{title="Default Product Template",fileName="default-product-template",isNav="0",isLocked="0",templateFlag="1"}
		];
		
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Verify Mura Required Pages For Site ID: #assignedSites["siteID"][i]#", true);
			var thisSiteID = assignedSites["siteID"][i];
			
			for(var page in requiredMuraPages) {
				if(structKeyExists(page,"settingName")) {
					createMuraPageAndSetting(page,thisSiteID);
				} else {
					var muraPage = createMuraPage(page,thisSiteID);
					createSlatwallPage(muraPage,page);
				}
			}
		}
		logSlatwall("Setting Service - verifyMuraRequiredPages - Finished", true);
	}
	
	private void function createMuraPageAndSetting(required struct page,required any siteID) {
		var setting = getBySettingName(arguments.page.settingName);
		if(setting.isNew() || setting.getSettingValue() == ""){
			var muraPage = createMuraPage(arguments.page,arguments.siteID);
			setting.setSettingValue(arguments.page.fileName);
			this.saveSetting(setting);
		}
	}
	
	private any function createMuraPage(required struct page,required any siteID) {
		// Setup Mura Page
		var thisPage = getContentManager().getActiveContentByFilename(filename=arguments.page.fileName, siteid=arguments.siteID);
		if(thisPage.getIsNew()) {
			thisPage.setDisplayTitle(arguments.page.title);
			thisPage.setHTMLTitle(arguments.page.title);
			thisPage.setMenuTitle(arguments.page.title);
			thisPage.setIsNav(arguments.page.isNav);
			thisPage.setActive(1);
			thisPage.setApproved(1);
			thisPage.setIsLocked(arguments.page.isLocked);
			thisPage.setParentID("00000000000000000000000000000000001");
			thisPage.setFilename(arguments.page.fileName);
			thisPage.setSiteID(arguments.siteID);
			thisPage.save();
		}
		return thisPage;
	}
	
	private void function createSlatwallPage(required any muraPage, required struct pageAttributes) {
		var thisPage = getService("contentService").getcontentByCmsContentID(arguments.muraPage.getContentID(),true);
		if(thisPage.isNew()){
			thisPage.setCmsSiteID(arguments.muraPage.getSiteID());
			thisPage.setCmsContentID(arguments.muraPage.getContentID());
			thisPage.setCmsContentIDPath(arguments.muraPage.getPath());
			thisPage.setTitle(arguments.muraPage.getTitle());
			thisPage = getService("contentService").saveContent(thisPage,arguments.pageAttributes);
		}
	}
	
	private void function pullMuraCategory() {
		logSlatwall("Setting Service - pullMuraCategory - Started", true);
		var assignedSites = getPluginConfig().getAssignedSites();
		for( var i=1; i<=assignedSites.recordCount; i++ ) {
			logSlatwall("Pull mura category For Site ID: #assignedSites["siteID"][i]#");
			
			var categoryQuery = getCategoryManager().getCategoriesBySiteID(siteID=assignedSites["siteID"][i]);
			for(var j=1; j<=categoryQuery.recordcount; j++) {
				var category = getService("contentService").getCategoryByCmsCategoryID(categoryQuery.categoryID[j],true);
				if(category.isNew()){
					category.setCmsSiteID(categoryQuery.siteID[j]);
					category.setCmsCategoryID(categoryQuery.categoryID[j]);
					category.setCmsCategoryIDPath(categoryQuery.path[j]);
					category.setCategoryName(categoryQuery.name[j]);
					category = getService("contentService").saveCategory(category);
				}
			}
		}
		logSlatwall("Setting Service - pullMuraCategory - Finished", true);
	}


}
