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
  cAppName = ''; //Project Name

// ######################################################################################################################################
//  XML Service Description - Change As Needed
// ######################################################################################################################################

  cServiceXML =
    '<MODULE>'+
    '  <URIVERSION></URIVERSION>'+
    '  <DESCRIPTION></DESCRIPTION>'+
    '  <VERSION></VERSION>'+
    '  <NAME></NAME>'+
    '  <RESOURCES>'+
    '    <RESOURCE>'+
    '      <NAME></NAME>'+
    '      <RESOURCES/>'+
    '    </RESOURCE>'+
    '  </RESOURCES>'+
    '  <METHODS>'+
    '    <METHOD>'+
    '      <NAME></NAME>'+
    '    </METHOD>'+
    '  </METHODS>'+
    '</MODULE>';

// ######################################################################################################################################
//  JSON Service Description - Change As Needed
// ######################################################################################################################################

  cServiceJSON =
    '['+
    '  {'+
    '    "uriversion" : "",'+
    '    "description" : "",'+
    '    "version" : "",'+
    '    "name" : "",'+
    '    "resources" : ['+
    '      {'+
    '        "name" : "",'+
    '        "resources" : ['+
    '        ]'+
    '      }'+
    '    ],'+
    '    "methods" : ['+
    '      {'+
    '        "name" : ""'+
    '      }'+
    '     ]'+
    '  }'+
    ']';

implementation

end.
