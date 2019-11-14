/*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*/

var customerLetterCaseHandler = ['ModelEvent', function(ModelEvent){
    var handlerBefore = function($q, customer){
        var deferred = $q.defer();

        function capitalize(str){
            return str.charAt(0).toUpperCase() + str.slice(1);
        }

        //ensure first and last names are Letter Cased 
        customer.first_name = capitalize(customer.first_name);
        customer.last_name = capitalize(customer.last_name);

        //resolve the deferred operation
        deferred.resolve();

        //return the deferred promise
        return deferred.promise;
    };

    var listener = ModelEvent.addListener('customer', ['onBeforeSave', 'onBeforeInsert'], handlerBefore);
}]

ConfigurationManager.addHandler(customerLetterCaseHandler);

