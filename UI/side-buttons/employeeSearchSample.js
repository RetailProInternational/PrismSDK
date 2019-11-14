/*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*/

SideButtonsManager.addButton({
    label: 'Employee Search',
    icon: 'images/checked_32.png',
    sections: ['register', 'transactionRoot', 'transactionEdit'],
    handler: ['$modal', function($modal) {
       
        var modalOptions = {
            backdrop: 'static',
            keyboard: false,
            windowClass: 'full',
            templateUrl: '/plugins/prism-plugins-sample/side-buttons/employeeSearchSample.htm',
            controller: 'employeeSearchSampleCtrl'
        };

        $modal.open(modalOptions);
    }]
});
