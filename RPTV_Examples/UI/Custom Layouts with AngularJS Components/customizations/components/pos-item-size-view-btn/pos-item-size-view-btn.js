window.angular.module('prismApp')
    .component('posItemSizeViewBtn', {
        templateUrl:'components/pos-item-size-view-btn/pos-item-size-view-btn.htm',
        bindings: {
            selectedItem: '<',
        },
        controllerAs:'posItemSizeViewBtnCtrl',
        controller:['$uibModal',function($uibModal){
            'use strict';
            var me = this;

            me.viewItemSizes = function(){
              if(me.selectedItem.item_size.length>0){
                console.log('Show avail sizes');
                var modalInstance = $uibModal.open({
                  animation: true,
                  backdrop:'static',
                  component: 'listViewItemSizes',
                  resolve: {
                    styleitem: function () {
                      return me.selectedItem;
                    }
                  }
                });
                modalInstance.result.then(function () {
                  console.log('modal component viewed');
                }, function () {
                  console.log('modal-component dismissed at: ' + new Date());
                });
              }
            };
        }]
    }
);
