### JNPayManager如何使用

- 填写appScheme

 `JNPayManager.m`文件中宏定义appScheme
 
 
 - AppDelegate


 ```
 
 	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString 	*)sourceApplication annotation:(id)annotation
	{
    
    return [JNPayManager handleOpenURL:url];
    // 如果这里需要处理登陆的回调
    // return  [JNPayManager handleOpenURL:url] || [XXLoginManager handleOpenURL:url];

	}

	// NOTE: 9.0以后使用新API接口
	- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> 	*)options
	{
    
    // 同上
    return  [JNPayManager handleOpenURL:url] || [XXLoginManager handleOpenURL:url];
	
	}

 ```