@import "sha1.js"

@implementation YModel : CPObject
{
    CPString _url;
    CPString _masterPassword;
    int  _length;
    int  _uid;
    CPString _hashType;
    RegExp domainRegexp;
}

- (id) init
{
    [self setUrl:@""];
    [self setLength:27];
    [self setUid:0];
    [self setType:@"base64"];
    [self setMasterPassword:@"|\\/|4573R"];
	domainRegexp = new RegExp("^(.*://)?([^/]*?\\.)?([^/.]*\\.[^/.]*)(/.*?)?$");
    return self;
}

- (void) setMasterPassword:(CPString)aMasterPassword
{
    // console.log(@"YModel: setMasterPassword:%s", aMasterPassword);
    _masterPassword=aMasterPassword;
}
- (CPString) masterPassword
{
    // console.log(@"YModel: masterPassword: %d",_masterPassword);
    return _masterPassword;
}
- (void) setType:(CPString)anHashType
{
    // console.log(@"YModel: setType:%s", anHashType);
    _hashType=anHashType;
}
- (CPString) type
{
    // console.log(@"YModel: hashType: %d",_hashType);
    return _hashType;
}

- (void) setUrl:(CPString)aURL
{
    // console.log(@"YModel: setUrl:%s", aURL);
    _url=aURL;
}
- (CPString) url
{
    // console.log(@"YModel: url: %d",_url);
    return _url;
}

- (void) setLength:(int)aLength
{
    aLength=parseInt(aLength);
    // console.log(@"YModel: setLength:%d", aLength);
    _length=aLength;
}
- (int) length
{
    // console.log(@"YModel: length: %d",_length);
    return _length;
}

- (void) setUid:(int)anUid
{
    uid=parseInt(anUid);
    // console.log(@"YModel: setUid:%d", anUid);
    _uid=anUid;
}
- (int) uid
{
    // console.log(@"YModel: uid: %d",_uid);
    return _uid;
}

- (CPString) domain
{
   return _url.replace(domainRegexp,"$3"); 
}

- (CPString) password
{
    var toencrypt=[self masterPassword];
    var hash;
    if ( _uid > 0 ) {
        toencrypt=toencrypt+[self uid];
    }
    toencrypt=toencrypt+[self domain];
    if ( _hashType == "base64" ) {
        hash = b64_sha1(toencrypt);
    } else if ( _hashType == "hexa" ) {
        hash = hex_sha1(toencrypt);
    } else {
        // console.log(@"[YModel] password: unknown hashType: '%s'", hashType);
    }
    // console.log(@"YModel: password (toencrypt: %s)", toencrypt );
    return hash.substr(0,[self length]);
}
@end
