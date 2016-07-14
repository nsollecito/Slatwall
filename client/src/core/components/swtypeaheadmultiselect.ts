/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWTypeaheadMultiselectController {
      
    public selections:any[];
    public showSelections:boolean; 
    public singleSelection:any;
    public dataTarget:any; 
    public dataTargetIndex:number; 
    public placeholderRbKey:string;
    public typeaheadDataKey:string; 
    public multiselectMode:boolean;
    public collectionConfig:any; 
    public addButtonFunction; 
    public hasAddButtonFunction:boolean;
    public viewFunction;
    public hasViewFunction:boolean;
      
    // @ngInject
	constructor(private $scope, 
                private $transclude, 
                private $hibachi, 
                private typeaheadService,
                private utilityService, 
                private collectionConfigService
    ){
        //supporting the original selection view
        if(angular.isUndefined(this.showSelections)){
            this.showSelections = false; 
        }
        if(angular.isUndefined(this.multiselectMode)){
            this.multiselectMode = true; 
        }
        if(angular.isUndefined(this.typeaheadDataKey)){
            this.typeaheadDataKey = this.utilityService.createID(32); 
        }
        if(angular.isUndefined(this.hasAddButtonFunction)){
            this.hasAddButtonFunction = false; 
        }
        if(angular.isUndefined(this.hasViewFunction)){
            this.hasViewFunction = false; 
        }
    }
    
    //do these need to be passed in? 
    public addSelection = (item) => {
        this.typeaheadService.addSelection(this.typeaheadDataKey, item);
    }
    
    public removeSelection = (index) => {
        this.typeaheadService.removeSelection(this.typeaheadDataKey, index);
    }
    
    public getSelections = () =>{
        return this.typeaheadService.getData(this.typeaheadDataKey);
    }
}

class SWTypeaheadMultiselect implements ng.IDirective{

	public templateUrl;
    public transclude=true; 
	public restrict = "EA";
	public scope = {};

	public bindToController = {
        placeholderRbKey:"@"
        ,collectionConfig:"=?"
        ,typeaheadDataKey:"@?"
        ,multiselectModeOn:"=?multiselectMode"
        ,showSelections:"=?"
        ,dataTarget:"=?"
        ,dataTargetIndex:"=?"
        ,addButtonFunction:"&?" 
        ,viewFunction:"&?"
	};
    
	public controller=SWTypeaheadMultiselectController;
	public controllerAs="swTypeaheadMultiselect";

    // @ngInject
	constructor(public $compile, public typeaheadService, private corePartialsPath,hibachiPathBuilder){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadmultiselect.html";
	}

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
            $compile
            ,typeaheadService
			,corePartialsPath
            ,hibachiPathBuilder

		)=> new SWTypeaheadMultiselect(
            $compile
            ,typeaheadService
            ,corePartialsPath
            ,hibachiPathBuilder
		);
		directive.$inject = ["$compile","typeaheadService","corePartialsPath",'hibachiPathBuilder'];
		return directive;
	}
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: any) => {
                //because callbacks are defined even when they're not passed in, this needs to be communicated to the typeahead
                if(angular.isDefined(attrs.addButtonFunction)){
                    $scope.swTypeaheadMultiselect.hasAddButtonFunction = true;  
                } else {
                    $scope.swTypeaheadMultiselect.hasAddButtonFunction = false; 
                }
                
                if(angular.isDefined(attrs.viewFunction)){
                    $scope.swTypeaheadMultiselect.viewFunction = true;  
                } else {
                    $scope.swTypeaheadMultiselect.viewFunction = false; 
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
				var target = element.find(".s-selected-list");
                var selectedItemTemplate  = angular.element('<div class="alert s-selected-item" ng-repeat="item in swTypeaheadMultiselect.getSelections() track by $index">');
                var closeButton = angular.element('<button ng-click="swTypeaheadMultiselect.removeSelection($index)" type="button" class="close"><span>×</span><span class="sr-only" sw-rbkey="&apos;define.close&apos;"></span></button>'); 
				
               selectedItemTemplate.append(closeButton);
               selectedItemTemplate.append(this.typeaheadService.stripTranscludedContent(transclude($scope,()=>{})));
               target.append(this.$compile(selectedItemTemplate)($scope));               
            }
        };
    }
}
export{
	SWTypeaheadMultiselect,
	SWTypeaheadMultiselectController
}
