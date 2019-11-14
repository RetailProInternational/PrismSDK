unit uDescriptionData;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

interface

const
  cAppName = 'ECommerce Link';

// ######################################################################################################################################
//  XML Service Description - Change As Needed
// ######################################################################################################################################

  cServiceXML =
    '<MODULE>'+
    '  <URIVERSION>1</URIVERSION>'+
    '  <DESCRIPTION>ECommerce Module</DESCRIPTION>'+
    '  <VERSION>0.0.0.0</VERSION>'+
    '  <NAME>ECommerceModule</NAME>'+
    '  <RESOURCES>'+
    '    <RESOURCE>'+
    '      <NAME>weborders</NAME>'+
    '      <RESOURCES/>'+
    '    </RESOURCE>'+
    '  </RESOURCES>'+
    '  <METHODS/>'+
    '</MODULE>';

// ######################################################################################################################################
//  JSON Service Description - Change As Needed
// ######################################################################################################################################

  cServiceJSON =
    '  {'+
    '    "uriversion" : "1",'+
    '    "description" : "ECommerce Module",'+
    '    "version" : "0.0.0.0",'+
    '    "name" : "ECommerceModule",'+
    '    "resources" : ['+
    '      {'+
    '        "name" : "weborders",'+
    '        "resources" : ['+
    '        ]'+
    '      }'+
    '    ],'+
    '    "methods" : ['+
    '     ]'+
    '  }';

implementation

end.
