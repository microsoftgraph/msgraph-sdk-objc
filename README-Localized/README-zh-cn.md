
# 适用于 ObjC 的 Microsoft Graph SDK


通过集成至 iOS 和 MacOS 应用，开始使用 Microsoft Graph SDK for ObjectiveC。

## 安装


### 使用 CocoaPods

可使用 [CocoaPods](https://cocoapods.org/) 保持拥有最新版本的软件。在配置文件中包含下列行：
  ``` 
   pod 'MSGraphClientSDK'
  ```


### 使用 Carthage



还可以选择使用 [Carthage](https://github.com/Carthage/Carthage) 管理程序包。



1. 使用网站中的下载内容或使用 Homebrew `brew install carthage` 安装 Carthage 至 Mac。

2. 必须创建在 Github 上列出此项目 MSGraphClientSDK 库的 `Cartfile`。



```

github "microsoftgraph/msgraph-sdk-objc" "tags/<latest\_release\_tag>"

```



3. 运行 `carthage 更新`。此操作将依赖项提取到 `Carthage/Checkouts` 文件夹，然后生成 MSGraphClientSDK 库。

4. 在应用程序目标的“常规”设置选项卡的“关联框架和库”部分中，从 `Carthage/Build` 文件夹中拖放 `MSGraphClientSDK.framework` 至磁盘上。

5. 在应用程序目标的“构建阶段”设置选项卡上，单击“+”图标并选择“新建运行脚本阶段”。创建指定 Shell 的“运行脚本”（例如：`/bin/sh`），添加下列内容至 Shell 下方脚本区：



```sh

/usr/local/bin/carthage copy-frameworks

```



并添加路径至希望在 “Input Files” 下使用的框架，如：



```

$(SRCROOT)/Carthage/Build/iOS/MSGraphClientSDK.framework

```

此脚本解决通用二进制文件触发的 [App Store 提交 bug](http://www.openradar.me/radar?id=6409498411401216)，并保证存档时复制所需的位代码相关文件和 dSYMs。



调试信息复制至构建产品目录中时，无论何时在断点停止，都能同步堆栈跟踪。这将能够让你在调试程序中逐步完成第三方代码。



存档应用程序以提交至 App Store 或 TestFlight 时，Xcode 还将复制这些文件至 应用程序的 `.xcarchive` 捆绑包的 dSYMs 子目录中。



## 先决条件

每次对 Microsoft Graph 进行网络调用，需要进行身份验证。因此，创建 MSHTTPClient 实例需要使用 MSAuthenticationProvider 协议实例作为参数。

可通过两种方式创建 MSAuthenticationProvider 实例：

### 使用[MSGraphMSALAuthProvider](https://github.com/microsoftgraph/msgraph-sdk-objc-auth)

此存储库通过 [MSAL](https://github.com/AzureAD/microsoft-authentication-library-for-objc) 处理身份验证应用场景。

### 编写 MSAuthenticationProvider 实现时

还可选择通过适合自己需要的方式处理身份认证。需要执行下列步骤，使此 SDK 可与身份验证机制交互。

1. 集成 SDK 后，必须通过创建新文件来提供 MSAuthenticationProvider 实现。

2. 在此文件中，针对下列 MSAuthenticationProvider 方法编写实现。

```

- (void) getAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;

```

此实现应能够与身份验证机制对话，以获取访问令牌或任何在过程期间出现的错误并返回至“completion block”中。

## 如何使用 SDK



如果完成上述步骤，现在将拥有：



1. 与 MSGraphClientSDK pod 集成的 .xcworkspace 文件或集成至项目中的 MSGraphClientSDK.framework。 



2. 实现 MSAuthenticationProvider 协议的类实例。



完成上述步骤后，需要执行以下步骤：



1. 按以下方式从 MSClientFactory 创建 MSHTTPClient 实例：

```

MSHTTPClient *httpClient = \[MSClientFactory createHTTPClientWithAuthenticationProvider:authenticationProvider];

```

2. 配置本地请求对象，外观可能如下：

```

NSMutableURLRequest *urlRequest = \[NSMutableURLRequest requestWithURL:\[NSURL URLWithString:\[MSGraphBaseURL stringByAppendingString:@"/me"]]];

```

3. 借助 MSHTTPClient 采用下列方式创建 MSURLSessionTask （在 DataTask 示例中）对象，并执行调用：

```

MSURLSessionDataTask *meDataTask = \[httpClient dataTaskWithRequest:urlRequest

completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

//做点什么

}];

\[meDataTask execute];

```



演示到此结束。现在你已成功调用 Graph 服务器，询问有关用户的信息。

## 使用资源

* [批处理](/Docs/Content/Batching.md)
* [页面迭代器](/Docs/Tasks/PageIterator.md)
* [大型文件上传任务](/Docs/Tasks/LargeFileUpload.md)
