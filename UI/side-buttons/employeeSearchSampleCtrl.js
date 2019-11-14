/*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*/

 var employeeSearchSample = ['$scope', '$modalInstance', 'ModelService',
    function ($scope, $modalInstance, ModelService) {
        'use strict';
        $scope.criteria = {};

        $scope.search = function(){
            var filter = 'full_name,lk,' + $scope.criteria.searchText + '*';
            ModelService.get('Employee', { filter: filter })
                .then(function(employees){
                    $scope.employees = employees;
                });
        };
    }
];


window.angular.module('prismPluginsSample.controller.employeeSearchSampleCtrl', [])
    .controller('employeeSearchSampleCtrl', employeeSearchSample);