<cfscript>

	// Define variables
	param name = "url.dest" default = "https://www.trinthlo.com";
	errorMessage = "";
	qrImage = "";

	// Define variables
	qrText = trim(url.dest);
	qrWidth  = 600;
	qrHeight = 600;
	qrMaxLength = 1000;

	// Validate text (longer text still fits in a QR code, but becomes too dense to scan reliably)
	if (! len(qrText)) errorMessage = "Please enter a URL or some text.";
	else if (len(qrText) gt qrMaxLength) errorMessage = "Please enter #qrMaxLength# characters or fewer. You entered #len(qrText)#.";

	// Create QR code image in memory
	if (! len(errorMessage)) {
		try {
			barCodeFormat = createObject("java", "com.google.zxing.BarcodeFormat");
			qrCodeWriter = createObject("java", "com.google.zxing.qrcode.QRCodeWriter");
			matrixToImageWriter = createObject("java", "com.google.zxing.client.j2se.MatrixToImageWriter");
			encodeHintType = createObject("java", "com.google.zxing.EncodeHintType");
			hashMap = createObject("java", "java.util.HashMap");
			hints = hashMap.init();
			hints.put(encodeHintType.MARGIN, javacast("int", 1));
			hints.put(encodeHintType.CHARACTER_SET, "UTF-8");
			bitMatrix = qrCodeWriter.encode(qrText, barCodeFormat.QR_CODE, javacast("int", qrWidth), javacast("int", qrHeight), hints);
			qrImage = imageNew(matrixToImageWriter.toBufferedImage(bitMatrix));
		} catch (Any e) {
			errorMessage = "The QR code could not be created: #e.message#";
		}
	}

</cfscript>

<cfoutput>

	<h1>QR Code Generator</h1>

	<p>
		This project is a simple web-based utility that turns a URL or any piece of text into a QR code image. Enter a web address, a short
		message, contact details, or any other text, and the page generates a square black and white code that phones and tablets can read with
		their camera to open the link or display the text. The image is created on the server using the open source ZXing library and is
		shown right on the page, where it can be saved, printed, or added to flyers, signs, business cards, and presentations. The tool is
		useful for quickly sharing a link without typing it, testing how a URL looks as a QR code before it goes to print, or checking that a
		code scans correctly on different devices.
	</p>

	<p><br /></p>

	<div class="row">
		<div class="col-md-6">

			<form method="get" action="index.cfm">

				<div class="row g-3 mb-2">
					<div class="col-md-12">
						<input type="text" name="dest" id="dest" value="#encodeForHtml(url.dest)#" class="form-control" placeholder="URL or text" maxlength="#qrMaxLength#" />
					</div>
				</div>

				<input type="submit" value="Submit" class="btn btn-primary" />

			</form>

		</div>
	</div>

	<p><br /></p>

	<cfif len(errorMessage)>
		<div class="alert alert-danger">#encodeForHtml(errorMessage)#</div>
	<cfelse>
		<cfimage action="writeToBrowser" source="#qrImage#" format="png" class="img-fluid qrcode" alt="QR code for #encodeForHtmlAttribute(qrText)#" />
	</cfif>

</cfoutput>
