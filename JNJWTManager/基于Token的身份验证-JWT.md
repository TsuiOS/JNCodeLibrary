### 基于Token的身份验证——JWT

JWT就是一个字符串，经过加密处理与校验处理的字符串，形式为：`A.B.C`
> A由JWT头部信息header加密得到<br>
> B由JWT用到的身份验证信息json数据加密得到<br>
> C由A和B加密得到，是校验部分

- 怎样生成A？

header格式为

```
{
    "typ": "JWT",
    "alg": "RS256" 
}
```
它就是一个json串，两个字段是必须的，不能多也不能少。alg字段指定了生成C的算法，默认值是HS256
将header用Base64Url编码，得到A
通常，JWT库中，可以把A部分固定写死，用户最多指定一个alg的取值

- 怎么生成B(载荷Payload) ?
我们先将用户认证的操作描述成一个JSON对象。其中添加了一些其他的信息，帮助今后收到这个JWT的服务器理解这个JWT。

```
{
    "sub": "1",
    "iss": "http://localhost:8000/auth/login",
    "iat": 1451888119,
    "exp": 1454516119,
    "nbf": 1451888119,
    "jti": "37c107e4609ddbcc9c096ea5ee76c667"
}

```
将上面的JSON对象进行Base64Url编码,得到B

- 怎样计算C ？

将A.B使用RS256加密（其实是用header中指定的算法），当然加密过程中还需要密钥（自行指定的一个字符串）。
加密得到C，学名signature，其实就是一个字符串。作用类似于CRC校验，保证加密没有问题。
现在A.B.C就是生成的token了。

可以使用
[JWT调试](https://jwt.io/#debugger-io)

![image](http://7xsi0q.com1.z0.glb.clouddn.com/Snip20180511_2.png)

### JWT

Objective-C JWT [https://github.com/yourkarma/JWT](https://github.com/yourkarma/JWT)


我们使用的是RSA256
文档
```
// Encode
NSDictionary *payload = @{@"payload" : @"hidden_information"};
NSString *algorithmName = @"RS256";

NSString *filePath = [[NSBundle mainBundle] pathForResource:@"secret_key" ofType:@"p12"];
NSData *privateKeySecretData = [NSData dataWithContentsOfFile:filePath];

NSString *passphraseForPrivateKey = @"secret";

JWTBuilder *builder = [JWTBuilder encodePayload:payload].secretData(privateKeySecretData).privateKeyCertificatePassphrase(passphraseForPrivateKey).algorithmName(algorithmName);
NSString *token = builder.encode;

// check error
if (builder.jwtError == nil) {
    // handle result
}
else {
    // error occurred.
}

// Decode
// Suppose, that you get token from previous example. You need a valid public key for a private key in previous example.
// Private key stored in @"secret_key.p12". So, you need public key for that private key.
NSString *publicKey = @"..."; // load public key. Or use it as raw string.

algorithmName = @"RS256";

JWTBuilder *decodeBuilder = [JWTBuilder decodeMessage:token].secret(publicKey).algorithmName(algorithmName);
NSDictionary *envelopedPayload = decodeBuilder.decode;

// check error
if (decodeBuilder.jwtError == nil) {
    // handle result
}
else {
    // error occurred.
}
```

### 生成公钥和私钥

- 使用openssl生成所需秘钥文件

生成环境是在mac系统下，使用openssl进行生成，首先打开终端，按下面这些步骤依次来做：打开openssl

1.生成模长为1024bit的私钥文件`private_key.pem`

```
genrsa -out private_key.pem 1024
```
2. 生成证书请求文件`rsaCertReq.csr`

```
req -new -key private_key.pem -out rsaCerReq.csr
```
注意：这一步会提示输入国家、省份、mail等信息，可以根据实际情况填写,我测试了不填写的情况,会报错.这里会提示输入密码
3. 生成证书`rsaCert.crt`，并设置有效时间为10年

```
x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt
```
4. 生成供iOS使用的公钥文件`public_key.der`
```
x509 -outform der -in rsaCert.crt -out public_key.der
```
5. 生成供iOS使用的私钥文件`private_key.p12`
```
pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
```
注意：这一步会提示给私钥文件设置密码，直接输入想要设置密码即可，然后敲回车，然后再验证刚才设置的密码，再次输入密码，然后敲回车，完毕！
在解密时，private_key.p12文件需要和这里设置的密码配合使用，因此需要牢记此密码.
6. 生成供Java使用的公钥`rsa_public_key.pem`
```
rsa -in private_key.pem -out rsa_public_key.pem -pubout
```
7. 生成供Java使用的私钥`pkcs8_private_key.pem`

```
pkcs8 -topk8 -in private_key.pem -out pkcs8_private_key.pem -nocrypt
```
把.der和.p12格式的秘钥文件导入工程中,把私钥和秘钥发给后台,使用一套私钥秘钥,就完成了JWT token的生成!

> 参考博客<br>
[基于Token的身份验证——JWT](http://www.cnblogs.com/zjutzz/p/5790180.html)<br>
[JWT的定义及其组成](https://www.jianshu.com/p/168d34aab2e3)<br>
[初步理解JWT并实践使用](https://www.jianshu.com/p/2fdc20a42c41)<br>
[iOS中使用RSA加密](https://www.jianshu.com/p/74a796ec5038)<br>
[iOS之RSA加密解密与后台之间的双向加密详解](https://www.jianshu.com/p/43f7fc8d8e14)<br>
[iOS网络请求安全（JWT，RSA）](https://www.jianshu.com/p/08b85f749c86)

