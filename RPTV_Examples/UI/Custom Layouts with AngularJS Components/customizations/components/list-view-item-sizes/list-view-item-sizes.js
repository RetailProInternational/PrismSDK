window.angular.module('prismApp')
    .component('listViewItemSizes', {
        templateUrl:'components/list-view-item-sizes/list-view-item-sizes.htm',
        bindings: {
          resolve: '<',
          close: '&'
        },
        controllerAs:'listViewItemSizesCtrl',
        controller:['$http',function($http){
          'use strict';
          var me = this;
          me.$onInit = function() {
            console.log(me.resolve.styleitem);
            var session = JSON.parse(sessionStorage.getItem('session'));
            var url = '/api/backoffice/inventory?action=InventoryGetItems&filter=(active,eq,true)AND(stylesid,eq,'+me.resolve.styleitem.style_sid+')AND(sbssid,eq,'+session.subsidiarysid+')&cols=*&sort=itemsize,asc';
            $http.post(url,{
              'data' : [{
                  ActiveStoreSid: session.storesid,
                  ActivePriceLevelSid: session.preferences.default_price_level_sid
              }]
            }).then(function(data){
              data=data.data.data;
              me.availableItemSizesList = data;
              console.log(me.availableItemSizesList);
            });

          };
          me.handleClose = function() {
            console.log('close modal');
            me.close(me.styleitem);
          };
        }]
    }
);
