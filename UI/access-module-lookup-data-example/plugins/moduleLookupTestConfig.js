/*
Copyright © 2020 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*/

SideButtonsManager.addButton({
    label: 'Inventory Grid Data',
    icon: 'images/checked_32.png',
    sections: ['inventory2.lookup'], //Other Supported areas - 'vendor2.lookup','dcs.lookup','employee.lookup','groups.lookup','customer.lookup'
    handler: [
      'ModuleLookupData','$uibModal',
      function(ModuleLookupData,$uibModal) {
        'use strict';

        var selectedItems = ModuleLookupData.GetSelectedItems();
        console.log(selectedItems);

        var modalInstance = $uibModal.open({
            animation: true,
            keyboard: false,
            backdrop: 'static',
            template:
            `<div class="panel panel-default">
                <div class="panel-heading">
                    <h3>Inventory</h3>
                </div>
                <div class="panel-body" style="padding: 1em;">
                    <h4>Selected item list from grid :-</h4>
                    <hr/>
                    <table class="table col-xs-12 table-bordered table-reponsive table-centered">
                        <thead>
                        <tr>
                            <th>UPC</th>
                            <th>Description 1</th>
                            <th>Store Qty</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr ng-repeat="item in $ctrl.selectedInventoryItems">
                            <td>{{item.upc}}</td>
                            <td>{{item.description1}}</td>
                            <td>{{item.actstrohqty}}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel-footer">
                    <div class="row">
                    <div class="col-xs-12">
                        <div class="pull-right">
                            <button
                                class="btn btn-lg btn-default"
                                style="border-radius: 0.4em;"
                                type="button"
                                data-translate="907"
                                ng-click="$ctrl.dismiss()"
                            >
                                Close
                            </button>
                        </div>
                    </div>
                    </div>
                </div>
            </div>`,
            controller: ['selectedInventoryItems', function (selectedInventoryItems) {
                var $ctrl = this;
                $ctrl.selectedInventoryItems = selectedInventoryItems;
                $ctrl.close = modalInstance.close;
                $ctrl.dismiss = modalInstance.dismiss;
              },
            ],
            controllerAs: '$ctrl',
            resolve: {
              selectedInventoryItems: function () {
                return selectedItems;
              },
            },
          });
    
          modalInstance.result.then(
            function () {
              //function called after modal close
            },
            function () {
              //function called after modal dismiss
            }
          );
      }
    ]
  });