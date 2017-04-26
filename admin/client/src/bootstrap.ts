/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import { AppModule } from './app/app.module';
import { UpgradeModule } from '@angular/upgrade/static';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';


import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";



//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication:any;
    constructor(){
        super(slatwalladminmodule.name);

        //angular.bootstrap(document,[slatwalladminmodule.name])
        platformBrowserDynamic().bootstrapModule(AppModule).then(platformRef => {
            const upgrade = platformRef.injector.get(UpgradeModule) as UpgradeModule;
            upgrade.bootstrap(document.body, [slatwalladminmodule.name], {strictDi: true});
        });
    }

}

export = new bootstrapper();

