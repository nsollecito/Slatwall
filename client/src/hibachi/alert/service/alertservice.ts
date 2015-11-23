/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

//import Alert = require('../model/alert');
import {Alert} from "../model/alert";

interface IAlertService {
    get ():Alert[];
    addAlert (alert:Alert):void;
    addAlerts (alerts:Alert[]):void;
    removeAlert (alert:Alert):void;
    getAlerts ():Alert[];
    formatMessagesToAlerts (messages):Alert[];
    removeOldestAlert ():void;
    newAlert ():Alert;
}

class AlertService implements IAlertService{
    public static $inject = [
        '$timeout'
    ];
    
    constructor(
        private $timeout: ng.ITimeoutService,
        public alerts:Alert[]
    ) {
        this.alerts = [];
    }
    
    newAlert = ():Alert =>{
        return new Alert();
    }
    
    get = ():Alert[] =>{
        return this.alerts || [];
    }
    
    addAlert = (alert:Alert):void =>{
        
        this.alerts.push(alert);
        this.$timeout((alert)=> {
            this.removeAlert(alert);
        }, 3500);
    }
    
    addAlerts = (alerts:Alert[]):void =>{
      
        alerts.forEach(alert => {
            this.addAlert(alert);
        });
    }
    
    removeAlert = (alert:Alert):void =>{
        var index:number = this.alerts.indexOf(alert, 0);
        if (index != undefined) {
            this.alerts.splice(index, 1);
        }
    }
    
    getAlerts = ():Alert[] =>{
        return this.alerts;
    }		
    
    formatMessagesToAlerts = (messages):Alert[] =>{
        var alerts = [];
        if(messages){
            for(var message in messages){
                var alert = new alert.Alert();
                alert.msg=messages[message].message;
                alert.type=messages[message].messageType;
                
                alerts.push(alert);
                if(alert.type === 'success' || alert.type === 'error'){
                        this.$timeout(function() {
                        alert.fade = true;
                    }, 3500);
                    
                    alert.dismissable = false;
                    
                }else{
                    alert.fade = false;
                    alert.dismissable = true;
                }
            }
        }
        return alerts;
    }
    
    removeOldestAlert = ():void =>{
        this.alerts.splice(0,1);
    }
}  
export{
  AlertService,
  IAlertService  
};

    
        
    
        
