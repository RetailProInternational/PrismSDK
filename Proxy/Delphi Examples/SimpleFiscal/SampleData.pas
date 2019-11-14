unit SampleData;

(*
Copyright © 2017 Retail Pro International, LLC. - All Rights Reserved.

This source code is proprietary and Confidential Information of Retail Pro International, LLC.

Any use of this source code, or any portion thereof, for any purpose whatsoever, is subject to adherence with the 
applicable Retail Pro Development Partner Software License.  All other use or distribution in any format whatsoever, 
is unauthorized and subject to appropriate penalties under applicable law. 

For more information please visit www.retailpro.com or email moreinfo@retailpro.com.
*)

interface

Const
  cCustListX =
  '[{"link":"\/v1\/rest\/customer\/-2974412462265790468","sid":"-2974412462265790468","created_by":"DRS_SYS",'+
  '"created_datetime":"2014-06-26T12:13:42.000-07:00","modified_by":null,"modified_datetime":"2014-06-26T12:26:01.000-07:00",'+
  '"controller_sid":"393212810000008255","origin_application":"RPROV9","post_date":"2015-10-08T04:03:56.000-07:00","row_version":1,'+
  '"tenant_sid":"393212810000189001","subsidiary_sid":"393212811000118255","region_sid":null,"district_sid":null,'+
  '"store_sid":"393212811000163007","company_sid":"393214510000125037","customer_id":1000002,"title":null,'+
  '"last_name":"Rakestraw","first_name":"Randy","suffix":null,"customer_active":true,"marketing_flag":null,"customer_type":0,'+
  '"customer_class_sid":null,"title_sid":null,"suffix_sid":null,"tax_area_sid":null,"tax_area2_sid":null,"credit_limit":0,'+
  '"credit_used":0,"store_credit":0,"accept_checks":true,"check_limit":0,"detax":false,"suggested_discount_percent":0,'+
  '"household_code":null,"mark1":null,"mark2":null,"max_discount_percent":100,"ar_flag":0,"related_customer_sid":null,'+
  '"shipping_priority":null,"primary_clerk_sid":"393212811000121002","first_sale_date":null,"last_sale_date":null,'+
  '"last_sale_amount":0,"webstoreconnect_username":null,"webstoreconnect_password":null,"accounting_system_id":null,'+
  '"udffield01":"Sub1CustUDF3Value 1","udffield02":"Sub1CustUDF4Value 1","udffield03":"Sub1CustUDF5Value 1",'+
  '"udffield04":"Sub1CustUDF6Value 1","udffield05":"Sub1CustUDF7Value 1","udfclob01":null,"udfclob02":null,'+
  '"notes":null,"image":null,"subsidiary_number":1,"addresses":[{"link":"\/v1\/rest\/customer\/-2974412462265790468\/address\/393214636000167023"}],'+
  '"phones":[{"link":"\/v1\/rest\/customer\/-2974412462265790468\/phone\/393214636000178025","phone_no":"916-605-7236"}],'+
  '"subsidiary_name":"001","emails":[{"link":"\/v1\/rest\/customer\/-2974412462265790468\/email\/393214636000174024",'+
  '"email_address":"rrakestraw@retailpro.com"}],"share_type":1,"security_level":1,"price_level_sid":null,"info1":null,"info2":null,'+
  '"employee_as_customer":false,"customer_class_name":null,"district_name":null,"price_level_name":null,"region_name":null,'+
  '"tax_area_name":null,"tax_area2_name":null,"primary_clerk_last_name":null,"primary_clerk_first_name":null,'+
  '"last_order_date":null,"order_item_count":null,"station":null,"ytd_sale":null,"last_return_date":null,'+
  '"total_transactions":null,"sale_item_count":null,"return_item_count":null,"store_name":"Sub1 Str1 Rack #001",'+
  '"store_code":"1s1","primary_phone_no":null,"country_sid":null,"email_address":null,"store_number":"1",'+
  '"allowed_tenders":"TTTTTTTTTTTTTTTTTTTT","country":null,"primary_address_line_1":"777 Lucky Drive",'+
  '"primary_address_line_2":null,"primary_address_line_3":"Folsom CA","primary_address_line_4":null,'+
  '"primary_address_line_5":null,"primary_address_line_6":null,"primary_city":null,"primary_address_type":null,"primary_phone_type":null,'+
  '"primary_email_type":null,"postal_code":"95630","company":"TheCompanyThatMaxAndMiscWorksFor","promo_custlistname":null,'+
  '"from_centrals":0,"extended":[],"full_name":"Randy Rakestraw","primary_country":null,"primary_state":null,"primary_clerk_id":"1",'+
  '"hrefs":{"store_sid":"\/v1\/rest\/store\/393212811000163007","subsidiary_sid":"\/v1\/rest\/subsidiary\/393212811000118255",'+
  '"primary_clerk_sid":"\/v1\/rest\/employee\/393212811000121002","controller_sid":"\/v1\/rest\/controller\/393212810000008255",'+
  '"company_sid":"\/v1\/rest\/company\/393214510000125037"}}]';

  cCustList =
    '['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A11111111111111",'+
    '"sid":"A11111111111111",'+
    '"last_name":"Sample Customer 1",'+
    '"first_name":"Adam",'+
    '"customer_id":820000361,'+
    '"primary_address_line_1":"1 Address Line 1",'+
    '"primary_address_line_2":"1 Address Line 1",'+
    '"full_name":"OnlyAddrIsDefault AddrTestCust",'+
    '"phones":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A11111111111111\/phone\/11111111111111",'+
    '"phone_no":"1001001000"'+
    '}'+
    '],'+
    '"emails":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A11111111111111\/email\/11111111111111",'+
    '"email_address":"ACustomer@retail.com"'+
    '}'+
    ']'+
    '},'+
    '{'+
    '"link":"\/v1\/rest\/customer\/A22222222222222",'+
    '"sid":"A2222222222222",'+
    '"last_name":"Sample Customer 2",'+
    '"first_name":"Bill",'+
    '"customer_id":820000361,'+
    '"primary_address_line_1":"2 Address Line 1",'+
    '"primary_address_line_2":"2 Address Line 2",'+
    '"full_name":"Bill Sample Customer 2",'+
    '"phones":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A22222222222222\/phone\/A22222222222222",'+
    '"phone_no":"1001001000"'+
    '}'+
    '],'+
    '"emails":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A22222222222222\/email\/A22222222222222",'+
    '"email_address":"BCustomer@retail.com"'+
    '}'+
    ']'+
    '},'+
    '{'+
    '"link":"\/v1\/rest\/customer\/A33333333333333",'+
    '"sid":"A33333333333333",'+
    '"last_name":"Sample Customer 3",'+
    '"first_name":"Charlie",'+
    '"customer_id":820000361,'+
    '"primary_address_line_1":"3 Address Line 1",'+
    '"primary_address_line_2":"3 Address Line 2",'+
    '"full_name":"Charlie Sample Customer 3",'+
    '"phones":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A33333333333333\/phone\/A33333333333333",'+
    '"phone_no":"1001001000"'+
    '}'+
    '],'+
    '"emails":['+
    '{'+
    '"link":"\/v1\/rest\/customer\/A33333333333333\/email\/A33333333333333",'+
    '"email_address":"CCustomer@retail.com"'+
    '}'+
    ']'+
    '}'+
    ']';

 cNewCustomer =
   '[{"origin_application":"RProPrismWeb","share_type":"0","first_name":"Test","last_name":"Testor"}]'; //Don't forget Info2
 cNewAddress =
   '[{"origin_application":"RProPrismWeb","address_type_sid":"394916319000178515","address_line_1":"Addr1","address_line_2":"Addr2","address_line_3":"Addr3","postal_code":"12345"}]';
 cNewPhone =
   '[{"origin_application":"RProPrismWeb","phone_type_sid":"394916319000176510","phone_no":"111-11-1111"}]';
 cNewEmail =
   '[{"origin_application":"RProPrismWeb","email_type_sid":"394916319000173506","email_address":"email@server.tld"}]';

implementation

end.
