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
  cAppName = 'Sample Project';

// ######################################################################################################################################
//  XML Service Description - Change As Needed
// ######################################################################################################################################

  cServiceXML =
    '<MODULE>'+
    '  <URIVERSION>1</URIVERSION>'+
    '  <DESCRIPTION>Sample Module</DESCRIPTION>'+
    '  <VERSION>0.0.0.0</VERSION>'+
    '  <NAME>SampleModule</NAME>'+
    '  <RESOURCES>'+
    '    <RESOURCE>'+
    '      <NAME>ResourceA</NAME>'+
    '      <RESOURCES>'+
    '        <RESOURCE>'+
    '          <NAME>ResourceA1</NAME>'+
    '          <RESOURCES/>'+
    '        </RESOURCE>'+
    '      </RESOURCES>'+
    '    </RESOURCE>'+
    '    <RESOURCE>'+
    '      <NAME>ResourceB</NAME>'+
    '      <RESOURCES/>'+
    '    </RESOURCE>'+
    '  </RESOURCES>'+
    '  <METHODS>'+
    '    <METHOD>'+
    '      <NAME>SampleMethodA</NAME>'+
    '    </METHOD>'+
    '    <METHOD>'+
    '      <NAME>SampleMethodB</NAME>'+
    '    </METHOD>'+
    '  </METHODS>'+
    '</MODULE>';

// ######################################################################################################################################
//  JSON Service Description - Change As Needed
// ######################################################################################################################################

  cServiceJSON =
    '  {'+
    '    "uriversion" : "1",'+
    '    "description" : "Sample Module",'+
    '    "version" : "0.0.0.0",'+
    '    "name" : "SampleModule",'+
    '    "resources" : ['+
    '      {'+
    '        "name" : "ResourceA",'+
    '        "resources" : ['+
    '          {'+
    '            "name" : "ResouurceA1",'+
    '            "resources" : ['+
    '            ]'+
    '          }'+
    '        ]'+
    '      },'+
    '      {'+
    '        "name" : "ResourceB",'+
    '        "resources" : ['+
    '        ]'+
    '      }'+
    '    ],'+
    '    "methods" : ['+
    '      {'+
    '        "name" : "SampleMethodA"'+
    '      },'+
    '      {'+
    '        "name" : "SampleMethodB"'+
    '      }'+
    '     ]'+
    '  }';

implementation

end.
