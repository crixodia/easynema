import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/models/product.dart';

class InvoiceModelSnack {
  String date;
  List<Product> productos;
  List<int> cantidades;
  double total;
  List<String> to;
  Map<String, String>? message; // subject, text, html
  String qrData;

  InvoiceModelSnack(
      {required this.date,
      required this.total,
      required this.to,
      required this.qrData,
      required this.productos,
      required this.cantidades});

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'message': message,
    };
  }

  Future<DocumentReference> createInvoice() async {
    String subject = 'Detalle de compra - easynema';
    String text = qrData;
    String html = getHtml();
    message = {'subject': subject, 'text': text, 'html': html};
    return FirebaseFirestore.instance.collection('invoices').add(toJson());
  }

  String productsToString() {
    String products = '';
    for (int i = 0; i < productos.length; i++) {
      //<li style="font-size: 14px; line-height: 19.6px;"><strong>Combo n</strong>x1 - $2.80</li>
      products +=
          '<li style="font-size: 14px; line-height: 19.6px;"><strong>${productos[i].title}</strong>x${cantidades[i]} - \$${(productos[i].price * cantidades[i]).toStringAsFixed(2)} - ${productos[i].description}</li>';
    }
    return products;
  }

  String getHtml() {
    return '''
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
<!--[if gte mso 9]>
<xml>
  <o:OfficeDocumentSettings>
    <o:AllowPNG/>
    <o:PixelsPerInch>96</o:PixelsPerInch>
  </o:OfficeDocumentSettings>
</xml>
<![endif]-->
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="x-apple-disable-message-reformatting">
  <!--[if !mso]><!--><meta http-equiv="X-UA-Compatible" content="IE=edge"><!--<![endif]-->
  <title></title>
  
    <style type="text/css">
      @media only screen and (min-width: 520px) {
  .u-row {
    width: 500px !important;
  }
  .u-row .u-col {
    vertical-align: top;
  }

  .u-row .u-col-100 {
    width: 500px !important;
  }

}

@media (max-width: 520px) {
  .u-row-container {
    max-width: 100% !important;
    padding-left: 0px !important;
    padding-right: 0px !important;
  }
  .u-row .u-col {
    min-width: 320px !important;
    max-width: 100% !important;
    display: block !important;
  }
  .u-row {
    width: calc(100% - 40px) !important;
  }
  .u-col {
    width: 100% !important;
  }
  .u-col > div {
    margin: 0 auto;
  }
}
body {
  margin: 0;
  padding: 0;
}

table,
tr,
td {
  vertical-align: top;
  border-collapse: collapse;
}

p {
  margin: 0;
}

.ie-container table,
.mso-container table {
  table-layout: fixed;
}

* {
  line-height: inherit;
}

a[x-apple-data-detectors='true'] {
  color: inherit !important;
  text-decoration: none !important;
}

table, td { color: #000000; } #u_body a { color: #0000ee; text-decoration: underline; }
    </style>
  
  

</head>

<body class="clean-body u_body" style="margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #e7e7e7;color: #000000">
  <!--[if IE]><div class="ie-container"><![endif]-->
  <!--[if mso]><div class="mso-container"><![endif]-->
  <table id="u_body" style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #e7e7e7;width:100%" cellpadding="0" cellspacing="0">
  <tbody>
  <tr style="vertical-align: top">
    <td style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
    <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" style="background-color: #e7e7e7;"><![endif]-->
    

<div class="u-row-container" style="padding: 0px;background-color: transparent">
  <div class="u-row" style="Margin: 0 auto;min-width: 320px;max-width: 500px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: transparent;">
    <div style="border-collapse: collapse;display: table;width: 100%;height: 100%;background-color: transparent;">
      <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding: 0px;background-color: transparent;" align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:500px;"><tr style="background-color: transparent;"><![endif]-->
      
<!--[if (mso)|(IE)]><td align="center" width="500" style="width: 500px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;" valign="top"><![endif]-->
<div class="u-col u-col-100" style="max-width: 320px;min-width: 500px;display: table-cell;vertical-align: top;">
  <div style="height: 100%;width: 100% !important;">
  <!--[if (!mso)&(!IE)]><!--><div style="height: 100%; padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;"><!--<![endif]-->
  
<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
  <h1 style="margin: 0px; line-height: 140%; text-align: center; word-wrap: break-word; font-weight: normal; font-family: arial,helvetica,sans-serif; font-size: 22px;">
    <div><strong>easynema - Snacks</strong></div>
  </h1>

      </td>
    </tr>
  </tbody>
</table>

<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="padding-right: 0px;padding-left: 0px;" align="center">
      
      <img align="center" border="0" src="https://firebasestorage.googleapis.com/v0/b/easynema.appspot.com/o/assets%2Feasynema.png?alt=media&token=45ae72d3-a7c0-4cbd-b5a5-0df8d4cd3b1a" alt="" title="" style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 40%;max-width: 192px;" width="192"/>
      
    </td>
  </tr>
</table>

      </td>
    </tr>
  </tbody>
</table>

<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
  <div style="line-height: 140%; text-align: left; word-wrap: break-word;">
    <p style="font-size: 14px; line-height: 140%; text-align: center;"><span style="font-size: 18px; line-height: 25.2px;"><strong>Has comprado los siguientes snacks:</strong></span></p>
<ul>
${productsToString()}
</ul>
  </div>

      </td>
    </tr>
  </tbody>
</table>

<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
  <div style="line-height: 140%; text-align: left; word-wrap: break-word;">
    <p style="font-size: 14px; line-height: 140%; text-align: center;"><span style="font-size: 20px; line-height: 28px;"><strong>Total: </strong>\$${total.toStringAsFixed(2)}</span></p>
  </div>

      </td>
    </tr>
  </tbody>
</table>

<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td style="padding-right: 0px;padding-left: 0px;" align="center">
      
      <img align="center" border="0" src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrData" alt="" title="" style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 50%;max-width: 240px;" width="240"/>
      
    </td>
  </tr>
</table>

      </td>
    </tr>
  </tbody>
</table>

<table style="font-family:arial,helvetica,sans-serif;" role="presentation" cellpadding="0" cellspacing="0" width="100%" border="0">
  <tbody>
    <tr>
      <td style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:arial,helvetica,sans-serif;" align="left">
        
<div align="center">
  <div style="display: table; max-width:110px;">
  <!--[if (mso)|(IE)]><table width="110" cellpadding="0" cellspacing="0" border="0"><tr><td style="border-collapse:collapse;" align="center"><table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse; mso-table-lspace: 0pt;mso-table-rspace: 0pt; width:110px;"><tr><![endif]-->
  
    
    <!--[if (mso)|(IE)]><td width="32" style="width:32px; padding-right: 5px;" valign="top"><![endif]-->
    <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32" style="width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 5px">
      <tbody><tr style="vertical-align: top"><td align="left" valign="middle" style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
        <a href="https://facebook.com/" title="Facebook" target="_blank">
          <img src="https://firebasestorage.googleapis.com/v0/b/easynema.appspot.com/o/assets%2Ffacebook.png?alt=media&token=2549e6e4-2d99-4db3-9351-7e23f5c123e3" alt="Facebook" title="Facebook" width="32" style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
        </a>
      </td></tr>
    </tbody></table>
    <!--[if (mso)|(IE)]></td><![endif]-->
    
    <!--[if (mso)|(IE)]><td width="32" style="width:32px; padding-right: 5px;" valign="top"><![endif]-->
    <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32" style="width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 5px">
      <tbody><tr style="vertical-align: top"><td align="left" valign="middle" style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
        <a href="https://instagram.com/" title="Instagram" target="_blank">
          <img src="https://firebasestorage.googleapis.com/v0/b/easynema.appspot.com/o/assets%2Finstagram.png?alt=media&token=55f36d86-37b4-4e75-8151-4f8c491aaa7f" alt="Instagram" title="Instagram" width="32" style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
        </a>
      </td></tr>
    </tbody></table>
    <!--[if (mso)|(IE)]></td><![endif]-->
    
    <!--[if (mso)|(IE)]><td width="32" style="width:32px; padding-right: 0px;" valign="top"><![endif]-->
    <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32" style="width: 32px !important;height: 32px !important;display: inline-block;border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 0px">
      <tbody><tr style="vertical-align: top"><td align="left" valign="middle" style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
        <a href="https://twitter.com/" title="Twitter" target="_blank">
          <img src="https://firebasestorage.googleapis.com/v0/b/easynema.appspot.com/o/assets%2Ftwitter.png?alt=media&token=edb35c3b-2b52-4560-82dc-be62326f2dbf" alt="Twitter" title="Twitter" width="32" style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
        </a>
      </td></tr>
    </tbody></table>
    <!--[if (mso)|(IE)]></td><![endif]-->
    
    
    <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->
  </div>
</div>

      </td>
    </tr>
  </tbody>
</table>

  <!--[if (!mso)&(!IE)]><!--></div><!--<![endif]-->
  </div>
</div>
<!--[if (mso)|(IE)]></td><![endif]-->
      <!--[if (mso)|(IE)]></tr></table></td></tr></table><![endif]-->
    </div>
  </div>
</div>


    <!--[if (mso)|(IE)]></td></tr></table><![endif]-->
    </td>
  </tr>
  </tbody>
  </table>
  <!--[if mso]></div><![endif]-->
  <!--[if IE]></div><![endif]-->
</body>

</html>

''';
  }
}
