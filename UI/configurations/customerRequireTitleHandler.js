/*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*/

var customerRequireTitleHandler = ['ModelEvent', 'NotificationService', function(ModelEvent, NotificationService){
    var handlerBefore = function($q, customer){
        var deferred = $q.defer();

        if(!customer.title_sid){
            NotificationService.addAlert('You must select a title for the customer.', 'Customer Title Required');
            deferred.reject();
        }
        else{
            deferred.resolve();    
        }
        
        //return the deferred promise
        return deferred.promise;
    };

    var listener = ModelEvent.addListener('customer', ['onBeforeSave', 'onBeforeInsert'], handlerBefore);
}]

ConfigurationManager.addHandler(customerRequireTitleHandler);